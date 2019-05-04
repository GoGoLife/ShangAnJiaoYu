//
//  Send_StudyViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/2/28.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "Send_StudyViewController.h"
#import "ChatViewController.h"

@interface Send_StudyViewController ()

@property (nonatomic, strong) ChatViewController *chatVC;

@end

@implementation Send_StudyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = nil;
    if (self.isShowSendItem) {
        [self setleftOrRight:@"right" BarButtonItemWithTitle:@"发送" target:self action:@selector(sendStudyDetails)];
    }
    
//    [self.imageArray removeObjectAtIndex:0];
//    [self.collectionview reloadData];
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

- (void)sendStudyDetails {
    NSDictionary *dic = @{@"type":@"study",
                          @"id":self.study_id,
                          @"message":self.title_textfield.text,
                          @"id__":self.study_id,
                          @"type_":@"3",
                          @"message_attr_is_summery_content":self.title_textfield.text,
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
