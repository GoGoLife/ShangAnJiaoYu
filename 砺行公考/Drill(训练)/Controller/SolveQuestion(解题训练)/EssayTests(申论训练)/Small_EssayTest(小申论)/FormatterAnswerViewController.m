//
//  FormatterAnswerViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/3/24.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "FormatterAnswerViewController.h"
#import <AipOcrSdk/AipOcrSdk.h>
#import "SogouSemantic.h"
#import <AVFoundation/AVFoundation.h>
#import "CompareStudyViewController.h"
#import <IQKeyboardManager.h>

@interface FormatterAnswerViewController ()<SogouSemanticDelegate>

@property (nonatomic, strong) UITextView *textview;

@property (nonatomic, strong) UIView *endSpeakView;

@property (nonatomic, strong) NSString *formatter_speak_string;

@end

@implementation FormatterAnswerViewController{
    // 默认的识别成功的回调
    void (^_successHandler)(id);
    // 默认的识别失败的回调
    void (^_failHandler)(NSError *);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"整理答案";
    [self setBack];
    self.formatter_speak_string = @"";
    
    [self setleftOrRight:@"right" BarButtonItemWithTitle:@"完成" target:self action:@selector(rightBarItemAction)];
    
    [[AipOcrService shardService] authWithAK:@"hE0URYTQodDaRkayKuaGYfB3" andSK:@"t01n3e79j83ted0FBFzl1MFW9gPrgfcG"];
    
    [SogouSemanticSetting setUserID:@"HMOX0181" andKey:@"jg1YoCKA"];
    [SogouSemanticSetting setNeedSemanticsRes:YES];
    
    [self configCallback];
    
    UIButton *paizhao = [UIButton buttonWithType:UIButtonTypeCustom];
    [paizhao setImage:[UIImage imageNamed:@"paizhao"] forState:UIControlStateNormal];
    [self.view addSubview:paizhao];
    __weak typeof(self) weakSelf = self;
    [paizhao mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [paizhao addTarget:self action:@selector(identify_paizhao_action) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *yuyin = [UIButton buttonWithType:UIButtonTypeCustom];
    [yuyin setImage:[UIImage imageNamed:@"yuyin"] forState:UIControlStateNormal];
    [self.view addSubview:yuyin];
    [yuyin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(20);
        make.right.equalTo(paizhao.mas_left).offset(-20);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [yuyin addTarget:self action:@selector(identify_yuyin_action) forControlEvents:UIControlEventTouchUpInside];
    
    self.textview = [[UITextView alloc] init];
    self.textview.backgroundColor = SetColor(246, 246, 246, 1);
    self.textview.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5);
    self.textview.text = self.my_answer_string;
    [self.view addSubview:self.textview];
    [self.textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(70, 20, 20, 20));
    }];
}

/** 完成跳转 */
- (void)rightBarItemAction {
    CompareStudyViewController *compare = [[CompareStudyViewController alloc] init];
    compare.my_answer_string = self.textview.text;
    [self.navigationController pushViewController:compare animated:YES];
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
                weakSelf.textview.text = [message copy];
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
    self.formatter_speak_string = @"";
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
            self.formatter_speak_string = [self.formatter_speak_string stringByAppendingString:[NSString stringWithFormat:@"%@\n\n", requestStr]];
            self.textview.text = self.formatter_speak_string;
        }
    }
    //    [self.resultTextView setText:jsonStr];
}
//返回错误时回调
- (void)onError:(NSError*)error{
    NSString* st = [NSString stringWithFormat:@"%@-code:%d-%@",error.domain,error.code,[error.userInfo objectForKey:@"reason"]];
    NSLog(@"error text == %@", st);
    [self.endSpeakView removeFromSuperview];
    self.textview.text = @"识别失败";
}

// 录音结束后回调
- (void)onRecordStop{
    //    recordEnd = [[NSDate date]timeIntervalSince1970];
    //    self.volumeLabel.text  = @"0";
    NSLog(@"录音结束");
    [self.endSpeakView removeFromSuperview];
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
