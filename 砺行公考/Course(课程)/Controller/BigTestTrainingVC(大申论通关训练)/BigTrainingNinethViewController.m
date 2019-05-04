//
//  BigTrainingNinethViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/12.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "BigTrainingNinethViewController.h"
#import "BannerView.h"
#import "ShowAndWriteTableViewCell.h"
#import "BigTrainingTableViewCell.h"
#import "CustomBigTrainingModel.h"
#import "LabelTableViewCell.h"
#import "BigTrainingTenthViewController.h"
#import "CustomTitleView.h"
#import "BottomShowMaterialsView.h"
#import "QuanZhenTestModel.h"
#import "CurrentQuestionInfoView.h"

@interface BigTrainingNinethViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSMutableArray *dataArray;

/** 存储分析内容 （不是总括句）*/
@property (nonatomic, strong) NSMutableArray *fenxi_section_array;

/** 引言段有几块 */
@property (nonatomic, assign) NSInteger fenxi_data_count;

@property (nonatomic, strong) UITableView *leftTableview;

/** 左侧tableview的cell高度 */
@property (nonatomic, strong) NSMutableArray *leftTableCellHeight;

@property (nonatomic, strong) UILabel *left_tableview_label;

@end

@implementation BigTrainingNinethViewController

- (void)formatterData {
    CGFloat width = (SCREENBOUNDS.width - 40) / 10 * 9 - 80;
    //标题
    NSString *my_title = [[NSUserDefaults standardUserDefaults] objectForKey:@"BigTraining_my_title"];
    //计算我的标题的高度
    CGFloat my_title_height = [self calculateRowHeight:my_title fontSize:14 withWidth:width];
    [self.dataArray addObject:@[@{@"content":my_title,@"height":@(my_title_height + 80.0)}]];
    [self.leftTableCellHeight addObject:[NSString stringWithFormat:@"%f", my_title_height + 80.0]];
    
    //引言
    NSString *yinyan_string = [NSString stringWithContentsOfFile:BigTraining_YinYan_File_Data encoding:NSUTF8StringEncoding error:nil];
    //计算引言的高度
    CGFloat yinyan_height = [self calculateRowHeight:yinyan_string fontSize:14 withWidth:width];
    [self.dataArray addObject:@[@{@"content":yinyan_string,@"height":@(yinyan_height + 80.0)}]];
    [self.leftTableCellHeight addObject:[NSString stringWithFormat:@"%f", yinyan_height + 80.0]];
    
    //分析
    NSArray *fenxi_array = [NSKeyedUnarchiver unarchiveObjectWithFile:BigTraining_FenXi_File_Data];
    self.fenxi_data_count = fenxi_array.count;
    CGFloat fenxi_finish_height = 0.0;
    for (CustomBigTrainingModel *model in fenxi_array) {
        [self.fenxi_section_array addObject:model.content];
        NSMutableArray *small_array = [NSMutableArray arrayWithCapacity:1];
        for (SmallContentModel *smallModel in model.small_content_array) {
            CGFloat small_content_height = [self calculateRowHeight:smallModel.small_content fontSize:14 withWidth:width - 40.0];
            [small_array addObject:@{@"content":smallModel.small_content,@"height":@(small_content_height + 40.0)}];
            fenxi_finish_height += (small_content_height + 40.0);
        }
        [self.dataArray addObject:small_array];
    }
    [self.leftTableCellHeight addObject:[NSString stringWithFormat:@"%f", fenxi_finish_height + 120.0]];
    
    //承接
    NSString *chengjie_string = [NSString stringWithContentsOfFile:BigTraining_ChengJie_File_Data encoding:NSUTF8StringEncoding error:nil];
    //计算承接段的高度
    CGFloat chengjie_height = [self calculateRowHeight:yinyan_string fontSize:14 withWidth:width];
    [self.dataArray addObject:@[@{@"content":chengjie_string,@"height":@(chengjie_height + 80.0)}]];
    
    [self.leftTableCellHeight addObject:[NSString stringWithFormat:@"%f", chengjie_height + 80.0]];
    
    //对策
    NSArray *duice_array = [NSKeyedUnarchiver unarchiveObjectWithFile:BigTraining_DuiCe_File_Data];
    NSMutableArray *duice_data_array = [NSMutableArray arrayWithCapacity:1];
    CGFloat chengjie_finish_height = 0.0;
    for (CustomBigTrainingModel *model in duice_array) {
        CGFloat duice_height = [self calculateRowHeight:model.content fontSize:14 withWidth:width];
        [duice_data_array addObject:@{@"content":model.content,@"height":@(duice_height + 40.0)}];
        chengjie_finish_height += (duice_height + 40.0);
    }
    [self.dataArray addObject:duice_data_array];
    [self.leftTableCellHeight addObject:[NSString stringWithFormat:@"%f", chengjie_finish_height]];
    
    //结尾
    NSString *end_string = [NSString stringWithContentsOfFile:BigTraining_JieWei_File_Data encoding:NSUTF8StringEncoding error:nil];
    //计算结尾段的高度
    CGFloat end_height = [self calculateRowHeight:end_string fontSize:14 withWidth:width];
    [self.dataArray addObject:@[@{@"content":end_string,@"height":@(end_height + 80.0)}]];
    [self.leftTableCellHeight addObject:[NSString stringWithFormat:@"%f", end_height + 80.0]];
    [self.tableview reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    self.fenxi_section_array = [NSMutableArray arrayWithCapacity:1];
    self.leftTableCellHeight = [NSMutableArray arrayWithCapacity:1];
    
    [self setleftOrRight:@"right" BarButtonItemWithTitle:@"下一步" target:self action:@selector(pushTenthVC)];
    
    [self setTitleView];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(16);
    label.text = @"逻辑树图";
    [self.view addSubview:label];
    __weak typeof(self) weakSelf = self;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(10);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    CGFloat width_index = (SCREENBOUNDS.width - 40) / 10;
    
    self.leftTableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.leftTableview.tag = 1000;
    self.leftTableview.backgroundColor = WhiteColor;
    self.leftTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.leftTableview.delegate = self;
    self.leftTableview.dataSource = self;
    [self.leftTableview registerClass:[LabelTableViewCell class] forCellReuseIdentifier:@"leftCell"];
    [self.view addSubview:self.leftTableview];
    [self.leftTableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(5);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.width.mas_equalTo(width_index);
    }];
    
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = WhiteColor;
    self.tableview.tag = 2000;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[ShowAndWriteTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.tableview registerClass:[BigTrainingTableViewCell class] forCellReuseIdentifier:@"twoCell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(5);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.width.mas_equalTo(width_index * 9);
    }];
    
    [self formatterData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView.tag == 1000) {
        return self.leftTableCellHeight.count;
    }else {
        return self.dataArray.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 1000) {
        return 1;
    }else {
        return [self.dataArray[section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1000) {
        LabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leftCell"];
        cell.label.text = @[@"标题",@"引言",@"分析",@"承接",@"对策",@"结尾"][indexPath.section];
        return cell;
    }else {
        NSDictionary *dic = self.dataArray[indexPath.section][indexPath.row];
        if (indexPath.section >= 2 && indexPath.section <= self.fenxi_data_count + 1) {
            BigTrainingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"twoCell"];
            cell.isShowLeftImage = YES;
            cell.content_textview.text = dic[@"content"];
            return cell;
        }else if (indexPath.section == self.fenxi_data_count + 3) {
            BigTrainingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"twoCell"];
            cell.isShowLeftImage = NO;
            cell.content_textview.text = dic[@"content"];
            
            return cell;
        }
        ShowAndWriteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        cell.textview.scrollEnabled = NO;
        cell.textview.text = dic[@"content"];//@"在这里，魔法不只是一种神秘莫测的能量概念。它是实体化的物质，可以被引导、成形、塑造和操作。符文之地的魔法拥有自己的自然法则。源生态魔法随机变化的结果改变了科学法则。符文之地有数块大陆，不过所有的生命都集中在最大魔法大陆——瓦罗兰";
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 1000) {
        NSString *height = self.leftTableCellHeight[indexPath.section];
        return [height floatValue];
    }else {
        NSDictionary *dic = self.dataArray[indexPath.section][indexPath.row];
        return [dic[@"height"] floatValue];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.tag == 1000) {
        return 0.0;
    }else {
        if (section >= 2 && section <= self.fenxi_data_count + 1) {
            return 60.0;
        }
        return 0.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    if (tableView.tag == 2000) {
        if (section >= 2 && section <= self.fenxi_data_count + 1) {
            [self setHeaderView:header_view withSection:section];
        }
    }
    return header_view;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    return footer_view;
}

- (void)setHeaderView:(UIView *)header_view withSection:(NSInteger)section {
    header_view.backgroundColor = WhiteColor;
    UITextField *user_title = [[UITextField alloc] init];
    user_title.backgroundColor = SetColor(246, 246, 246, 1);
    user_title.font = SetFont(14);
    user_title.textColor = SetColor(74, 74, 74, 1);
    
    UILabel *left_label = [[UILabel alloc] initWithFrame:FRAME(0, 0, 20, 0)];
    user_title.leftView = left_label;
    user_title.leftViewMode = UITextFieldViewModeAlways;
    
    user_title.placeholder = @"分析内容";
    user_title.text = self.fenxi_section_array[section - 2];
    ViewRadius(user_title, 8.0);
    user_title.tag = section;
    [header_view addSubview:user_title];
    [user_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header_view.mas_top).offset(5);
        make.left.equalTo(header_view.mas_left).offset(20);
        make.right.equalTo(header_view.mas_right).offset(-20);
        make.height.mas_equalTo(50.0);
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.leftTableview.contentOffset = scrollView.contentOffset;
    self.tableview.contentOffset = scrollView.contentOffset;
}

- (void)pushTenthVC {
    BigTrainingTenthViewController *ten = [[BigTrainingTenthViewController alloc] init];
    [self.navigationController pushViewController:ten animated:YES];
}

- (void)setTitleView {
    CustomTitleView *titleView = [[CustomTitleView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 40.0)];
    self.navigationItem.titleView = titleView;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = SetFont(14);
    button.backgroundColor = SetColor(246, 246, 246, 1);
    [button setTitleColor:DetailTextColor forState:UIControlStateNormal];
    [button setTitle:@"材料" forState:UIControlStateNormal];
    ViewRadius(button, 8.0);
    [titleView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView.mas_centerY);
        make.left.equalTo(titleView.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake((SCREENBOUNDS.width - 70 - 110) / 2, 30.0));
    }];
    [button addTarget:self action:@selector(touchShowMaterialsAction) forControlEvents:UIControlEventTouchUpInside];
    //题目按钮
    UIButton *showQuestionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    showQuestionButton.titleLabel.font = SetFont(14);
    showQuestionButton.backgroundColor = SetColor(246, 246, 246, 1);
    [showQuestionButton setTitleColor:DetailTextColor forState:UIControlStateNormal];
    [showQuestionButton setTitle:@"题目" forState:UIControlStateNormal];
    ViewRadius(showQuestionButton, 8.0);
    [titleView addSubview:showQuestionButton];
    [showQuestionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(titleView.mas_centerY);
        make.left.equalTo(button.mas_right).offset(30);
        make.size.equalTo(button);
    }];
    [showQuestionButton addTarget:self action:@selector(showQuestionAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)touchShowMaterialsAction {
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"exam_id_":[[NSUserDefaults standardUserDefaults] objectForKey:@"bigTestTrainingExamID"],
                            @"order_":@"1"};
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/course/five_training/find_material_list" Dic:param SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            NSMutableArray *data = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *dic in responseObject[@"data"]) {
                EssayTestQuanZhenMaterialsModel *model = [[EssayTestQuanZhenMaterialsModel alloc] init];
                model.materials_id = @"";
                model.materials_content = dic[@"content_"];
                model.materials_image_array = @[];
                [data addObject:model];
            }
            [weakSelf showMaterialsView:[data copy]];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)showMaterialsView:(NSArray *)array {
    AppDelegate *delegate_app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    BottomShowMaterialsView *materials_view = [[BottomShowMaterialsView alloc] initWithFrame:delegate_app.window.bounds];
    materials_view.dataArray = array;
    [delegate_app.window addSubview:materials_view];
}

//显示题目数据
- (void)showQuestionAction {
    NSString *info_string = [NSString  stringWithContentsOfFile:CurrentTestTraining_QuestionInfo_File_Data encoding:NSUTF8StringEncoding error:nil];
    AppDelegate *current_window = (AppDelegate *)[UIApplication sharedApplication].delegate;
    CurrentQuestionInfoView *questionInfo_view = [[CurrentQuestionInfoView alloc] initWithFrame:current_window.window.bounds withInfoString:info_string];
    [current_window.window addSubview:questionInfo_view];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
