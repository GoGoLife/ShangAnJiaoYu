//
//  Send_DigestViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/3/4.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "Send_DigestViewController.h"

@interface Send_DigestViewController ()

@end

@implementation Send_DigestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BookModel *model = self.dataArray[indexPath.row];
//    if (indexPath.row == 0) {
//        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"oneCell" forIndexPath:indexPath];
//        cell.contentView.layer.contents = (id)[UIImage imageNamed:@"add_image_cell"].CGImage;
//        return cell;
//    }else {
        BookCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//        cell.delegate = self;
        [cell.imageview sd_setImageWithURL:[NSURL URLWithString:model.image_url] placeholderImage:[UIImage imageNamed:@"no_image"]];
        cell.indexPath = indexPath;
        cell.name_label.text = model.name_string;
        cell.numbers_label.text = model.numbers_string;
        return cell;
//    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == 0) {
//        ChangeOrCreatBookViewController *bookVC = [[ChangeOrCreatBookViewController alloc] init];
//        bookVC.type = BOOK_TYPE_CREATE;
//        bookVC.book_type = @"1";
//        [self.navigationController pushViewController:bookVC animated:YES];
//        return;
//    }
    BookModel *model = self.dataArray[indexPath.row];
    DigestContentViewController *content = [[DigestContentViewController alloc] init];
    content.isSend = YES;
    content.book_id = model.book_id;
    content.book_name = model.name_string;
    content.book_numbers = model.numbers_string;
    content.book_details = model.details_string;
    content.book_image_url = model.image_url;
    [self.navigationController pushViewController:content animated:YES];
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
