//
//  QuestionCollectionViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/5.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "QuestionCollectionViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>
#import "TipsCollectionViewCell.h"
#import "ExerciseTableViewCell.h"

@interface QuestionCollectionViewCell ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *indexNumber;

@property (nonatomic, strong) NSMutableArray *select_answer_array;

@end

@implementation QuestionCollectionViewCell

+ (instancetype)creatQuestionCollectionViewCell:(UICollectionView *)collectionview Identifier:(NSString *)identifier indexPath:(NSIndexPath *)indexPath withModel:(QuestionModel *)model {
    QuestionCollectionViewCell *cell = [collectionview dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.backgroundColor = WhiteColor;
    cell.select_answer_array = [NSMutableArray arrayWithCapacity:1];
    [cell initCellUI:model];
    return cell;
}

//- (instancetype)initWithFrame:(CGRect)frame {
//    if (self == [super initWithFrame:frame]) {
//        self.backgroundColor = WhiteColor;
//        self.select_answer_array = [NSMutableArray arrayWithCapacity:1];
//        [self initCellUI];
//    }
//    return self;
//}

- (void)initCellUI:(QuestionModel *)model {
    self.model = model;
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = WhiteColor;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[ExerciseTableViewCell class] forCellReuseIdentifier:@"answerCell"];
    [self.contentView addSubview:self.tableview];
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark ---------   collectionview delegate    datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (collectionView.tag == 100) {
        //材料
        return self.model.question_materials_array.count;
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == 100) {
        //材料
        QuestionMaterialsModel *model = self.model.question_materials_array[section];
        return model.materials_image_array.count;
    }
    return self.model.question_picture_array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TipsCollectionViewCell *imageCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
    if (collectionView.tag == 100) {
        QuestionMaterialsModel *model = self.model.question_materials_array[indexPath.section];
        NSString *image_string = model.materials_image_array[indexPath.row];
        [imageCell.imageview sd_setImageWithURL:[NSURL URLWithString:image_string] placeholderImage:[UIImage imageNamed:@"date"]];
    }else {
        NSString *image_string = self.model.question_picture_array[indexPath.row];
        [imageCell.imageview sd_setImageWithURL:[NSURL URLWithString:image_string] placeholderImage:[UIImage imageNamed:@"date"]];
    }
    return imageCell;
}

StringHeight()
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (collectionView.tag == 100) {
        QuestionMaterialsModel *model = self.model.question_materials_array[section];
        return CGSizeMake(SCREENBOUNDS.width, model.materials_heigth + 20);
    }
//    CGFloat height = [self calculateRowHeight:self.model.question_content fontSize:16 withWidth:SCREENBOUNDS.width - 40] + 150.0;
    return CGSizeMake(SCREENBOUNDS.width, self.model.question_content_height + 50.0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 100) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cellectionHeader" forIndexPath:indexPath];
        for (UIView *vv in header.subviews) {
            [vv removeFromSuperview];
        }
        QuestionMaterialsModel *model = self.model.question_materials_array[indexPath.section];
        UILabel *content_label = [[UILabel alloc] init];
        content_label.font = SetFont(14);
        content_label.textColor = DetailTextColor;
        content_label.numberOfLines = 0;
        content_label.text = model.materials_content;
        [header addSubview:content_label];
        [content_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(header).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        return header;
    }else {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cellectionHeader" forIndexPath:indexPath];
        UILabel *question_type = [[UILabel alloc] init];
        question_type.font = SetFont(14);
        question_type.text = [self.model.question_type isEqualToString:@"0"] ? @"单选题" : @"多选题";
        [header addSubview:question_type];
        [question_type mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(header.mas_top).offset(10);
            make.left.equalTo(header.mas_left).offset(10);
        }];
        
        self.indexNumber = [[UILabel alloc] init];
        self.indexNumber.font = SetFont(14);
        self.indexNumber.text = [NSString stringWithFormat:@"%@/%@", self.question_index, self.question_all_numbers];
        [header addSubview:self.indexNumber];
        [self.indexNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(header.mas_right).offset(-10);
            make.centerY.equalTo(question_type.mas_centerY);
        }];
        
        //设置下划线数据
        NSMutableAttributedString *attributed = [[NSMutableAttributedString alloc] initWithString:self.model.question_content];
        for (NSString *string in self.model.underlineTextList) {
            NSRange range = [self.model.question_content rangeOfString:string];
            [attributed addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:range];
        }
        
        UILabel *content_label = [[UILabel alloc] init];
        content_label.font = SetFont(16);
        content_label.preferredMaxLayoutWidth = SCREENBOUNDS.width - 60;
        content_label.numberOfLines = 0;
        content_label.attributedText = attributed;
        [header addSubview:content_label];
        [content_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(question_type.mas_bottom).offset(10);
            make.left.equalTo(header.mas_left).offset(20);
            make.right.equalTo(header.mas_right).offset(-20);
            make.height.mas_greaterThanOrEqualTo(self.model.question_content_height);
        }];
        return header;
    }
}

#pragma mark -------- tableview delegate   datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return self.model.answer_array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ExerciseTableViewCell *answerCell = [tableView dequeueReusableCellWithIdentifier:@"answerCell"];
    answerCell.leftLabel.text = @[@"A", @"B", @"C", @"D"][indexPath.row];
    answerCell.contentLabel.attributedText = [self returnAnswerContentIndexPath:indexPath];
    if ([self.model.user_selected_answer_array containsObject:indexPath]) {
        answerCell.leftLabel.textColor = ButtonColor;
        answerCell.leftLabel.layer.borderColor = ButtonColor.CGColor;
        answerCell.contentLabel.textColor = ButtonColor;
    }else {
        answerCell.leftLabel.textColor = DetailTextColor;
        answerCell.leftLabel.layer.borderColor = DetailTextColor.CGColor;
        answerCell.contentLabel.textColor = DetailTextColor;
    }
    return answerCell;
}

//将答案的图片 拼接在answerContent 后面
- (NSMutableAttributedString *)returnAnswerContentIndexPath:(NSIndexPath *)indexPath {
    AnswerModel *model = self.model.answer_array[indexPath.row];
    NSMutableAttributedString *mutable_string = [[NSMutableAttributedString alloc] initWithString:model.answer_content];
    if (![model.answer_content_image isEqualToString:@""]) {
        NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:model.answer_content_image]];
        UIImage *image = [UIImage imageWithData:imageData];
        NSTextAttachment *imageText = [[NSTextAttachment alloc] init];
        imageText.image = image;
        imageText.bounds = FRAME(0, 0, 40, 40);
        //创建可携带图片的富文本
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:imageText];
        [mutable_string insertAttributedString:string atIndex:model.answer_content.length];
    }
    return mutable_string;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *content = [NSString stringWithFormat:@"%@", [self returnAnswerContentIndexPath:indexPath]];
    CGFloat height = [self calculateRowHeight:content fontSize:14 withWidth:SCREENBOUNDS.width - 90];
    return height > 70.0 ? height : 70.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        //返回材料的高度
        if (self.model.question_materials_array.count > 0) {
            return (SCREENBOUNDS.height - 64 - 44) / 2;
        }
        return 0.0;
    }else {
        //返回题目 + 图片 的高度
        return self.model.question_collectionview_height + 50.0;
    }
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        return 90.0;
    }
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    if (section == 0) {
        //展示材料
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
        layout.minimumLineSpacing = 10.0;
        layout.minimumInteritemSpacing = 20.0;
        CGFloat itemWidth = (SCREENBOUNDS.width - 100) / 4;
        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        
        self.collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.collectionview.tag = 100;
        self.collectionview.backgroundColor = WhiteColor;
        self.collectionview.delegate = self;
        self.collectionview.dataSource = self;
        [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cellectionHeader"];
        [self.collectionview registerClass:[TipsCollectionViewCell class] forCellWithReuseIdentifier:@"imageCell"];
        [header_view addSubview:self.collectionview];
        [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(header_view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }else {
        //展示题目
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
        layout.minimumLineSpacing = 10.0;
        layout.minimumInteritemSpacing = 20.0;
        CGFloat itemWidth = (SCREENBOUNDS.width - 100) / 4;
        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        
        self.collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        self.collectionview.tag = 200;
        self.collectionview.backgroundColor = WhiteColor;
        self.collectionview.delegate = self;
        self.collectionview.dataSource = self;
        [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"cellectionHeader"];
        [self.collectionview registerClass:[TipsCollectionViewCell class] forCellWithReuseIdentifier:@"imageCell"];
        [header_view addSubview:self.collectionview];
        [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(header_view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
    }
    return  header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    UIButton *next_button = [UIButton buttonWithType:UIButtonTypeCustom];
    next_button.backgroundColor = ButtonColor;
    [next_button setTitleColor:WhiteColor forState:UIControlStateNormal];
    [next_button setTitle:@"下一题" forState:UIControlStateNormal];
    ViewRadius(next_button, 25.0);
    [next_button addTarget:self action:@selector(touchNextButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [footer_view addSubview:next_button];
    [next_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(footer_view).insets(UIEdgeInsetsMake(30, 40, 10, 40));
    }];
    
    if (self.indexPath.row + 1 == [self.question_all_numbers integerValue]) {
        [next_button setTitle:@"确认交卷" forState:UIControlStateNormal];
    }
    
    //如果是单选   隐藏
    if ([self.model.question_type isEqualToString:@"0"]) {
        next_button.hidden = YES;
    }
    return footer_view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    AnswerModel *model = self.model.answer_array[indexPath.row];
    if ([self.model.question_type isEqualToString:@"0"]) {
        //单选题
        [self.select_answer_array removeAllObjects];
        [self.select_answer_array addObject:indexPath];
        self.model.select_answer_array = [self.select_answer_array copy];
        if ([_delegate respondsToSelector:@selector(returnSelectAnswerArray:AndIndexPath:)]) {
            [_delegate returnSelectAnswerArray:self.select_answer_array AndIndexPath:self.indexPath];
        }
    }else {
        //多选题
        if ([self.select_answer_array containsObject:indexPath]) {
            [self.select_answer_array removeObject:indexPath];
            
        }else {
            [self.select_answer_array addObject:indexPath];
        }

    }
    
    ExerciseTableViewCell *cell = (ExerciseTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.leftLabel.textColor = ButtonColor;
    cell.leftLabel.layer.borderColor = ButtonColor.CGColor;
    cell.contentLabel.textColor = ButtonColor;
    
    [self.tableview reloadData];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    ExerciseTableViewCell *cell = (ExerciseTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.leftLabel.textColor = DetailTextColor;
    cell.leftLabel.layer.borderColor = DetailTextColor.CGColor;
    cell.contentLabel.textColor = DetailTextColor;
}

- (void)touchNextButtonAction {
    if ([_delegate respondsToSelector:@selector(returnSelectAnswerArray:AndIndexPath:)]) {
        [_delegate returnSelectAnswerArray:self.select_answer_array AndIndexPath:self.indexPath];
    }
}

@end
