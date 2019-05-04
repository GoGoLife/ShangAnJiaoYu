//
//  BigTrainingThirdViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/12.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "BigTrainingThirdViewController.h"
#import "BigTrainingFourthViewController.h"
#import "CustomTitleView.h"
#import "BottomShowMaterialsView.h"
#import "QuanZhenTestModel.h"
#import "CurrentQuestionInfoView.h"

@interface BigTrainingThirdViewController ()

@property (nonatomic, strong) UITextField *user_title;

@property (nonatomic, strong) UITextView *demonstration_textview;

@end

@implementation BigTrainingThirdViewController

/**
 请求示范标题
 */
- (void)getData {
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"exam_id_":@"25d6ad35439d4fc4ba5cc6b833f3d275",@"order_":@"1"};
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/course/five_training/find_demonstration_title" Dic:param SuccessBlock:^(id responseObject) {
        NSLog(@"default title == %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            [weakSelf.view layoutIfNeeded];
            NSString *finish_string = @"";
            for (NSDictionary *dic in responseObject[@"data"]) {
                finish_string = [finish_string stringByAppendingString:[NSString stringWithFormat:@"%@\n\n", dic[@"title_"]]];
            }
            finish_string = [finish_string substringToIndex:finish_string.length - 2];
            weakSelf.demonstration_textview.text = finish_string;
            CGFloat height = [self calculateRowHeight:finish_string fontSize:14 withWidth:SCREENBOUNDS.width - 80];
            [weakSelf.demonstration_textview mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(height + 40.0);
            }];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改标题";
    [self setBack];
    
    [self setleftOrRight:@"right" BarButtonItemWithTitle:@"下一步" target:self action:@selector(pushFourthVC)];
    
    [self setTitleView];
    
    UILabel *first_label = [[UILabel alloc] init];
    first_label.font = SetFont(14);
    first_label.textColor = DetailTextColor;
    first_label.text = @"示范标题";
    [self.view addSubview:first_label];
    __weak typeof(self) weakSelf = self;
    [first_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(10);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
    }];
    
    self.demonstration_textview = [[UITextView alloc] init];
    self.demonstration_textview.scrollEnabled = NO;
    self.demonstration_textview.font = SetFont(14);
    self.demonstration_textview.backgroundColor = SetColor(246, 246, 246, 1);
    self.demonstration_textview.textContainerInset = UIEdgeInsetsMake(20, 20, 20, 20);
    ViewRadius(self.demonstration_textview, 8.0);
//    self.demonstration_textview.text = @"1、示范标题 \n\n2、示范标题 \n\n3、示范标题 \n\n4、示范标题 \n\n5、示范标题 \n\n6、示范标题";
    [self.view addSubview:self.demonstration_textview];
    [self.demonstration_textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(first_label.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.mas_greaterThanOrEqualTo(230.0);
    }];
    
    UILabel *second_label = [[UILabel alloc] init];
    second_label.font = SetFont(14);
    second_label.textColor = DetailTextColor;
    second_label.text = @"我的标题";
    [self.view addSubview:second_label];
    [second_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.demonstration_textview.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.demonstration_textview.mas_left);
    }];
    
    self.user_title = [[UITextField alloc] init];
    self.user_title.backgroundColor = SetColor(246, 246, 246, 1);
    self.user_title.font = SetFont(14);
    self.user_title.textColor = SetColor(74, 74, 74, 1);
    
    UILabel *left_label = [[UILabel alloc] initWithFrame:FRAME(0, 0, 20, 0)];
    self.user_title.leftView = left_label;
    self.user_title.leftViewMode = UITextFieldViewModeAlways;
    self.user_title.text = self.my_title;
    ViewRadius(self.user_title, 8.0);
    [self.view addSubview:self.user_title];
    [self.user_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(second_label.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.mas_equalTo(50.0);
    }];
    
    [self getData];
}

- (void)pushFourthVC {
    //本地化我的标题（大申论通关训练）
    [[NSUserDefaults standardUserDefaults] setObject:self.user_title.text forKey:@"BigTraining_my_title"];
    BigTrainingFourthViewController *fourth = [[BigTrainingFourthViewController alloc] init];
    [self.navigationController pushViewController:fourth animated:YES];
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
