//
//  ChatTableViewCell.m
//  weihouDemo
//
//  Created by 钟文斌 on 2019/2/14.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "ChatTableViewCell.h"
#import <Masonry.h>

@implementation ChatTableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView messageModel:(VHallChatModel *)model{
    
    static NSString *identifier = @"chatCell";
    ChatTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[ChatTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell creatViewUI:model];
    
    return cell;
}

- (void)creatViewUI:(VHallChatModel *)model {
    self.content_label.text = [NSString stringWithFormat:@"%@: %@", model.user_name, model.text];
    [self.contentView addSubview:self.content_label];
    __weak typeof(self) weakSelf = self;
    [self.content_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.contentView).insets(UIEdgeInsetsMake(0, 10, 0, 0));
    }];
}

- (UILabel *)content_label {
    if (!_content_label) {
        _content_label = [[UILabel alloc] init];
        _content_label.font = [UIFont systemFontOfSize:14.0];
    }
    return _content_label;
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
