//
//  BigTrainingSecondViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/12.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "BigTrainingSecondViewController.h"
#import "BigTrainingThirdViewController.h"
#import "CustomTitleView.h"
#import "BottomShowMaterialsView.h"
#import "QuanZhenTestModel.h"

@interface BigTrainingSecondViewController ()

@property (nonatomic, strong) UITextField *user_title;

@end

@implementation BigTrainingSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"第二步：撰写标题";
    [self setBack];
    
    [self setleftOrRight:@"right" BarButtonItemWithTitle:@"下一步" target:self action:@selector(pushThirdVC)];
    
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
        make.edges.equalTo(titleView).insets(UIEdgeInsetsMake(10, 20, 10, 20));
    }];
    [button addTarget:self action:@selector(touchShowMaterialsAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self setHeaderView:self.view];
}

- (void)setHeaderView:(UIView *)header_view {
    header_view.backgroundColor = WhiteColor;
    UILabel *title_label = [[UILabel alloc] init];
    title_label.font = SetFont(14);
    title_label.textColor = DetailTextColor;
    title_label.text = @"2017年浙江省副省级考卷·第三题";
    [header_view addSubview:title_label];
    [title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header_view.mas_top).offset(10);
        make.left.equalTo(header_view.mas_left).offset(20);
    }];
    
    UILabel *question_content = [[UILabel alloc] init];
    question_content.font = SetFont(16);
    question_content.numberOfLines = 0;
    question_content.text = self.model.question_title;
    [header_view addSubview:question_content];
    [question_content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title_label.mas_bottom).offset(10);
        make.left.equalTo(title_label.mas_left);
        make.right.equalTo(header_view.mas_right).offset(-20);
    }];
    
    UILabel *require_label = [[UILabel alloc] init];
    require_label.font = SetFont(14);
    require_label.textColor = DetailTextColor;
    require_label.numberOfLines = 0;
    require_label.text = self.model.finish_require_string;
    [header_view addSubview:require_label];
    [require_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(question_content.mas_bottom).offset(5);
        make.left.equalTo(question_content.mas_left);
        make.right.equalTo(question_content.mas_right);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SetColor(246, 246, 246, 1);
    [header_view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(require_label.mas_bottom).offset(10);
        make.left.equalTo(header_view.mas_left);
        make.right.equalTo(header_view.mas_right);
        make.height.mas_equalTo(10);
    }];
    
    UILabel *user_label = [[UILabel alloc] init];
    user_label.font = SetFont(14);
    user_label.textColor = DetailTextColor;
    user_label.text = @"请拟定您的标题";
    [header_view addSubview:user_label];
    [user_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(20);
        make.left.equalTo(header_view.mas_left).offset(20);
    }];
    
    self.user_title = [[UITextField alloc] init];
    self.user_title.backgroundColor = SetColor(246, 246, 246, 1);
    self.user_title.font = SetFont(14);
    self.user_title.textColor = SetColor(74, 74, 74, 1);
    
    UILabel *left_label = [[UILabel alloc] initWithFrame:FRAME(0, 0, 20, 0)];
    self.user_title.leftView = left_label;
    self.user_title.leftViewMode = UITextFieldViewModeAlways;
    
    self.user_title.placeholder = @"在此输入标题";
    ViewRadius(self.user_title, 8.0);
    [header_view addSubview:self.user_title];
    [self.user_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(user_label.mas_bottom).offset(20);
        make.left.equalTo(header_view.mas_left).offset(20);
        make.right.equalTo(header_view.mas_right).offset(-20);
        make.height.mas_equalTo(50.0);
    }];
}

- (void)pushThirdVC {
    BigTrainingThirdViewController *third = [[BigTrainingThirdViewController alloc] init];
    third.my_title = self.user_title.text;
    [self.navigationController pushViewController:third animated:YES];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
