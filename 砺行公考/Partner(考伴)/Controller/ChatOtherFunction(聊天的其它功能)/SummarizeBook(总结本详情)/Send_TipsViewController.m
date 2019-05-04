//
//  Send_TipsViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/2/28.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "Send_TipsViewController.h"
#import "ChatViewController.h"

@interface Send_TipsViewController ()

@property (nonatomic, strong) ChatViewController *chatVC;

@end

@implementation Send_TipsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = nil;
    
    if (self.isShowSendItem) {
        [self setleftOrRight:@"right" BarButtonItemWithTitle:@"发送" target:self action:@selector(sendTipsDetails)];
    }
    
    [self.imageArray removeObjectAtIndex:0];
    [self.collectionview reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (void)sendTipsDetails {
    NSDictionary *dic = @{@"type":@"tips",
                          @"id":self.tips_id,
                          @"message":self.textview.text,
                          @"id__":self.tips_id,
                          @"type_":@"1",
                          @"message_attr_is_summery_content":self.textview.text,
                          @"message_attr_is_summary":@(1)
                          };
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[ChatViewController class]]) {
            self.chatVC =(ChatViewController *)controller;
            
            [self.chatVC sendRecommendFriend:dic];
            
            [self.navigationController popToViewController:self.chatVC animated:YES];
        }
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
