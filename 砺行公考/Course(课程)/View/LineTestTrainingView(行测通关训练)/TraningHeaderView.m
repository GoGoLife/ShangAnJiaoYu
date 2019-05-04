//
//  TraningHeaderView.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/10.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "TraningHeaderView.h"
#import "GlobarFile.h"
#import <Masonry.h>

@implementation TraningHeaderView

+ (instancetype)creatTraningHeaderView:(UICollectionView *)collectionview Identifier:(NSString *)identifier indexPath:(NSIndexPath *)indexPath withModel:(TraningDoQuestionModel *)model {
//    static NSString *identifier = @"header";
    TraningHeaderView *header_view = [collectionview dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier forIndexPath:indexPath];
    [header_view creatHeaderViewUI:model];
    return header_view;
}

- (void)creatHeaderViewUI:(TraningDoQuestionModel *)model {
    UILabel *question_type = [[UILabel alloc] init];
    question_type.font = SetFont(12);
    question_type.textColor = DetailTextColor;
    question_type.text = @"单选题";
    [self addSubview:question_type];
    __weak typeof(self) weakSelf = self;
    [question_type mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.mas_top).offset(10);
        make.left.equalTo(weakSelf.mas_left).offset(20);
    }];
    
    UILabel *content_label = [[UILabel alloc] init];
    content_label.font = SetFont(16);
    content_label.textColor = SetColor(74, 74, 74, 1);
    content_label.text = @"题目题目题目题目题目题目题目题目题目题目题目题目题目题目题目题目题目题目题目题目题目题目题目题目";//model.question_content;
    [self addSubview:content_label];
    [content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(question_type.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.mas_left).offset(20);
        make.right.equalTo(weakSelf.mas_right).offset(-20);
        make.bottom.equalTo(weakSelf.mas_bottom);
    }];
}


@end
