//
//  BigEssayWriteContentViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/23.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "BigEssayWriteContentViewController.h"
#import "ShowAndWriteTableViewCell.h"
#import "ChooseDefaultContentViewController.h"
#import "BigTrainingNinethViewController.h"

@interface BigEssayWriteContentViewController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>

@property (nonatomic, strong) UITableView *tableview;

@end

@implementation BigEssayWriteContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    [self setleftOrRight:@"right" BarButtonItemWithTitle:@"下一步" target:self action:@selector(pushNextVC)];
    
    __weak typeof(self) weakSelf = self;
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = WhiteColor;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[ShowAndWriteTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShowAndWriteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textview.tag = indexPath.section;
    if (indexPath.section == 0) {
        cell.textview.scrollEnabled = NO;
        cell.textview.editable = NO;
        cell.textview.text = self.default_content;
    }else {
        cell.textview.delegate = self;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self calculateRowHeight:self.default_content fontSize:14 withWidth:SCREENBOUNDS.width - 80.0] + 60.0;
    }
    return 230.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    header_view.backgroundColor = WhiteColor;
    [self setHeaderView:header_view withSection:section];
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    return footer_view;
}

- (void)setHeaderView:(UIView *)header_view withSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.textColor = DetailTextColor;
    label.text = section == 0 ? @"示范段" : @"我的答案";
    [header_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header_view.mas_left).offset(20);
        make.centerY.equalTo(header_view.mas_centerY);
    }];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.tag == 1) {
        if (self.type == WriteContentType_YinYan) {
            [textView.text writeToFile:BigTraining_YinYan_File_Data atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }else if (self.type == WriteContentType_ChengJie) {
            [textView.text writeToFile:BigTraining_ChengJie_File_Data atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }else {
            [textView.text writeToFile:BigTraining_JieWei_File_Data atomically:YES encoding:NSUTF8StringEncoding error:nil];
        }
    }
}

- (void)pushNextVC {
    [self.view endEditing:YES];
    ChooseDefaultContentViewController *choose = [[ChooseDefaultContentViewController alloc] init];
    switch (self.type) {
        case WriteContentType_YinYan:
            choose.type = ChooseContentType_FenXi;
            break;
        case WriteContentType_ChengJie:
            choose.type = ChooseContentType_DuiCe;
            break;
        case WriteContentType_JieWei:
        {
            //跳转逻辑树图
            BigTrainingNinethViewController *nine = [[BigTrainingNinethViewController alloc] init];
            [self.navigationController pushViewController:nine animated:YES];
            return;
        }
            break;
            
        default:
            break;
    }
    
    [self.navigationController pushViewController:choose animated:YES];
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
