//
//  EssayTests_HomeViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/14.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "EssayTests_HomeViewController.h"
#import "EssayTests_HomeTableViewCell.h"
#import "First_AnalyzeQuestionViewController.h"
#import "Big_FirstViewController.h"
//临时入口
#import "PlayerViewController.h"
#import "ChooseDoTypeViewController.h"
//大申论通关训练
#import "BigTrainingFirstViewController.h"
//小申论通关训练
#import "SmallTrainingFirstViewController.h"
#import "IntroduceViewController.h"
//大申论 -- 新
#import "BigEssayFirstViewController.h"

@interface EssayTests_HomeViewController ()<UITableViewDelegate, UITableViewDataSource, EssayTests_HomeTableViewCellDelegate>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *dataArray;

/** 当前是否购买 */
@property (nonatomic, assign) NSInteger current_is_purchase;

@end

@implementation EssayTests_HomeViewController

- (void)getHttpData {
    NSString *essay_type_ = @"";
    if (self.type == SMALL_ESSAY_TESTS_TYPE) {
        essay_type_ = @"00000000000000000001001700070000";
    }else if (self.type == BIG_ESSAY_TESTS_TYPE) {
        essay_type_ = @"00000000000000000001001700080000";
    }else if (self.type == ESSAY_TESTS_TYPE_BigTestTraining){
        [self getDataWithTraining];
        [self.tableview reloadData];
        return;
    }else {
        [self getDataWithTraining];
        [self.tableview reloadData];
        return;
    }
    
    NSDictionary *parma = @{
                            @"exam_two_type_":essay_type_,
                            @"exam_one_type_":@"00000000000000000001001600060000",
                            @"page_number":@"1",
                            @"page_size":@"50"
                            };
    NSLog(@"parma === %@", parma);
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_essay_solve" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"申论试卷 === %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            weakSelf.dataArray = responseObject[@"data"];
            [weakSelf.tableview reloadData];
        }
    } FailureBlock:^(id error) {
        
    }];
}

/**
 获取大小申论通关训练数据
 */
- (void)getDataWithTraining {
    NSString *two_type = @"";
    if (self.type == ESSAY_TESTS_TYPE_BigTestTraining) {
        two_type = @"2";
    }else if (self.type == ESSAY_TESTS_TYPE_SmallTestTraining) {
        two_type = @"3";
    }
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"fiveTrainingId":self.TestTraining_id,@"two_type_":two_type};
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/course/find_five_training_essay" Dic:param SuccessBlock:^(id responseObject) {
        NSLog(@"test  training data == %@", responseObject);
        weakSelf.dataArray = responseObject[@"data"][@"five_train_node_list"][@"rows"];
        weakSelf.current_is_purchase = [responseObject[@"data"][@"is_purchase"] integerValue];
        [weakSelf.tableview reloadData];
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setBack];
    
    self.current_is_purchase = 0;
    
    //微吼临时入口
//    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"微吼" style:UIBarButtonItemStylePlain target:self action:@selector(nextAction)];
//    self.navigationItem.rightBarButtonItem = right;
    
    __weak typeof(self) weakSelf = self;
    UISearchBar *search = [[UISearchBar alloc] init];
    search.tintColor = [UIColor whiteColor];
    search.barTintColor = [UIColor whiteColor];
    UIImage *backImage = [self GetImageWithColor:[UIColor whiteColor] andHeight:32.0];
    search.backgroundImage = backImage;
    UIView *searchTextField = nil;
    // 经测试, 需要设置barTintColor后, 才能拿到UISearchBarTextField对象
    searchTextField = [[[search.subviews firstObject] subviews] lastObject];
    searchTextField.backgroundColor = SetColor(246, 246, 246, 1);
    search.placeholder = @"输入关键词...";
    [self.view addSubview:search];
    [search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(0);
        make.left.equalTo(weakSelf.view.mas_left).offset(0);
        make.right.equalTo(weakSelf.view.mas_right).offset(0);
        make.height.mas_equalTo(52);
    }];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.rowHeight = ESSAYTEST_CELL_HEIGHT;
    [self.tableview registerClass:[EssayTests_HomeTableViewCell class] forCellReuseIdentifier:@"essaytestCell"];
    [self.view addSubview:self.tableview];
    
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(search.mas_bottom);
        make.leading.trailing.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
    }];
    
    //获取数据
    [self getHttpData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArray[indexPath.row];
    EssayTests_HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"essaytestCell"];
    cell.indexPath = indexPath;
    cell.delegate = self;
    if (self.type == ESSAY_TESTS_TYPE_BigTestTraining || self.type == ESSAY_TESTS_TYPE_SmallTestTraining) {
        //大申论  小申论  通关训练
        cell.pay_button.hidden = YES;
        cell.video_back_image.image = [self getVideoPreViewImage:[NSURL URLWithString:dic[@"path_"]]];
        cell.title_label.text = dic[@"title_"];
        cell.detail_label.text = dic[@"describe_"];
        cell.test_number_label.text = [NSString stringWithFormat:@"题量%ld", [dic[@"topic_count_"] integerValue]];
    }else if(self.type == BIG_ESSAY_TESTS_TYPE) {
        //大申论解题训练
        cell.pay_button.hidden = YES;
        [cell.video_back_image sd_setImageWithURL:dic[@"file_url_"] placeholderImage:[UIImage imageNamed:@"no_image"]];
        cell.title_label.text = dic[@"title_"];
        cell.detail_label.text = dic[@"describe_"];
    }else {
        //小申论解题训练
        cell.pay_button.hidden = YES;
        [cell.video_back_image sd_setImageWithURL:dic[@"file_url_"] placeholderImage:[UIImage imageNamed:@"no_image"]];
        cell.title_label.text = dic[@"title_"];
        cell.detail_label.text = dic[@"describe_"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSDictionary *dic = self.dataArray[indexPath.row];
//    if (self.type == ESSAY_TESTS_TYPE_BigTestTraining || self.type == ESSAY_TESTS_TYPE_SmallTestTraining) {
//        //大申论通关训练
//        IntroduceViewController *introduce = [[IntroduceViewController alloc] init];
//        introduce.training_id = dic[@"exam_id_"];
//        introduce.introduceType = IntroduceType_BigEssayTraining;
//        [self.navigationController pushViewController:introduce animated:YES];
//    }else if (self.type == ESSAY_TESTS_TYPE_SmallTestTraining) {
//        //小申论通关训练
//        IntroduceViewController *introduce = [[IntroduceViewController alloc] init];
//        introduce.training_id = dic[@"exam_id_"];
//        introduce.smallEssay_topic_count = [dic[@"topic_count_"] integerValue];
//        introduce.introduceType = IntroduceType_SmallEssayTraining;
//        [self.navigationController pushViewController:introduce animated:YES];
//    }
    if (self.type == ESSAY_TESTS_TYPE_BigTestTraining || self.type == ESSAY_TESTS_TYPE_SmallTestTraining) {
        [self isPushDeQuestionViewWithIsPurchese:self.current_is_purchase IndexPath:indexPath];
        
    } else {
        //大申论解题训练
        ChooseDoTypeViewController *doType = [[ChooseDoTypeViewController alloc] init];
        doType.training_id = self.dataArray[indexPath.row][@"id_"];
        doType.essay_id_array = self.dataArray[indexPath.row][@"essay_id_"];
        if (self.type == SMALL_ESSAY_TESTS_TYPE) {
            doType.doType = DoType_Small_Tests;
        }else {
            doType.doType = DoType_Big_Tests;
        }
        [self.navigationController pushViewController:doType animated:YES];
//        BigEssayFirstViewController *bigFirst = [[BigEssayFirstViewController alloc] init];
//        bigFirst.bigEssay_id = self.dataArray[indexPath.row][@"id_"];
//        [self.navigationController pushViewController:bigFirst animated:YES];
    }
}

//微吼临时入口方法
- (void)nextAction {
    PlayerViewController *player = [[PlayerViewController alloc] init];
    [self.navigationController pushViewController:player animated:YES];
}

- (void)touchGoPlayPloblem:(NSIndexPath *)indexPath {
    if (self.type == ESSAY_TESTS_TYPE_BigTestTraining) {
        
        
    }else if (self.type == ESSAY_TESTS_TYPE_SmallTestTraining) {
        
        
    }else {
        ChooseDoTypeViewController *doType = [[ChooseDoTypeViewController alloc] init];
        doType.essay_id_array = self.dataArray[indexPath.row][@"essay_id_"];
        if (self.type == SMALL_ESSAY_TESTS_TYPE) {
            doType.doType = DoType_Small_Tests;
        }else {
            doType.doType = DoType_Big_Tests;
        }
        [self.navigationController pushViewController:doType animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 判断是否跳转
 
 @param is_purchase is_purchase
 @param indexPath indexPath
 */
- (void)isPushDeQuestionViewWithIsPurchese:(NSInteger)is_purchase IndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    NSInteger whetherFree = [dataDic[@"whether_free_"] integerValue];
    if (is_purchase == 1 || whetherFree == 0) {
        //已购买 或者 免费  直接跳转
//        [self pushVC:dataModel];
        [self pushVC:dataDic];
        
    }else {
        //未购买  并且  不免费  请求接口
        //请求是否是会员的接口
        __weak typeof(self) weakSelf = self;
        [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/user/is_user_group" Dic:@{} SuccessBlock:^(id responseObject) {
            if ([responseObject[@"state"] integerValue] == 1) {
                //是否是会员  0 == 不是  1 == 是
                NSInteger is_user_group = [responseObject[@"data"][@"is_user_group"] integerValue];
                //是否有效   针对用户按时间购买课程
                NSInteger is_period_validity = [responseObject[@"data"][@"is_period_validity"] integerValue];
                //剩余次数   针对用户按次数购买课程
                NSInteger remaining_number = [responseObject[@"data"][@"remaining_number"] integerValue];
                if (is_user_group == 1 || is_period_validity == 1 || remaining_number > 0) {
                    //是会员 或者 有效  或者  剩余次数大于0   则可以直接做题
                    if (remaining_number > 0) {
                        //请求接口  有效次数 - 1
                        [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/course/five_training/insert_user_mall_use_count" Dic:@{} SuccessBlock:^(id responseObject) {
                            if ([responseObject[@"state"] integerValue] == 1) {
                                //有效次数 - 1 成功
                                //直接跳转
//                                [weakSelf pushVC:dataModel];
                                [weakSelf pushVC:dataDic];
                            }
                        } FailureBlock:^(id error) {
                            
                        }];
                    }else {
                        //直接跳转
//                        [weakSelf pushVC:dataModel];
                        [weakSelf pushVC:dataDic];
                    }
                }else {
                    //提醒去购买
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"去商城购买" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
                    [weakSelf presentViewController:alert animated:YES completion:nil];
                }
            }
        } FailureBlock:^(id error) {
            
        }];
    }
}

- (void)pushVC:(NSDictionary *)dic {
    if (self.type == ESSAY_TESTS_TYPE_BigTestTraining) {
        //大申论通关训练
        IntroduceViewController *introduce = [[IntroduceViewController alloc] init];
        introduce.training_id = dic[@"exam_id_"];
        introduce.introduceType = IntroduceType_BigEssayTraining;
        [self.navigationController pushViewController:introduce animated:YES];
    }else if (self.type == ESSAY_TESTS_TYPE_SmallTestTraining) {
        //小申论通关训练
        IntroduceViewController *introduce = [[IntroduceViewController alloc] init];
        introduce.training_id = dic[@"exam_id_"];
        introduce.smallEssay_topic_count = [dic[@"topic_count_"] integerValue];
        introduce.introduceType = IntroduceType_SmallEssayTraining;
        [self.navigationController pushViewController:introduce animated:YES];
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
