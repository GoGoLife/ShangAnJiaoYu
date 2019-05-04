//
//  BigFive_FinishViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/20.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BigFive_FinishViewController.h"
#import "SaveMessageViewController.h"
#import "BigEssayTestAnalysisViewController.h"
#import <AipOcrSdk/AipOcrSdk.h>
#import "SogouSemantic.h"
#import <AVFoundation/AVFoundation.h>

@interface BigFive_FinishViewController ()<SogouSemanticDelegate>

@property (nonatomic, strong) UITextView *label3;

/** 表示是否正在录音 */
@property (nonatomic, assign) BOOL isRecording;

@property (nonatomic, strong) UIView *endSpeakView;

@end

@implementation BigFive_FinishViewController {
    // 默认的识别成功的回调
    void (^_successHandler)(id);
    // 默认的识别失败的回调
    void (^_failHandler)(NSError *);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    
    [[AipOcrService shardService] authWithAK:@"hE0URYTQodDaRkayKuaGYfB3" andSK:@"t01n3e79j83ted0FBFzl1MFW9gPrgfcG"];
    [SogouSemanticSetting setUserID:@"HMOX0181" andKey:@"jg1YoCKA"];
    [SogouSemanticSetting setNeedSemanticsRes:YES];
    
    [self configCallback];
    
    __weak typeof(self) weakSelf = self;
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(18);
    label.text = @"第五步：逻辑树图-完成稿写作";
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(10);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:FRAME(0, 40, SCREENBOUNDS.width, SCREENBOUNDS.height - 40 - 64)];
    [self.view addSubview:scroll];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:FRAME(20, 20, 100, 40)];
    label1.font = SetFont(14);
    label1.textColor = DetailTextColor;
    label1.text = @"完整稿";
    [scroll addSubview:label1];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:FRAME(CGRectGetMinX(label1.frame), CGRectGetMaxY(label1.frame), 100, 30)];
    titleLabel.font = SetFont(14);
    titleLabel.textColor = DetailTextColor;
    titleLabel.text = @"我的标题";
    [scroll addSubview:titleLabel];
    
    UILabel *title_content = [[UILabel alloc] initWithFrame:FRAME(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame), SCREENBOUNDS.width - 40, 50)];
    title_content.backgroundColor = SetColor(246, 246, 246, 1);
    title_content.text = [[NSUserDefaults standardUserDefaults] objectForKey:BigEssayTests_my_title];//@"  发零售价发神经佛加上了贷款";
    [scroll addSubview:title_content];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:FRAME(CGRectGetMinX(title_content.frame), CGRectGetMaxY(title_content.frame), 100, 40)];
    label2.font = SetFont(14);
    label2.textColor = DetailTextColor;
    label2.text = @"引析承策结";
    [scroll addSubview:label2];
    
    
    UIButton *identify_paizhao = [UIButton buttonWithType:UIButtonTypeCustom];
    [identify_paizhao setImage:[UIImage imageNamed:@"paizhao"] forState:UIControlStateNormal];
    [scroll addSubview:identify_paizhao];
    [identify_paizhao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label2.mas_centerY);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [identify_paizhao addTarget:self action:@selector(identify_paizhao_action) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *identify_yuyin = [UIButton buttonWithType:UIButtonTypeCustom];
    [identify_yuyin setImage:[UIImage imageNamed:@"yuyin"] forState:UIControlStateNormal];
    [scroll addSubview:identify_yuyin];
    [identify_yuyin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(label2.mas_centerY);
        make.right.equalTo(weakSelf.view.mas_right).offset(-70);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [identify_yuyin addTarget:self action:@selector(identify_yuyin_action) forControlEvents:UIControlEventTouchUpInside];
    
    self.label3 = [[UITextView alloc] initWithFrame:FRAME(CGRectGetMinX(label2.frame), CGRectGetMaxY(label2.frame), SCREENBOUNDS.width - 40, 200.0)];
    self.label3.editable = NO;
    self.label3.font = SetFont(14);
    ViewRadius(self.label3, 8.0);
    self.label3.textColor = [UIColor blackColor];
    self.label3.backgroundColor = SetColor(246, 246, 246, 1);
    self.label3.text = self.result_string;
    [scroll addSubview:self.label3];
    
    CGFloat button_width = (SCREENBOUNDS.width - 40 - 10) / 3;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = FRAME(CGRectGetMinX(self.label3.frame), CGRectGetMaxY(self.label3.frame) + 20, button_width * 2, 50);
    [button setTitleColor:ButtonColor forState:UIControlStateNormal];
    [button setTitle:@"申请人工批改1000分" forState:UIControlStateNormal];
    ViewBorderRadius(button, 25.0, 1.0, ButtonColor);
    [scroll addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = FRAME(CGRectGetMaxX(button.frame) + 10, CGRectGetMinY(button.frame), button_width, 50);
    button1.backgroundColor = ButtonColor;
    [button1 setTitleColor:WhiteColor forState:UIControlStateNormal];
    [button1 setTitle:@"提交并保存" forState:UIControlStateNormal];
    ViewRadius(button1, 25.0);
    [button1 addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    [scroll addSubview:button1];
    
    
    [scroll setContentSize:CGSizeMake(SCREENBOUNDS.width, CGRectGetMaxY(button1.frame) + 20)];
}

//提交并保存
- (void)commitAction {
    NSString *big_essayTest_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"big_essayTest_require_id"];
    NSDictionary *parma = @{
                            @"id_":big_essayTest_id,
                            @"content_":self.result_string};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/small_essay_user_answer" Dic:parma SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            NSLog(@"大申论答案提交完成");
            //进行跳转
            BigEssayTestAnalysisViewController *analysis = [[BigEssayTestAnalysisViewController alloc] init];
            [weakSelf.navigationController pushViewController:analysis animated:YES];
        }else {
            [weakSelf showHUDWithTitle:@"提交失败！！"];
        }
    } FailureBlock:^(id error) {
        [weakSelf showHUDWithTitle:@"提交失败！！"];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configCallback {
    __weak typeof(self) weakSelf = self;
    
    // 这是默认的识别成功的回调
    _successHandler = ^(id result){
        NSLog(@"%@", result);
        NSString *title = @"识别结果";
        NSMutableString *message = [NSMutableString string];
        if(result[@"words_result"]){
            if([result[@"words_result"] isKindOfClass:[NSDictionary class]]){
                [result[@"words_result"] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@: %@\n", key, obj[@"words"]];
                    }else{
                        [message appendFormat:@"%@: %@\n", key, obj];
                    }
                    
                }];
            }else if([result[@"words_result"] isKindOfClass:[NSArray class]]){
                for(NSDictionary *obj in result[@"words_result"]){
                    if([obj isKindOfClass:[NSDictionary class]] && [obj objectForKey:@"words"]){
                        [message appendFormat:@"%@\n", obj[@"words"]];
                    }else{
                        [message appendFormat:@"%@\n", obj];
                    }
                    
                }
            }
            
        }else{
            [message appendFormat:@"%@", result];
        }
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            //更新答案
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                weakSelf.label3.text = [message copy];
            }];
        }];
    };
    
    _failHandler = ^(NSError *error){
        NSLog(@"识别失败 === %@", error);
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                [weakSelf showHUDWithTitle:@"识别失败"];
            }];
        }];
    };
}

//拍照获取答案
- (void)identify_paizhao_action {
    UIViewController * vc = [AipGeneralVC ViewControllerWithHandler:^(UIImage *image) {
        NSDictionary *options = @{@"language_type": @"CHN_ENG", @"detect_direction": @"true"};
        [[AipOcrService shardService] detectTextAccurateFromImage:image
                                                      withOptions:options
                                                   successHandler:self->_successHandler
                                                      failHandler:self->_failHandler];
        
    }];
    [self presentViewController:vc animated:YES completion:nil];
}

//语音获取答案
- (void)identify_yuyin_action {
        [[SogouSemantic sharedInstance] setDelegate:self];
        [SogouSemanticSetting setMaxRecordInterval:300];
        BOOL rst = [[SogouSemantic sharedInstance] startListening];
        //-----------------------------------------------------------------------------------
        NSLog(@"start : %d", rst);
        //展示结束按钮
        [self showEndSpeakView];
}

- (void)onJSONResutls:(NSString *)jsonStr
{
    NSString* requestStr = nil;
    NSString* responseStr = nil;
    
    NSData * newdata = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];      //theXML为nsstring
    NSDictionary* jsonDic = [NSJSONSerialization JSONObjectWithData:newdata options:0 error:nil];
    NSArray* requestStrArr = [jsonDic objectForKey:@"content"];
    if ([requestStrArr count]>0) {
        requestStr = [requestStrArr objectAtIndex:0];
    }
    int status = [[jsonDic objectForKey:@"status"]intValue];
    if (status == 2 || status == 8) {
        NSLog(@"请求结束");
        NSDictionary* semanticDic =  [jsonDic objectForKey:@"semantic_result"];
        NSArray* array = [semanticDic objectForKey:@"final_result"];
        if ([array count]>0) {
            NSDictionary * dic = [array objectAtIndex:0];
            responseStr = [dic objectForKey:@"answer"];
        }
    }
    if (requestStr) {
        if (responseStr) {
            NSLog(@"yiyun === %@", [NSString stringWithFormat:@"ask:%@\nanswer:%@",requestStr,responseStr]);
        } else{
            NSLog(@"yiyun === %@", [NSString stringWithFormat:@"ask:%@",requestStr]);
            self.label3.text = requestStr;
        }
    }
//    [self.resultTextView setText:jsonStr];
}
//返回错误时回调
- (void)onError:(NSError*)error{
    NSString* st = [NSString stringWithFormat:@"%@-code:%d-%@",error.domain,error.code,[error.userInfo objectForKey:@"reason"]];
    NSLog(@"error text == %@", st);
    [self touchEndSpeak];
}

// 录音结束后回调
- (void)onRecordStop{
//    recordEnd = [[NSDate date]timeIntervalSince1970];
//    self.volumeLabel.text  = @"0";
    NSLog(@"录音结束");
    [self touchEndSpeak];
}

///*
// 音量回调，取值[0,100]
// 默认以屏幕刷新率进行回调
// */
- (void)onUpdateVolume:(int)volume{
    NSLog(@"声音 === %@", [NSString stringWithFormat:@"%d",volume]);
    [self getCategory];
}

- (void)getCategory {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSLog(@"category : %@", session.category);
}


- (void)showEndSpeakView {
    AppDelegate *dele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.endSpeakView = [[UIView alloc] initWithFrame:dele.window.bounds];
    self.endSpeakView.backgroundColor = DetailTextColor;
    self.endSpeakView.alpha = 0.8;
    [dele.window addSubview:self.endSpeakView];
    
    UIButton *end_button = [UIButton buttonWithType:UIButtonTypeCustom];
    end_button.backgroundColor = WhiteColor;
    [end_button setTitleColor:ButtonColor forState:UIControlStateNormal];
    [end_button setTitle:@"结束" forState:UIControlStateNormal];
    ViewRadius(end_button, 40.0);
    [self.endSpeakView addSubview:end_button];
    __weak typeof(self) weakSelf = self;
    [end_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.endSpeakView.mas_bottom).offset(-20);
        make.centerX.equalTo(weakSelf.endSpeakView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
    [end_button addTarget:self action:@selector(touchEndSpeak) forControlEvents:UIControlEventTouchUpInside];
}

- (void)touchEndSpeak {
    [[SogouSemantic sharedInstance] cancel];
    [[SogouSemantic sharedInstance] destroy];
    [self.endSpeakView removeFromSuperview];
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
