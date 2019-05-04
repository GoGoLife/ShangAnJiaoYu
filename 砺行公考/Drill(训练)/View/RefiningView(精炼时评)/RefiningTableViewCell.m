//
//  RefiningTableViewCell.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/3/13.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "RefiningTableViewCell.h"
#import "GlobarFile.h"
#import <Masonry.h>

@interface RefiningTableViewCell ()

@property (nonatomic, strong) UILabel *content_label;

@end

@implementation RefiningTableViewCell

+ (instancetype)creatRefiningCell:(UITableView *)tableview withModel:(RefiningSonModel *)model {
    static NSString *identifier = @"refiningCell";
    RefiningTableViewCell *cell = [tableview dequeueReusableCellWithIdentifier:identifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell creatCellUI:model];
    return cell;
}

- (void)creatCellUI:(RefiningSonModel *)model {
    __weak typeof(self) weakSelf = self;
    UIView *back_view = [[UIView alloc] init];
    back_view.backgroundColor = SetColor(246, 246, 246, 1);
    ViewRadius(back_view, 8.0);
    [self.contentView addSubview:back_view];
    [back_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(5, 70, 5, 20));
    }];
    
    self.content_label = [[UILabel alloc] init];
    self.content_label.font = SetFont(14);
    self.content_label.textColor = DetailTextColor;
    self.content_label.preferredMaxLayoutWidth = SCREENBOUNDS.width - 90;
    self.content_label.numberOfLines = 0;
    self.content_label.text = model.son_content;//@"你睡啥：你这个说法有问题！第一:发录的\\和看视你觉得得到解决亟待";
    [back_view addSubview:self.content_label];
    [self.content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(back_view).insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
