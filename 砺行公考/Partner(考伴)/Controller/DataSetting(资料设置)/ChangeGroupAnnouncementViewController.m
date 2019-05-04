//
//  ChangeGroupAnnouncementViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/20.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "ChangeGroupAnnouncementViewController.h"

@interface ChangeGroupAnnouncementViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *textview;

@end

@implementation ChangeGroupAnnouncementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    self.title = @"修改群公告";
    
    [self setleftOrRight:@"right" BarButtonItemWithTitle:@"保存" target:self action:@selector(saveAnnouncementAction)];
    
    self.textview = [[UITextView alloc] init];
    self.textview.delegate = self;
    self.textview.font = SetFont(14);
    self.textview.textColor = DetailTextColor;
    self.textview.text = @"设置群公告";
    [self.view addSubview:self.textview];
    __weak typeof(self) weakSelf = self;
    [self.textview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(10);
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.height.mas_equalTo(300);
    }];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"设置群公告"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length < 1) {
        textView.text = @"设置群公告";
        textView.textColor = DetailTextColor;
    }
}

- (void)saveAnnouncementAction {
    if ([self.textview.text isEqualToString:@"设置群公告"]) {
        [self showHUDWithTitle:@"请设置群公告"];
        return;
    }
    self.returnAnnouncementContent(self.textview.text);
    [self.navigationController popViewControllerAnimated:YES];
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
