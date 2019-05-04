//
//  ShowShoppingCategoryView.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/18.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "ShowShoppingCategoryView.h"
#import "GlobarFile.h"
#import "ErrorTagCollectionViewCell.h"
#import <Masonry.h>
#import "MOLoadHTTPManager.h"

@interface ShowShoppingCategoryView ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionview;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSDictionary *small_tag_dic;

@property (nonatomic, strong) NSMutableArray *select_array;

@end

@implementation ShowShoppingCategoryView

//根据商品ID   获取商品的小分类
- (void)getSmallCategory:(NSString *)shop_id {
    NSDictionary *parma = @{@"commodity_id" : self.shop_id};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/course/commodity_type_list" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"shop small category === %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            weakSelf.dataArray = responseObject[@"data"];
            weakSelf.small_tag_dic = responseObject[@"data"][0];
            [weakSelf.select_array addObject:[NSIndexPath indexPathForRow:0 inSection:0]];
            NSLog(@"22222222222222");
            [weakSelf.collectionview reloadData];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)setShop_id:(NSString *)shop_id {
    NSLog(@"1111111111111111");
    _shop_id = shop_id;
    [self getSmallCategory:_shop_id];
}

- (void)setNumbers_string:(NSString *)numbers_string {
    _numbers_string = numbers_string;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = WhiteColor;
        [self initViewUI];
        self.select_array = [NSMutableArray arrayWithCapacity:1];
    }
    return self;
}

- (void)initViewUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    self.collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionview.backgroundColor = WhiteColor;
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    [self.collectionview registerClass:[ErrorTagCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    [self addSubview:self.collectionview];
    __weak typeof(self) weakSelf = self;
    [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 0, 60, 0));
    }];
    
    self.confirm_button = [UIButton buttonWithType:UIButtonTypeCustom];
    self.confirm_button.titleLabel.font = SetFont(14);
    self.confirm_button.backgroundColor = ButtonColor;
    [self.confirm_button setTitleColor:WhiteColor forState:UIControlStateNormal];
    [self.confirm_button setTitle:@"确定" forState:UIControlStateNormal];
    ViewRadius(self.confirm_button, 20.0);
    [self.confirm_button addTarget:self action:@selector(touchConfirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.confirm_button];
    [self.confirm_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.collectionview.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.mas_left).offset(20);
        make.bottom.equalTo(weakSelf.mas_bottom).offset(-10);
        make.right.equalTo(weakSelf.mas_right).offset(-20);
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    ErrorTagCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.contentLable.text = dataDic[@"name"];
    if ([self.select_array containsObject:indexPath]) {
        cell.back_view.backgroundColor = ButtonColor;
        cell.contentLable.textColor = WhiteColor;
    }else {
        cell.back_view.backgroundColor = WhiteColor;
        cell.contentLable.textColor = ButtonColor;
    }
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(20, 20, 20, 20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0;
}

StringWidth()
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text_string = self.dataArray[indexPath.row][@"name"];
    CGFloat width = [self calculateRowWidth:text_string withFont:14];
    return CGSizeMake(width + 22, 30.0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREENBOUNDS.width, 200.0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(SCREENBOUNDS.width, 110.0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        for (UIView *vv in header.subviews) {
            [vv removeFromSuperview];
        }
        [self setHeaderView:header];
        return header;
    }
    
    UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
    for (UIView *vv in footer.subviews) {
        [vv removeFromSuperview];
    }
    [self setFooterView:footer];
    return footer;
}

- (void)setHeaderView:(UICollectionReusableView *)header_view {
    //数据index
    NSIndexPath *indexPath = [self.select_array firstObject];
    NSInteger index = indexPath.row;
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(removeSelfView) forControlEvents:UIControlEventTouchUpInside];
    [header_view addSubview:cancel];
    [cancel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header_view.mas_top).offset(20);
        make.right.equalTo(header_view.mas_right).offset(-20);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    __weak typeof(self) weakSelf = self;
    self.imageview = [[UIImageView alloc] init];
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:self.dataArray[index][@"path_"]] placeholderImage:[UIImage imageNamed:@"no_image"]];
    [header_view addSubview:self.imageview];
    [self.imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header_view.mas_top).offset(30);
        make.left.equalTo(header_view.mas_left).offset(20);
        make.size.mas_equalTo(CGSizeMake(110, 110));
    }];
    
    self.choose_category_label = [[UILabel alloc] init];
    self.choose_category_label.font = SetFont(14);
    self.choose_category_label.text = @"选择分类";
    [header_view addSubview:self.choose_category_label];
    [self.choose_category_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.imageview.mas_bottom).offset(-5);
        make.left.equalTo(weakSelf.imageview.mas_right).offset(10);
    }];
    
    self.inventory_label = [[UILabel alloc] init];
    self.inventory_label.font = SetFont(14);
    self.inventory_label.text = [NSString stringWithFormat:@"库存%ld件", [self.dataArray[index][@"inventory"] integerValue]];//@"库存47件";
    [header_view addSubview:self.inventory_label];
    [self.inventory_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.choose_category_label.mas_top).offset(-5);
        make.left.equalTo(weakSelf.choose_category_label.mas_left);
    }];
    
    self.price_label = [[UILabel alloc] init];
    self.price_label.font = SetFont(16);
    self.price_label.textColor = SetColor(242, 68, 89, 1);
    self.price_label.text = [NSString stringWithFormat:@"￥%.2f", [self.dataArray[index][@"price"] integerValue] / 100.0];//@"￥135";
    [header_view addSubview:self.price_label];
    [self.price_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakSelf.inventory_label.mas_top).offset(-5);
        make.left.equalTo(weakSelf.inventory_label.mas_left);
    }];
    
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = SetColor(246, 246, 246, 1);
    [header_view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.imageview.mas_bottom).offset(20);
        make.left.equalTo(header_view.mas_left).offset(20);
        make.right.equalTo(header_view.mas_right).offset(-20);
        make.height.mas_equalTo(1);
    }];
    
    self.category_label = [[UILabel alloc] init];
    self.category_label.font = SetFont(14);
    self.category_label.textColor = DetailTextColor;
    self.category_label.text = @"分类";
    [header_view addSubview:self.category_label];
    [self.category_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.imageview.mas_left);
        make.top.equalTo(line.mas_bottom).offset(20);
    }];
}

- (void)setFooterView:(UICollectionReusableView *)footer_view {
    NSLog(@"4444444444444444");
    __weak typeof(self) weakSelf = self;
    UILabel *line = [[UILabel alloc] init];
    line.backgroundColor = SetColor(246, 246, 246, 1);
    [footer_view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footer_view.mas_top).offset(0);
        make.left.equalTo(footer_view.mas_left).offset(20);
        make.right.equalTo(footer_view.mas_right).offset(-20);
        make.height.mas_equalTo(1);
    }];
    
    self.pay_nubmer_label = [[UILabel alloc] init];
    self.pay_nubmer_label.font = SetFont(14);
    self.pay_nubmer_label.textColor = DetailTextColor;
    self.pay_nubmer_label.text = @"购买数量";
    [footer_view addSubview:self.pay_nubmer_label];
    [self.pay_nubmer_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(20);
        make.left.equalTo(line.mas_left);
    }];
    
    self.add_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.add_button setImage:[UIImage imageNamed:@"add_button"] forState:UIControlStateNormal];
    ViewRadius(self.add_button, 15.0);
    [footer_view addSubview:self.add_button];
    [self.add_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.pay_nubmer_label.mas_bottom).offset(20);
        make.right.equalTo(footer_view.mas_right).offset(-20);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.add_button addTarget:self action:@selector(addButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.number_label = [[UILabel alloc] init];
    self.number_label.font = SetFont(14);
    self.number_label.textAlignment = NSTextAlignmentCenter;
    self.number_label.textColor = DetailTextColor;
    self.number_label.text = self.numbers_string;
    ViewBorderRadius(self.number_label, 5.0, 1.0, SetColor(246, 246, 246, 1));
    [footer_view addSubview:self.number_label];
    [self.number_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.add_button.mas_left).offset(-10);
        make.centerY.equalTo(weakSelf.add_button.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(50, 34));
    }];
    
    self.less_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.less_button setImage:[UIImage imageNamed:@"less_button"] forState:UIControlStateNormal];
    ViewRadius(self.less_button, 15.0);
    [footer_view addSubview:self.less_button];
    [self.less_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.number_label.mas_left).offset(-10);
        make.centerY.equalTo(weakSelf.add_button.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.less_button addTarget:self action:@selector(lessButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.select_array removeAllObjects];
    [self.select_array addObject:indexPath];
    [self.collectionview reloadData];
    
    NSDictionary *dic = self.dataArray[indexPath.row];
    self.small_tag_dic = dic;
}

//点击取消
- (void)removeSelfView {
    self.touchCancelAction();
}

//点击确定
- (void)touchConfirmButtonAction {
    self.touchConfirmAction(self.small_tag_dic);
}

- (void)addButtonAction:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(touchAddButtonAction:Numbers:)]) {
        [_delegate touchAddButtonAction:self.add_button Numbers:self.number_label];
    }
}

- (void)lessButtonAction:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(touchLessButtonAction:Numbers:)]) {
        [_delegate touchLessButtonAction:self.less_button Numbers:self.number_label];
    }
}
@end
