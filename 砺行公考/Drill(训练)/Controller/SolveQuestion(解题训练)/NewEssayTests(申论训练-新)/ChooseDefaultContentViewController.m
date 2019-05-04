//
//  ChooseDefaultContentViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/23.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "ChooseDefaultContentViewController.h"
#import "ShowAndWriteTableViewCell.h"
#import "BigEssayWriteContentViewController.h"
#import "BigEssayWriteAnalysisViewController.h"
#import "BigEssayWriteMeasuresViewController.h"

@interface ChooseDefaultContentViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *dataArray;

/**
 记录选择的默认示范
 */
@property (nonatomic, strong) NSString *choosed_default_content;

@end

@implementation ChooseDefaultContentViewController

- (void)getDefaultData {
    NSString *require_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"BigEssayQuestionID"];
    NSString *type = @"1";
    switch (self.type) {
        case ChooseContentType_YinYan:
            type = @"1";
            break;
        case ChooseContentType_FenXi:
            type = @"2";
            break;
        case ChooseContentType_ChengJie:
            type = @"3";
            break;
        case ChooseContentType_DuiCe:
            type = @"4";
            break;
        case ChooseContentType_JieWei:
            type = @"5";
            break;
        default:
            break;
    }
    
    NSDictionary *param = @{@"require_id_":require_id,
                            @"type_":type};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_big_essay_detail" Dic:param SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            weakSelf.dataArray = responseObject[@"data"];
            [weakSelf.tableview reloadData];
        }
    } FailureBlock:^(id error) {
        
    }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"选择内容";
    [self setBack];
    [self setleftOrRight:@"right" BarButtonItemWithTitle:@"下一步" target:self action:@selector(pushNextVC)];
    
    __weak typeof(self) weakSelf = self;
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.estimatedRowHeight = 0.0;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[ShowAndWriteTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self getDefaultData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShowAndWriteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textview.scrollEnabled = NO;
    cell.textview.editable = NO;
    cell.textview.userInteractionEnabled = NO;
    cell.textview.text = self.dataArray[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *string = self.dataArray[indexPath.section];
    return [self calculateRowHeight:string fontSize:14 withWidth:SCREENBOUNDS.width - 80.0] + 60.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    header_view.backgroundColor = WhiteColor;
    [self setHeaderView:header_view withSection:section];
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    return footer_view;
}

- (void)setHeaderView:(UIView *)header_view withSection:(NSInteger)section {
    NSString *section_title = @"";
    switch (self.type) {
        case ChooseContentType_YinYan:
            section_title = @"引言";
            break;
        case ChooseContentType_FenXi:
            section_title = @"分析";
            break;
        case ChooseContentType_ChengJie:
            section_title = @"承接";
            break;
        case ChooseContentType_DuiCe:
            section_title = @"对策";
            break;
        case ChooseContentType_JieWei:
            section_title = @"结尾";
            break;
        default:
            break;
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.textColor = DetailTextColor;
    label.text = [NSString stringWithFormat:@"%@%ld", section_title, section + 1];
    [header_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header_view.mas_left).offset(20);
        make.centerY.equalTo(header_view.mas_centerY);
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ShowAndWriteTableViewCell *cell = (ShowAndWriteTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.back_view.backgroundColor = ButtonColor;
    cell.textview.backgroundColor = ButtonColor;
    cell.textview.textColor = WhiteColor;
    self.choosed_default_content = self.dataArray[indexPath.section];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    ShowAndWriteTableViewCell *cell = (ShowAndWriteTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.back_view.backgroundColor = SetColor(246, 246, 246, 1);
    cell.textview.backgroundColor = SetColor(246, 246, 246, 1);
    cell.textview.textColor = [UIColor blackColor];
}

- (void)pushNextVC {
    switch (self.type) {
        case ChooseContentType_YinYan:
        {
            BigEssayWriteContentViewController *writeContent = [[BigEssayWriteContentViewController alloc] init];
            writeContent.type = WriteContentType_YinYan;
            writeContent.default_content = self.choosed_default_content;
            [self.navigationController pushViewController:writeContent animated:YES];
        }
            break;
        case ChooseContentType_FenXi:
        {
            BigEssayWriteAnalysisViewController *analysis = [[BigEssayWriteAnalysisViewController alloc] init];
            analysis.default_content = self.choosed_default_content;
            [self.navigationController pushViewController:analysis animated:YES];
        }
            break;
        case ChooseContentType_ChengJie:
        {
            BigEssayWriteContentViewController *writeContent = [[BigEssayWriteContentViewController alloc] init];
            writeContent.type = WriteContentType_ChengJie;
            writeContent.default_content = self.choosed_default_content;
            [self.navigationController pushViewController:writeContent animated:YES];
        }
            break;
        case ChooseContentType_DuiCe:
        {
            BigEssayWriteMeasuresViewController *measures = [[BigEssayWriteMeasuresViewController alloc] init];
            measures.default_content = self.choosed_default_content;
            [self.navigationController pushViewController:measures animated:YES];
        }
            break;
        case ChooseContentType_JieWei:
        {
            BigEssayWriteContentViewController *writeContent = [[BigEssayWriteContentViewController alloc] init];
            writeContent.type = WriteContentType_JieWei;
            writeContent.default_content = self.choosed_default_content;
            [self.navigationController pushViewController:writeContent animated:YES];
        }
            break;
        default:
            break;
    }
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
