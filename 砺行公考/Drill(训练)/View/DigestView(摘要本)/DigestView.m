//
//  DigestView.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/6.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "DigestView.h"
#import "GlobarFile.h"
#import <Masonry.h>
#import "CollectionTableViewCell.h"
#import "StarsView.h"
#import "BookModel.h"
#import "MOLoadHTTPManager.h"
#import <MBProgressHUD.h>

@interface DigestView()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) StarsView *stars;

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation DigestView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = SetColor(39, 39, 39, 0.5);
        [self setViewToView:self];
        self.dataArray = [NSMutableArray arrayWithCapacity:1];
        [self getHttpData];
    }
    return self;
}

//获取摘记本数据
- (void)getHttpData {
    [self.dataArray removeAllObjects];
    NSDictionary *parma = @{@"type_":@"1"};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_note" Dic:parma SuccessBlock:^(id responseObject) {
        //        NSLog(@"digest data == %ld", [responseObject[@"data"][@"note_result_"] count]);
        if ([responseObject[@"state"] integerValue] == 1) {
            for (NSDictionary *dic in responseObject[@"data"][@"note_result_"]) {
                BookModel *for_book_model = [[BookModel alloc] init];
                for_book_model.book_id = dic[@"id_"];
                for_book_model.image_url = @"note_picture_url_";
                for_book_model.name_string = dic[@"name_"];
                for_book_model.numbers_string = [NSString stringWithFormat:@"已收录%ld条", [dic[@"note_total_"] integerValue]];
                for_book_model.details_string = dic[@"desc_"];
                [weakSelf.dataArray addObject:for_book_model];
            }
            [weakSelf.tableview reloadData];
        }else {
//            [self showHUDWithTitle:@"接口请求未成功，不是未知错误"];
        }
    } FailureBlock:^(id error) {
        NSLog(@"error  ===== %@", error);
    }];
}

- (void)setViewToView:(UIView *)back_view {
    __weak typeof(self) weakSelf = self;
    UIView *view = [[UIView alloc] init];
    view.userInteractionEnabled = YES;
    view.backgroundColor = WhiteColor;
    [back_view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(back_view).insets(UIEdgeInsetsMake(130, 50, 130, 50));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(16);
    label.text = @"收藏到我的摘记本";
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top).offset(20);
        make.centerX.equalTo(view.mas_centerX);
    }];
    
    //隐藏view
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    cancelButton.backgroundColor = RandomColor;
    [cancelButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(hiddenView) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_top);
        make.right.equalTo(view.mas_right).offset(-20);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    self.stars = [[StarsView alloc] initWithStarSize:CGSizeMake(25, 25) space:20 numberOfStar:3];
    self.stars.score = 1.0;
    self.stars.supportDecimal = NO;
    [view addSubview:self.stars];
    [self.stars mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(15);
        make.left.equalTo(view.mas_left).offset(70);
        make.width.mas_equalTo(115);
        make.height.mas_equalTo(25);
    }];
    
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addButton setTitle:@"新建摘记本" forState:UIControlStateNormal];
    [self.addButton setTitleColor:SetColor(191, 191, 191, 1) forState:UIControlStateNormal];
    self.addButton.titleLabel.font = SetFont(14);
    [self.addButton addTarget:self action:@selector(creatBook) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.stars.mas_bottom).offset(10);
        make.left.equalTo(view.mas_left).offset(20);
        make.right.equalTo(view.mas_right).offset(-20);
        make.height.mas_equalTo(46);
    }];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[CollectionTableViewCell class] forCellReuseIdentifier:@"collection"];
    [view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.addButton.mas_bottom).offset(10);
        make.left.equalTo(view.mas_left);
        make.right.equalTo(view.mas_right);
        make.bottom.equalTo(view.mas_bottom);
    }];
}

- (void)layoutSubviews {
    [self setBorderLine:self.addButton];
}

#pragma mark ---- tableview   delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BookModel *model = self.dataArray[indexPath.row];
    CollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"collection"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell) {
        cell = [[CollectionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    [cell.leftImageV sd_setImageWithURL:[NSURL URLWithString:model.image_url] placeholderImage:[UIImage imageNamed:@"no_image"]];
    cell.topLabel.text = model.name_string;
    cell.bottomLabel.text = model.numbers_string;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return Collection_Cell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    //获取选择的笔记本Model
    BookModel *model = self.dataArray[indexPath.row];
    __weak typeof(self) weakSelf = self;
    
    if (self.type == OPRATION_TYPE_CREATE) {
        
        NSString *star = [NSString stringWithFormat:@"%ld", self.stars.returnScore ?:(NSInteger)self.stars.score];
        NSString *content = self.digest_content_string;
        
        NSDictionary *parma = @{
                                @"note_id_":model.book_id,
                                @"content_":content,
                                @"star_":star
                                };
        [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/insert_abstract" Dic:parma SuccessBlock:^(id responseObject) {
            if ([responseObject[@"state"] integerValue] == 1) {
                [hud hide:YES];
                [weakSelf hiddenView];
            }else {
                hud.labelText = responseObject[@"msg"];
                [hud hide:YES];
            }
        } FailureBlock:^(id error) {
            hud.labelText = @"出错";
            [hud hide:YES];
        }];
    }else if (self.type == OPRATION_TYPE_MOVE) {
        //将数组转为json格式
//        NSError *error = nil;
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.moveOrCopy_data_array options:kNilOptions error:&error];
//        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSDictionary *parma = @{
                                @"note_id_":model.book_id,
                                @"id_":self.moveOrCopy_data_array,//jsonString,
                                @"type_":@"1"
                                };
        
        [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/move_abstract" Dic:parma SuccessBlock:^(id responseObject) {
            NSLog(@"move book === %@", responseObject);
            if ([responseObject[@"state"] integerValue] == 1) {
                [hud hide:YES];
                [weakSelf hiddenView];
                //完成移动操作之后   代理通知上级页面刷新
                if ([weakSelf.delegate respondsToSelector:@selector(finishOprationAction)]) {
                    [weakSelf.delegate finishOprationAction];
                }
            }else {
                hud.labelText = responseObject[@"msg"];
                [hud hide:YES];
            }
        } FailureBlock:^(id error) {
            hud.labelText = @"出错";
            [hud hide:YES];
        }];
    }else {
        //将数组转为json格式
//        NSError *error = nil;
//        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.moveOrCopy_data_array options:kNilOptions error:&error];
//        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        NSDictionary *parma = @{
                                @"note_id_":model.book_id,
                                @"id_":self.moveOrCopy_data_array,//jsonString,
                                @"type_":@"2"
                                };
        
        [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/move_abstract" Dic:parma SuccessBlock:^(id responseObject) {
            NSLog(@"copy book === %@", responseObject);
            if ([responseObject[@"state"] integerValue] == 1) {
                [hud hide:YES];
                [weakSelf hiddenView];
                //完成移动操作之后   代理通知上级页面刷新
                if ([weakSelf.delegate respondsToSelector:@selector(finishOprationAction)]) {
                    [weakSelf.delegate finishOprationAction];
                }
            }else {
                hud.labelText = responseObject[@"msg"];
                [hud hide:YES];
            }
        } FailureBlock:^(id error) {
            hud.labelText = @"出错";
            [hud hide:YES];
        }];
    }
}

- (void)setBorderLine:(UIButton *)button {
    CAShapeLayer *border = [CAShapeLayer layer];
    //虚线的颜色
    border.strokeColor = SetColor(201, 201, 201, 1).CGColor;
    //填充的颜色
    border.fillColor = [UIColor clearColor].CGColor;
    //设置路径
    border.path = [UIBezierPath bezierPathWithRect:button.bounds].CGPath;
    border.frame = button.bounds;
    //虚线的宽度
    border.lineWidth = 1.f;
    //设置线条的样式
    //    border.lineCap = @"square";
    //虚线的间隔
    border.lineDashPattern = @[@4, @2];
    [button.layer addSublayer:border];
}

- (void)hiddenView {
    [self removeFromSuperview];
}

//新建摘记本   点击新建执行的方法
- (void)creatBook {
    self.creatBookBlock();
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
