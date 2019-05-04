//
//  SettingViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/1/23.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "SettingViewController.h"
#import "ShowPersonalInfoTableViewCell.h"
#import "ChooseAddressViewController.h"
#import <Hyphenate/Hyphenate.h>

@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, strong) NSString *cacheString;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设置";
    [self setBack];
    
    self.tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableview.backgroundColor = WhiteColor;
    self.tableview.scrollEnabled = NO;
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    [self.tableview registerClass:[ShowPersonalInfoTableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.tableview];
    __weak typeof(self) weakSelf = self;
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 130, 0));
    }];
    
    UIButton *logout = [UIButton buttonWithType:UIButtonTypeCustom];
    logout.titleLabel.font = SetFont(18);
    logout.backgroundColor = SetColor(242, 68, 89, 1);
    [logout setTitleColor:WhiteColor forState:UIControlStateNormal];
    [logout setTitle:@"退出登录" forState:UIControlStateNormal];
    ViewRadius(logout, 25.0);
    [logout addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:logout];
    [logout mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.tableview.mas_bottom).offset(10);
        make.left.equalTo(weakSelf.view.mas_left).offset(40);
        make.right.equalTo(weakSelf.view.mas_right).offset(-40);
        make.height.mas_equalTo(50.0);
    }];
    
    //计算缓存
    self.cacheString = [NSString stringWithFormat:@"%.2fM", [self folderSize]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ShowPersonalInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (indexPath.section == 0) {
        cell.content_label.textAlignment = NSTextAlignmentLeft;
        cell.name_label.text =  @"手机号";
        cell.content_label.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    }else {
        cell.name_label.text = @[@"备考情况变更", @"收货地址管理", @"清除缓存"][indexPath.row];
        cell.content_label.text = @"";
        if (indexPath.row == 2) {
            cell.content_label.text = self.cacheString;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header_view = [[UIView alloc] init];
    header_view.backgroundColor = SetColor(246, 246, 246, 1);
    return header_view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer_view = [[UIView alloc] init];
    footer_view.backgroundColor = SetColor(246, 246, 246, 1);
    return footer_view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
    }else {
        if (indexPath.row == 0) {
            
        }else if (indexPath.row == 1) {
            //收货地址
            ChooseAddressViewController *chooseAddress = [[ChooseAddressViewController alloc] init];
            [self.navigationController pushViewController:chooseAddress animated:YES];
        }else {
            //清除缓存
            [self removeCache];
        }
    }
}

/**
 退出登录
 */
- (void)logoutAction {
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:APP_TOKEN];
    
    //删除数据库文件
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *filePath = [path stringByAppendingPathComponent:@"lixing.sqlite"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDelete = [fileManager removeItemAtPath:filePath error:nil];
    if (isDelete) {
        NSLog(@"数据库文件删除成功");
    }else{
        NSLog(@"数据库文件删除失败");
    }
    
    [[EMClient sharedClient] logout:YES];
    
    AppDelegate *app_delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app_delegate setLoginVCToWindowRoot];
}

// 计算缓存大小
- (CGFloat)folderSize{
    CGFloat folderSize = 0.0;
    
    //获取路径
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)firstObject];
    
    //获取所有文件的数组
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    
    NSLog(@"文件数：%ld",files.count);
    
    for(NSString *path in files) {
        
        NSString*filePath = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",path]];
        
        //累加
        folderSize += [[NSFileManager defaultManager]attributesOfItemAtPath:filePath error:nil].fileSize;
    }
    //转换为M为单位
    CGFloat sizeM = folderSize /1024.0/1024.0;
    
    return sizeM;
}

- (void)removeCache{
    //===============清除缓存==============
    //获取路径
    NSString*cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask,YES)objectAtIndex:0];
    
    //返回路径中的文件数组
    NSArray*files = [[NSFileManager defaultManager] subpathsAtPath:cachePath];
    
    NSLog(@"文件数：%ld",[files count]);
    for(NSString *p in files){
        NSError*error;
        
        NSString* path = [cachePath stringByAppendingString:[NSString stringWithFormat:@"/%@",p]];
        
        if([[NSFileManager defaultManager] fileExistsAtPath:path])
        {
            BOOL isRemove = [[NSFileManager defaultManager]removeItemAtPath:path error:&error];
            if(isRemove) {
                NSLog(@"清除成功");
                //这里发送一个通知给外界，外界接收通知，可以做一些操作（比如UIAlertViewController）
                self.cacheString = @"0.0M";
                [self.tableview reloadData];
                
            }else{
                NSLog(@"清除失败");
            }
        }
    }
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
