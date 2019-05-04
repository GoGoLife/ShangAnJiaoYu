//
//  Big_ThreeViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/19.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "Big_ThreeViewController.h"
#import "Big_ChooseMaterialsViewController.h"

@interface Big_ThreeViewController ()

//是不是推荐方式   推荐方式是类型一   不推荐是类型二
@property (nonatomic, assign) BOOL isDefaultType;

@end

@implementation Big_ThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextAction)];
    self.navigationItem.rightBarButtonItem = right;
    
    self.isDefaultType = YES;
    
    [self creatViewUI];
}

- (void)creatViewUI {
    __weak typeof(self) weakSelf = self;
    UILabel *title_label = [[UILabel alloc] init];
    title_label.font = SetFont(18);
    title_label.text = @"第三步：整理分类";
    [self.view addSubview:title_label];
    [title_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(10);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = SetColor(248, 248, 248, 1);
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(title_label.mas_bottom).offset(10);
        make.leading.trailing.equalTo(weakSelf.view).offset(20);
        make.height.mas_equalTo(2);
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(16);
    label.textColor = DetailTextColor;
    label.text = @"布局类型选择";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(10);
        make.left.equalTo(line.mas_left);
    }];
    
    UIImageView *imagev = [[UIImageView alloc] init];
    imagev.backgroundColor = RandomColor;
    [self.view addSubview:imagev];
    [imagev mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.mas_equalTo(200);
    }];
    
    for (NSInteger index = 0; index < 2; index++) {
        UIView *choose_view = [[UIView alloc] init];
        choose_view.backgroundColor = SetColor(246, 246, 246, 1);
        ViewRadius(choose_view, 8.0);
        choose_view.tag = index + 100;
        choose_view.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchViewAction:)];
        [choose_view addGestureRecognizer:tap];
        [self.view addSubview:choose_view];
        [choose_view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imagev.mas_bottom).offset(20 + (100 + 20) * index);
            make.left.equalTo(weakSelf.view.mas_left).offset(20);
            make.right.equalTo(weakSelf.view.mas_right).offset(-20);
            make.height.mas_equalTo(100);
        }];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = SetFont(14);
        label.textColor = [UIColor grayColor];
        label.text = [NSString stringWithFormat:@"类型%@", index == 0 ? @"一" : @"二"];
        [choose_view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(choose_view.mas_top).offset(20);
            make.left.equalTo(choose_view.mas_left).offset(20);
        }];
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.font = SetFont(18);
        label1.textColor = [UIColor grayColor];;
        label1.text = @[@"砺行标准\"引析承策结\"布局法", @"引+析（3）+结尾（不鼓励采取）"][index];
        [choose_view addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).offset(20);
            make.left.equalTo(label.mas_left);
        }];
    }
}

- (void)touchViewAction:(UITapGestureRecognizer *)ges {
    UIView *touch_view = ges.view;
    NSInteger tag = touch_view.tag;
    UIView *view1 = [self.view viewWithTag:100];
    UIView *view2 = [self.view viewWithTag:101];
    if (tag == 100) {
        self.isDefaultType = YES;
        view1.backgroundColor = ButtonColor;
        view2.backgroundColor = SetColor(246, 246, 246, 1);
    }else {
        self.isDefaultType = NO;
        view2.backgroundColor = ButtonColor;
        view1.backgroundColor = SetColor(246, 246, 246, 1);
    }
}

//下一步
- (void)nextAction {
    //保存做题的方法类型
    [[NSUserDefaults standardUserDefaults] setObject:@(self.isDefaultType) forKey:Big_EssayTests_Do_type];
    Big_ChooseMaterialsViewController *choose = [[Big_ChooseMaterialsViewController alloc] init];
    choose.isType = self.isDefaultType;
    [self.navigationController pushViewController:choose animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
