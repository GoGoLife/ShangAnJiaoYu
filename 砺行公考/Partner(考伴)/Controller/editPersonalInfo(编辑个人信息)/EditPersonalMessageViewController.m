//
//  EditPersonalMessageViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/14.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "EditPersonalMessageViewController.h"

@interface EditPersonalMessageViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textview;

@property (nonatomic, strong) NSString *messageString;

@end

@implementation EditPersonalMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"编辑个人签名";
    [self setBack];
    
    [self setleftOrRight:@"right" BarButtonItemWithTitle:@"完成" target:self action:@selector(finishAction)];
    
    self.textview = [[UITextView alloc] init];
    self.textview.delegate = self;
    self.textview.font = SetFont(14);
    self.textview.textColor = DetailTextColor;
    self.textview.text = @"编辑个人签名";
    [self.view addSubview:self.textview];
    __weak typeof(self) weakSelf = self;
    [self.textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(5);
        make.left.equalTo(weakSelf.view.mas_left).offset(10);
        make.right.equalTo(weakSelf.view.mas_right).offset(-10);
        make.height.mas_equalTo(200);
    }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    textView.textColor = [UIColor blackColor];
    textView.text = @"";
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    self.messageString = textView.text;
}

- (void)finishAction {
    [self.textview resignFirstResponder];
    if (self.messageString) {
        self.returnMessageString(self.messageString);
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [self showHUDWithTitle:@"请输入个性签名"];
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
