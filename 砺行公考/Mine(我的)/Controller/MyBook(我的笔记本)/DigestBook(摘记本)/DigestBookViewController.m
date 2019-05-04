//
//  DigestBookViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/5.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "DigestBookViewController.h"
//新建/修改笔记本信息
#import "ChangeOrCreatBookViewController.h"

@interface DigestBookViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, BookCollectionViewCellDelegate>

@end

@implementation DigestBookViewController

//获取摘记本数据
- (void)getHttpData {
    [self showHUD];
    NSDictionary *parma = @{@"type_":@"1"};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_note" Dic:parma SuccessBlock:^(id responseObject) {
//        NSLog(@"digest data == %ld", [responseObject[@"data"][@"note_result_"] count]);
        NSLog(@"digest data === %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            if (self.isShowAddOrChangeCell) {
                //新建摘记本模拟数据
                BookModel *book_model = [[BookModel alloc] init];
                book_model.book_id = @"";
                book_model.image_url = @"";
                book_model.name_string = @"";
                book_model.numbers_string = @"";
                book_model.details_string = @"";
                [weakSelf.dataArray addObject:book_model];
            }
            
            for (NSDictionary *dic in responseObject[@"data"][@"note_result_"]) {
                BookModel *for_book_model = [[BookModel alloc] init];
                for_book_model.book_id = dic[@"id_"];
                for_book_model.image_url = dic[@"note_picture_url_"];
                for_book_model.name_string = dic[@"name_"];
                for_book_model.numbers_string = [NSString stringWithFormat:@"已收录%ld条", [dic[@"note_total_"] integerValue]];
                for_book_model.details_string = dic[@"desc_"];
                [weakSelf.dataArray addObject:for_book_model];
            }
            [weakSelf.collectionview reloadData];
            [weakSelf hidden];
        }else {
            [self showHUDWithTitle:@"接口请求未成功，不是未知错误"];
        }
    } FailureBlock:^(id error) {
        NSLog(@"error  ===== %@", error);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.dataArray = [NSMutableArray arrayWithCapacity:1];
    
    //获取数据
    [self getHttpData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    
    self.title = @"摘记本";
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
    layout.minimumLineSpacing = 10.0;
    layout.minimumInteritemSpacing = 20.0;
    CGFloat item_width = (SCREENBOUNDS.width - 80) / 3;
    layout.itemSize = CGSizeMake(item_width, item_width + 60);
    
    
    self.collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionview.backgroundColor = WhiteColor;
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"oneCell"];
    [self.collectionview registerClass:[BookCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionview];
    __weak typeof(self) weakSelf = self;
    [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BookModel *model = self.dataArray[indexPath.row];
    if (indexPath.row == 0) {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"oneCell" forIndexPath:indexPath];
        cell.contentView.layer.contents = (id)[UIImage imageNamed:@"add_image_cell"].CGImage;
        return cell;
    }else {
        BookCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        cell.isShowEditButton = YES;
        cell.delegate = self;
        [cell.imageview sd_setImageWithURL:[NSURL URLWithString:model.image_url] placeholderImage:[UIImage imageNamed:@"no_image"]];
        cell.indexPath = indexPath;
        cell.name_label.text = model.name_string;
        cell.numbers_label.text = model.numbers_string;
        return cell;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        ChangeOrCreatBookViewController *bookVC = [[ChangeOrCreatBookViewController alloc] init];
        bookVC.type = BOOK_TYPE_CREATE;
        bookVC.book_type = @"1";
        [self.navigationController pushViewController:bookVC animated:YES];
        return;
    }
    BookModel *model = self.dataArray[indexPath.row];
    DigestContentViewController *content = [[DigestContentViewController alloc] init];
    content.book_id = model.book_id;
    content.book_name = model.name_string;
    content.book_numbers = model.numbers_string;
    content.book_details = model.details_string;
    content.book_image_url = model.image_url;
    [self.navigationController pushViewController:content animated:YES];
}

#pragma mark ----BookCollectionViewCell delegate
//修改笔记本信息
- (void)touchEditButtonActionWithIndexPath:(NSIndexPath *)indexPath {
    BookModel *model = self.dataArray[indexPath.row];
    ChangeOrCreatBookViewController *bookVC = [[ChangeOrCreatBookViewController alloc] init];
    bookVC.type = BOOK_TYPE_CHANGE;
    bookVC.book_id = indexPath.row == 0 ? @"" : model.book_id;
    bookVC.book_name = model.name_string;
    bookVC.book_details = model.details_string;
    bookVC.book_image_url = model.image_url;
    bookVC.book_type = @"1";
    [self.navigationController pushViewController:bookVC animated:YES];
}
@end
