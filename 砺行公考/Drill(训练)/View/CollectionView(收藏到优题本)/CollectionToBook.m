//
//  CollectionToBook.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/6.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "CollectionToBook.h"
#import "GlobarFile.h"
#import <Masonry.h>
#import "CollectionTableViewCell.h"
#import "MOLoadHTTPManager.h"
#import "CreatBookView.h"
#import "AppDelegate.h"
#import "BaseViewController.h"

@interface CollectionToBook()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) UIButton *addButton;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation CollectionToBook

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = SetColor(39, 39, 39, 0.5);
        [self setViewToView:self];
        [self getHttpData];
    }
    return self;
}

- (void)layoutSubviews {
    [self setBorderLine:self.addButton];
}

- (void)setViewToView:(UIView *)back_view {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = WhiteColor;
    [back_view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(back_view).insets(UIEdgeInsetsMake(130, 50, 130, 50));
    }];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(16);
    label.text = @"收藏到我的优题本";
    [view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view.mas_top).offset(20);
        make.centerX.equalTo(view.mas_centerX);
    }];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_top);
        make.right.equalTo(view.mas_right).offset(-20);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addButton setTitle:@"新建优题本" forState:UIControlStateNormal];
    [self.addButton setTitleColor:SetColor(191, 191, 191, 1) forState:UIControlStateNormal];
    self.addButton.titleLabel.font = SetFont(14);
    [self.addButton addTarget:self action:@selector(addYoutiBookAction) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:self.addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(20);
        make.left.equalTo(view.mas_left).offset(20);
        make.right.equalTo(view.mas_right).offset(-20);
        make.height.mas_equalTo(46);
    }];
    
    __weak typeof(self) weakSelf = self;
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

#pragma mark ---- custom action
- (void)cancelAction {
    [self removeFromSuperview];
}

#pragma mark ---- tableview   delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArray[indexPath.row];
    CollectionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"collection"];
    if (!cell) {
        cell = [[CollectionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.leftImageV sd_setImageWithURL:[NSURL URLWithString:dic[@"note_picture_url_"]] placeholderImage:[UIImage imageNamed:@"no_image"]];
    cell.topLabel.text = dic[@"name_"];
    cell.bottomLabel.text = [NSString stringWithFormat:@"已收录%ld条", [dic[@"note_total_"] integerValue]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return Collection_Cell_Height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = self.dataArray[indexPath.row];
    [self addQuestionToYouTiBook:dic[@"id_"] question_id:self.question_id];
}


/**
 新增优题本
 */
- (void)addYoutiBookAction {
    [self setHidden:YES];
    __weak typeof(self) weakSelf = self;
    AppDelegate *app_delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    CreatBookView *creat = [[CreatBookView alloc] initWithFrame:app_delegate.window.bounds];
    creat.type = 2;
    __block CreatBookView *cc = creat;
    creat.backBlock = ^{
        [cc removeFromSuperview];
    };
    
    //返回名称
    creat.returnBookNameBlock = ^(NSString *name) {
        [cc removeFromSuperview];
        [weakSelf setHidden:NO];
        //重新获取数据
        [weakSelf getHttpData];
    };
    
    [app_delegate.window addSubview:creat];
    
}

- (void)addQuestionToYouTiBook:(NSString *)note_id question_id:(NSString *)question_id {
    BaseViewController *baseVC = (BaseViewController *)[self getCurrentVC];
    NSDictionary *parma = @{
                            @"note_id_":note_id,
                            @"question_id_":question_id
                            };
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/insert_good_question" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"add collect data === %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            [weakSelf cancelAction];
            [baseVC showHUDWithTitle:@"收藏成功"];
        }else {
            [weakSelf cancelAction];
            [baseVC showHUDWithTitle:responseObject[@"msg"]];
        }
    } FailureBlock:^(id error) {
        [baseVC showHUDWithTitle:@"收藏失败"];
    }];
}

/** 获取优题本数据 */
- (void)getHttpData {
    NSDictionary *parma = @{@"type_":@"4"};
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_note" Dic:parma SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            weakSelf.dataArray = responseObject[@"data"][@"note_result_"];
            [weakSelf.tableview reloadData];
        }
    } FailureBlock:^(id error) {
        
    }];
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

//获取Window当前显示的ViewController
- (UIViewController*)getCurrentVC{
    //获得当前活动窗口的根视图
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1)
    {
        //根据不同的页面切换方式，逐步取得最上层的viewController
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}

@end
