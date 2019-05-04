//
//  DealViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/1.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "DealViewController.h"
#import <WebKit/WebKit.h>

@interface DealViewController ()

@end

@implementation DealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"用户注册协议";
    
    [self setBack];

    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKWebView *webview = [[WKWebView alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, SCREENBOUNDS.height - 64) configuration:configuration];
    [webview loadRequest:[NSURLRequest requestWithURL:[[NSBundle mainBundle] URLForResource:@"useragreement.html" withExtension:nil]]];
    [self.view addSubview:webview];
    
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
