//
//  Send_DrillViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/2/28.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "Send_DrillViewController.h"
#import "ChatViewController.h"

@interface Send_DrillViewController ()

@property (nonatomic, strong) ChatViewController *chatVC;

@end

@implementation Send_DrillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = nil;
    if (self.isShowSendItem) {
        [self setleftOrRight:@"right" BarButtonItemWithTitle:@"发送" target:self action:@selector(sendDrillDetails)];
    }
    
    if (self.imageArray.count > 0) {
        [self.imageArray removeObjectAtIndex:0];
    }
    [self.collectionview reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.imageArray.count - 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.imageArray removeObjectAtIndex:0];
    TipsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.imageview.image = self.imageArray[indexPath.row];
    return cell;
}

- (void)sendDrillDetails {
    NSDictionary *dic = @{@"type":@"drill",
                          @"id":self.Drill_details_id,
                          @"question_id":self.Drill_question_id,
                          @"message":self.textview.text,
                          @"message_attr_is_summary":@(1),
                          @"id__":self.Drill_details_id,
                          @"type_":@"4",
                          @"message_attr_is_summery_content":self.textview.text
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
