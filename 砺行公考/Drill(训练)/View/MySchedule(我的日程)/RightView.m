//
//  RightView.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/3.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "RightView.h"
#import "ScheduleCollectionViewCell.h"
#import <Masonry.h>
#import "GlobarFile.h"
#import "DBManager.h"
#import "ScheduleTagModel.h"

@interface RightView()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation RightView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self getDataFromDBDatabase];
        [self setUI];
    }
    return self;
}

//从数据库加载数据
- (void)getDataFromDBDatabase {
    NSString *sql_string = @"select * from t_scheduletag";
    FMDatabase *dataBase = [FMDatabase databaseWithPath:[[DBManager sharedInstance] creatSqlite]];
    if ([dataBase open]) {
        FMResultSet *result = [dataBase executeQuery:sql_string];
        NSMutableArray *data_array = [NSMutableArray arrayWithCapacity:1];
        while ([result next]) {
            NSString *color_r = [result stringForColumn:@"color_r"];
            NSString *color_g = [result stringForColumn:@"color_g"];
            NSString *color_b = [result stringForColumn:@"color_b"];
            NSString *tag_string = [result stringForColumn:@"content"];
            ScheduleTagModel *model = [[ScheduleTagModel alloc] init];
            model.color_r = color_r;
            model.color_g = color_g;
            model.color_b = color_b;
            model.content_string = tag_string;
            [data_array addObject:model];
        }
        ScheduleTagModel *model = [[ScheduleTagModel alloc] init];
        model.color_r = @"213";
        model.color_g = @"213";
        model.color_b = @"213";
        model.content_string = @"编辑标签";
        [data_array addObject:model];
        
        ScheduleTagModel *model1 = [[ScheduleTagModel alloc] init];
        model1.color_r = @"70";
        model1.color_g = @"156";
        model1.color_b = @"247";
        model1.content_string = @"总结";
        [data_array addObject:model1];
        
        ScheduleTagModel *model2 = [[ScheduleTagModel alloc] init];
        model2.color_r = @"70";
        model2.color_g = @"156";
        model2.color_b = @"247";
        model2.content_string = @"模板";
        [data_array addObject:model2];
        
        ScheduleTagModel *model3 = [[ScheduleTagModel alloc] init];
        model3.color_r = @"70";
        model3.color_g = @"156";
        model3.color_b = @"247";
        model3.content_string = @"分享";
        [data_array addObject:model3];
        
        ScheduleTagModel *model4 = [[ScheduleTagModel alloc] init];
        model4.color_r = @"70";
        model4.color_g = @"156";
        model4.color_b = @"247";
        model4.content_string = @"删除";
        [data_array addObject:model4];
        
        self.dataArray = [data_array copy];
        [self.collectionV reloadData];
    }
}

- (void)setUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 0;
    CGFloat width = SCREENBOUNDS.width / 4 - 20 - 2;
    layout.itemSize = CGSizeMake(width, 30);
    
    self.collectionV = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionV.showsVerticalScrollIndicator = NO;
    self.collectionV.showsHorizontalScrollIndicator = NO;
    self.collectionV.delegate = self;
    self.collectionV.dataSource = self;
    self.collectionV.backgroundColor = [UIColor whiteColor];
    [self.collectionV registerClass:[ScheduleCollectionViewCell class] forCellWithReuseIdentifier:@"right"];
    [self addSubview:self.collectionV];
    __weak typeof(self) weakSelf = self;
    [self.collectionV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ScheduleTagModel *model = self.dataArray[indexPath.row];
    ScheduleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"right" forIndexPath:indexPath];
    ViewRadius(cell.label, 5.0);
    cell.label.font = SetFont(12);
    cell.textAlignment = VerticalAlignmentMiddle;
    cell.label.textAlignment = NSTextAlignmentCenter;
    cell.label.text = model.content_string;
    cell.label.backgroundColor = SetColor([model.color_r integerValue], [model.color_g integerValue], [model.color_b integerValue], 1);
//    if (indexPath.row == self.dataArray.count - 1) {
//        cell.label.textColor = SetColor(175, 175, 175, 1);
//    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([_delegate respondsToSelector:@selector(touchRightViewCellAction:DataCount:TagContent:Color_R:Color_G:Color_B:)]) {
        ScheduleTagModel *model = self.dataArray[indexPath.row];
        //传递点击的cell的具体标识
        [_delegate touchRightViewCellAction:indexPath
                                  DataCount:self.dataArray.count
                                 TagContent:model.content_string
                                    Color_R:model.color_r
                                    Color_G:model.color_g
                                    Color_B:model.color_b];
    }
}
@end
