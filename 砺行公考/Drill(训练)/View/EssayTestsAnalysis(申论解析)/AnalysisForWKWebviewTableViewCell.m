//
//  AnalysisForWKWebviewTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/11.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "AnalysisForWKWebviewTableViewCell.h"
#import <WebKit/WebKit.h>
#import "GlobarFile.h"

@interface AnalysisForWKWebviewTableViewCell ()<WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webview;

@end

@implementation AnalysisForWKWebviewTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initCellUI];
    }
    return self;
}

- (void)setHtml_string:(NSString *)html_string {
    _html_string = html_string;
    [self.webview loadHTMLString:_html_string baseURL:nil];
}

- (void)initCellUI {
    WKPreferences *preference = [[WKPreferences alloc] init];
    preference.minimumFontSize = 0.0;
    
    WKWebViewConfiguration *confige = [[WKWebViewConfiguration alloc] init];
    confige.preferences = preference;
    
    self.webview = [[WKWebView alloc] initWithFrame:FRAME(20, 0, SCREENBOUNDS.width - 40, 300) configuration:confige];
    self.webview.navigationDelegate = self;
    self.webview.scrollView.showsHorizontalScrollIndicator = NO;
    self.webview.scrollView.showsVerticalScrollIndicator = NO;
    [self.contentView addSubview:self.webview];
}

////加载完毕  禁用捏合手势
//- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
//    NSString *injectionJSString = @"var script = document.createElement('meta');"
//    "script.name = 'viewport';"
//    "script.content=\"width=device-width, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, user-scalable=no\";"
//    "document.getElementsByTagName('head')[0].appendChild(script);";
//    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
//}
//
//
//- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
//
//    return nil;
//
//}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
