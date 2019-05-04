//
//  ConclutionViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/2/26.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "ConclutionViewController.h"
#import "LineChartsViewController.h"

@interface ConclutionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
{
    NSArray *dataArray;
    NSIndexPath *current_indexPath;
}

@property (nonatomic, strong) UICollectionView *collectionview;

@end

@implementation ConclutionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"总结";
    [self setBack];
    
    [self setleftOrRight:@"right" BarButtonItemWithTitle:@"折线图" target:self action:@selector(touchRightItemAction)];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 20.0;
    CGFloat width = (SCREENBOUNDS.width - 20 * 5) / 4;
    layout.itemSize = CGSizeMake(width, 30.0);
    layout.headerReferenceSize = CGSizeMake(SCREENBOUNDS.width, 40.0);
    
    self.collectionview = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    self.collectionview.backgroundColor = WhiteColor;
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.view addSubview:self.collectionview];
    
    dataArray = @[@[
                      @{@"text":@"高效",@"color_r":@"235",@"color_g":@"124",@"color_b":@"109",@"isSelect":@"0"},
                      @{@"text":@"中效",@"color_r":@"168",@"color_g":@"137",@"color_b":@"185",@"isSelect":@"0"},
                      @{@"text":@"低效",@"color_r":@"112",@"color_g":@"197",@"color_b":@"198",@"isSelect":@"0"},
                      @{@"text":@"浪费时间",@"color_r":@"180",@"color_g":@"217",@"color_b":@"143",@"isSelect":@"0"}
                      ],@[
                      @{@"text":@"高效",@"color_r":@"235",@"color_g":@"124",@"color_b":@"109",@"isSelect":@"0"},
                      @{@"text":@"中效",@"color_r":@"168",@"color_g":@"137",@"color_b":@"185",@"isSelect":@"0"},
                      @{@"text":@"低效",@"color_r":@"112",@"color_g":@"197",@"color_b":@"198",@"isSelect":@"0"},
                      @{@"text":@"浪费时间",@"color_r":@"180",@"color_g":@"217",@"color_b":@"143",@"isSelect":@"0"}
                      ]];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [dataArray[section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = dataArray[indexPath.section][indexPath.row];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    for (UIView *vv in cell.contentView.subviews) {
        [vv removeFromSuperview];
    }
    
    
    ViewBorderRadius(cell.contentView, 8.0, 1.0, SetColor(233, 233, 233, 1));
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = dic[@"text"];
    [cell.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    if ([dic[@"isSelect"] isEqualToString:@"0"]) {
        cell.contentView.backgroundColor = WhiteColor;
    }else {
        cell.contentView.backgroundColor = SetColor([dic[@"color_r"] integerValue], [dic[@"color_g"] integerValue], [dic[@"color_b"] integerValue], 1);
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *header_view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    header_view.backgroundColor = WhiteColor;
    
    for (UIView *vv in header_view.subviews) {
        [vv removeFromSuperview];
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(16);
    label.text = @[@"听课完成情况", @"训练完成情况"][indexPath.section];
    [header_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(header_view).insets(UIEdgeInsetsMake(0, 20, 0, 0));
    }];
    return header_view;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *data = [NSMutableArray arrayWithArray:dataArray];
    NSMutableArray *temp = [NSMutableArray arrayWithCapacity:1];
    for (NSInteger index = 0; index < [dataArray[indexPath.section] count]; index++) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dataArray[indexPath.section][index]];
        if (index == indexPath.row) {
            [dic setObject:@"1" forKey:@"isSelect"];
        }else {
            [dic setObject:@"0" forKey:@"isSelect"];
        }
        [temp addObject:[dic copy]];
    }
    
    [data replaceObjectAtIndex:indexPath.section withObject:temp];
    dataArray = [data copy];
    [self.collectionview reloadData];
}

//跳转到折线图页面
- (void)touchRightItemAction {
    LineChartsViewController *lineCharts = [[LineChartsViewController alloc] init];
    [self.navigationController pushViewController:lineCharts animated:YES];
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
