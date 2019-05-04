//
//  ChooseDoTypeViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/3/15.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "ChooseDoTypeViewController.h"
#import "First_AnalyzeQuestionViewController.h"
#import "Big_FirstViewController.h"
#import "BigEssayFirstViewController.h"
#import "SmallTrainingFirstViewController.h"
#import "IntroduceViewController.h"
#import "TextViewMenu.h"

@interface ChooseDoTypeViewController ()<TextViewMenuDelegate>

@property (nonatomic, strong) UIView *back_view;

@end

@implementation ChooseDoTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"做题方式";
    [self setBack];
    __weak typeof(self) weakSelf = self;
    NSArray *title_array = @[@"APP内完成写作", @"纸质版完成写作", @"电脑端完成写作"];
    CGFloat height = (SCREENBOUNDS.height - 64 - 80) / 3;
    for (NSInteger index = 0; index < title_array.count; index++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = SetFont(20);
        button.backgroundColor = SetColor(246, 246, 246, 1);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:title_array[index] forState:UIControlStateNormal];
        button.tag = index;
        ViewRadius(button, 5.0);
        [self.view addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.view.mas_top).offset(20 + (height + 20) * index);
            make.left.equalTo(weakSelf.view.mas_left).offset(20);
            make.right.equalTo(weakSelf.view.mas_right).offset(-20);
            make.height.mas_equalTo(height);
        }];
        [button addTarget:self action:@selector(touchChooseDotype:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)touchChooseDotype:(UIButton *)sender {
    for (UIButton *button in self.view.subviews) {
        if (![button isKindOfClass:[UIButton class]]) {
            continue;
        }
        
        if (button.tag == sender.tag) {
            button.backgroundColor = SetColor(67, 154, 247, 1);
            [button setTitleColor:WhiteColor forState:UIControlStateNormal];
            if (sender.tag == 0) {
                //APP
                [self pushVCInAPP:self.doType];
            }else if (sender.tag == 1) {
                //纸质版
                [self showURLWithShowTitle:@"下载试卷到百度网盘" urlString:@"http://pan.baidu.com/disk/home?jsdncmnz,nxmcn,na,mcnm,znjvjnzxnmvnmn,xcmn,zn,mnm"];
            }else if (sender.tag == 2) {
                //电脑端
                NSString *url_ids_string = [self.essay_id_array componentsJoinedByString:@","];
                NSLog(@"url ids string == %@", url_ids_string);
                NSString *type = @"";
                if (self.doType == DoType_Small_Tests) {
                    type = @"1";
                }else {
                    type = @"2";
                }
                
                [self showURLWithShowTitle:@"在电脑端输入以下网址" urlString:[NSString stringWithFormat:@"http://47.97.204.83/student/login?id=%@&type=%@", url_ids_string, type]];
            }
        }else {
            button.backgroundColor = SetColor(246, 246, 246, 1);
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
    }
}

//APP内跳转规则
- (void)pushVCInAPP:(DoType)type {
    if (type == DoType_Small_Tests) {
        //旧的小申论解题训练
//        First_AnalyzeQuestionViewController *first = [[First_AnalyzeQuestionViewController alloc] init];
//        first.question_index = 0;
//        first.isShowAnalysis = NO;
//        first.small_tests_id_array = self.essay_id_array;//self.dataArray[indexPath.row][@"essay_id_"];
//        [self.navigationController pushViewController:first animated:YES];
        
//        SmallTrainingFirstViewController *smallFrist = [[SmallTrainingFirstViewController alloc] init];
//        smallFrist.exam_id = self.training_id;
//        smallFrist.topic_count = self.essay_id_array.count;
//        [self.navigationController pushViewController:smallFrist animated:YES];
        
        IntroduceViewController *introduce = [[IntroduceViewController alloc] init];
        introduce.introduceType = IntroduceType_SmallEssayTests;
        introduce.training_id = self.training_id;
        introduce.smallEssay_topic_count = self.essay_id_array.count;
        [self.navigationController pushViewController:introduce animated:YES];
        
    }else {
        //旧的大申论解题训练
//        Big_FirstViewController *big_first = [[Big_FirstViewController alloc] init];
//        big_first.big_essayTest_id = self.essay_id_array[0];//self.dataArray[indexPath.row][@"essay_id_"][0];
//        [self.navigationController pushViewController:big_first animated:YES];
        
        //保存essay_id  用于获取大申论推荐的标题
        [[NSUserDefaults standardUserDefaults] setObject:self.essay_id_array[0] forKey:@"bigEssayTest_essay_id"];
        
//        BigEssayFirstViewController *first = [[BigEssayFirstViewController alloc] init];
//        first.bigEssay_id = self.training_id;
//        [self.navigationController pushViewController:first animated:YES];
        
        IntroduceViewController *introduce = [[IntroduceViewController alloc] init];
        introduce.introduceType = IntroduceType_BigEssayTests;
        introduce.training_id = self.training_id;
        [self.navigationController pushViewController:introduce animated:YES];
    }
}

- (void)showURLWithShowTitle:(NSString *)title urlString:(NSString *)urlString {
    AppDelegate *app_delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.back_view = [[UIView alloc] initWithFrame:app_delegate.window.bounds];
    self.back_view.backgroundColor = SetColor(155, 155, 155, 0.8);
    [app_delegate.window addSubview:self.back_view];
    __weak typeof(self) weakSelf = self;
    UIView *content_view = [[UIView alloc] init];
    content_view.backgroundColor = WhiteColor;
    [self.back_view addSubview:content_view];
    [content_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.back_view).insets(UIEdgeInsetsMake(SCREENBOUNDS.height - 300, 0, 0, 0));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(18);
    label.text = title;
    [content_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(content_view.mas_top).offset(20);
        make.left.equalTo(content_view.mas_left).offset(20);
    }];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [content_view addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(content_view.mas_right).offset(-20);
        make.centerY.equalTo(label.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    //添加绑定事件
    [cancel addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    
//    UILabel *url_label = [[UILabel alloc] init];
//    url_label.font = SetFont(16);
//    url_label.textColor = SetColor(48, 132, 252, 1);
//    url_label.numberOfLines = 0;
//    url_label.text = urlString;
//    [content_view addSubview:url_label];
//    [url_label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(label.mas_bottom).offset(40);
//        make.left.equalTo(content_view.mas_left).offset(20);
//        make.right.equalTo(content_view.mas_right).offset(-20);
//    }];
    TextViewMenu *textview = [[TextViewMenu alloc] initWithType:actionType_CollectPoints];
    textview.CustomDelegate = self;
    textview.editable = NO;
    textview.font = SetFont(16);
    textview.text = urlString;
    [content_view addSubview:textview];
    [textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(40);
        make.left.equalTo(content_view.mas_left).offset(20);
        make.right.equalTo(content_view.mas_right).offset(-20);
        make.bottom.equalTo(content_view.mas_bottom).offset(-10);
    }];
//    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//    pasteboard.string = urlString;
    
}

- (void)cancelAction {
    [self.back_view removeFromSuperview];
}

- (void)touchCollectionPoints {
    [self.back_view removeFromSuperview];
    [self showHUDWithTitle:@"已复制"];
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
