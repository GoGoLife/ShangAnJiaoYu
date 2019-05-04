//
//  SelectCityViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/2.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "SelectCityViewController.h"
#import "SelectCityCollectionViewCell.h"
#import "ThreeQuestionViewController.h"

@interface SelectCityViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionV;

@property (nonatomic, strong) NSArray *cityData;

//记录点击的Cell   确保个数
@property (nonatomic, strong) NSMutableArray *selectItem;

@end

@implementation SelectCityViewController

- (void)getData {
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/user/find_refer_province_list" Dic:@{} SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            NSDictionary *dic = responseObject[@"data"][@"select_list"];
            NSMutableArray *array = [NSMutableArray arrayWithArray:[dic allKeys]];
            [array sortUsingSelector:@selector(compare:)];
            
            NSMutableArray *cityData = [NSMutableArray arrayWithCapacity:1];
            for (NSString *key in array) {
                [cityData addObject:dic[key]];
            }
            
            weakSelf.cityData = [cityData copy];
            [weakSelf.collectionV reloadData];
            
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectItem = [NSMutableArray arrayWithCapacity:1];
    // Do any additional setup after loading the view.
//    self.cityData = @[@[@"安徽省", @"北京市", @"重庆市", @"福建省", @"甘肃省", @"广东省", @"广西壮族", @"贵州省"],
//                      @[@"海南省", @"河北省", @"河南省", @"黑龙江省", @"湖北省", @"湖南省", @"吉林省", @"江苏省", @"江西省", @"辽宁省", @"内蒙古", @"宁夏回族"],
//                      @[@"青海省", @"山东省", @"山西省", @"陕西省", @"上海市", @"四川省", @"天津市", @"西藏", @"新疆维吾尔", @"云南省", @"浙江省"]];
    
    [self setUI];
    
    [self setBack];
    
    [self getData];
    
}

- (void)setUI {
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(22);
    label.text = @"您想参考的省份是？";
    [self.view addSubview:label];
    __weak typeof(self) weakSelf = self;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(20);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    UILabel *label1 = [[UILabel alloc] init];
    label1.textColor = [UIColor grayColor];
    label1.text = @"(最多选五个)";
    [self.view addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(5);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    self.collectionV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionV.backgroundColor = [UIColor whiteColor];
    self.collectionV.delegate = self;
    self.collectionV.dataSource = self;
    [self.collectionV registerClass:[SelectCityCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.collectionV registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.view addSubview:self.collectionV];
    [self.collectionV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label1.mas_bottom);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-140);
    }];
    
    UILabel *label2 = [[UILabel alloc] init];
    label2.font = SetFont(12);
    label2.textColor = [UIColor grayColor];
    label2.text = @"(附:香港,澳门,台湾,暂不支持！)";
    [self.view addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.collectionV.mas_bottom).offset(5);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    UIButton *next = [UIButton buttonWithType:UIButtonTypeCustom];
    [next setTitle:@"下一步" forState:UIControlStateNormal];
    [next setBackgroundColor:SetColor(136, 199, 246, 1)];
    ViewRadius(next, 25.0);
    [next addTarget:self action:@selector(touchPush) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:next];
    [next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left).offset(20);
        make.right.equalTo(weakSelf.view.mas_right).offset(-20);
        make.bottom.equalTo(weakSelf.view.mas_bottom).offset(-50);
        make.height.mas_equalTo(50);
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.cityData.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.cityData[section] count];
//    if (section == 0) {
//        return 8;
//    }else if (section == 1) {
//        return 12;
//    }else {
//        return 11;
//    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SelectCityCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.cityData[indexPath.section][indexPath.row][@"name_"];
    return cell;
}

#pragma mark ------ flowLayout
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 20, 5, 20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = (SCREENBOUNDS.width - 70) / 4;
    return CGSizeMake(itemWidth, 30.0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(SCREENBOUNDS.width, 20);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *HeaderV = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.text = @[@"A-F", @"H-N", @"Q-Z"][indexPath.section];
    [HeaderV addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(HeaderV).insets(UIEdgeInsetsMake(0, 20, 0, 0));
    }];
    return HeaderV;
}

#pragma mark ----- collection Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    SelectCityCollectionViewCell *cell = (SelectCityCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if ([self.selectItem containsObject:indexPath]) {
        cell.textLabel.textColor = [UIColor grayColor];
        cell.textLabel.layer.borderColor = [UIColor grayColor].CGColor;
        [self.selectItem removeObject:indexPath];
    }else {
        if (self.selectItem.count >= 5) {
            [self showHUDWithTitle:@"最多选择5个"];
            return;
        }
        cell.textLabel.textColor = [UIColor blueColor];
        cell.textLabel.layer.borderColor = [UIColor blueColor].CGColor;
        [self.selectItem addObject:indexPath];
    }
}

- (void)touchPush {
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    for (NSIndexPath *indexPath in self.selectItem) {
        NSInteger data = [self.cityData[indexPath.section][indexPath.row][@"id_"] integerValue];
        [array addObject:[NSString stringWithFormat:@"%ld", data]];
    }
    
    NSDictionary *parma = @{@"serial_number_list_":[array copy]};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/user/insert_refer_province" Dic:parma SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            ThreeQuestionViewController *three = [[ThreeQuestionViewController alloc] init];
            [weakSelf.navigationController pushViewController:three animated:YES];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
