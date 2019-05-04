//
//  BannerDetailsViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/21.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "BannerDetailsViewController.h"
#import "BannerDetailsModel.h"
#import "AnalysisForLabelTableViewCell.h"
#import "AnalysisForImageTableViewCell.h"

@interface BannerDetailsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation BannerDetailsViewController

- (void)getDetailsData {
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"linkPageId":self.banner_id};
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_app_link_page" Dic:param SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            NSMutableArray *data = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *dic in responseObject[@"data"]) {
                BannerDetailsModel *model = [[BannerDetailsModel alloc] init];
                model.link_page_id = dic[@"link_page_id_"];
                model.type = [NSString stringWithFormat:@"%ld", [dic[@"type_"] integerValue]];
                model.content = dic[@"content_"];
                model.order = [NSString stringWithFormat:@"%ld", [dic[@"order_"] integerValue]];
                [data addObject:model];
            }
            weakSelf.dataArray = [data copy];
            [weakSelf.tableview reloadData];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    
    __weak typeof(self) weakSelf = self;
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = WhiteColor;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[AnalysisForLabelTableViewCell class] forCellReuseIdentifier:@"labelCell"];
    [self.tableview registerClass:[AnalysisForImageTableViewCell class] forCellReuseIdentifier:@"imageCell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self getDetailsData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BannerDetailsModel *model = self.dataArray[indexPath.row];
    if ([model.type isEqualToString:@"3"]) {
        AnalysisForImageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imageCell"];
        [cell.image_view sd_setImageWithURL:[NSURL URLWithString:model.content] placeholderImage:[UIImage imageNamed:@"no_image"]];
        return cell;
    }else {
        AnalysisForLabelTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"labelCell"];
        if ([model.type isEqualToString:@"1"]) {
            cell.content_label.textAlignment = NSTextAlignmentCenter;
            cell.content_label.font = SetFont(16);
        }else {
            cell.content_label.font = SetFont(14);
        }
        cell.content_label.text = model.content;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BannerDetailsModel *model = self.dataArray[indexPath.row];
    return model.content_height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    return footer_view;
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
