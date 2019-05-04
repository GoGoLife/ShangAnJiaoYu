//
//  ErrorBookNaviViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/3/16.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "ErrorBookNaviViewController.h"
#import "LeftNaviView.h"
#import "CenterNaviView.h"
#import "RightNaviView.h"
#import "FuncNivaModel.h"

@interface ErrorBookNaviViewController ()<NaviLeftDidSelectDelegate, NaviCenterDidSelectDelegate, NaviRightDidSelectDelegate>

@property (nonatomic, strong) NSArray *center_all_array;

@property (nonatomic, strong) NSArray *right_all_array;

@property (nonatomic, assign) NSInteger left_select_index;

@property (nonatomic, assign) NSInteger center_select_index;

@property (nonatomic, assign) NSInteger right_select_index;

@property (nonatomic, strong) LeftNaviView *left_view;

@property (nonatomic, strong) CenterNaviView *center_view;

@property (nonatomic, strong) RightNaviView *right_view;

/** 模块ID */
@property (nonatomic, strong) NSArray *module_array;

@property (nonatomic, strong) NSArray *func_array;

@end

@implementation ErrorBookNaviViewController

- (void)getFuncData {
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_method_all_node" Dic:@{} SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            NSMutableArray *funcArray = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *bigDic in responseObject[@"data"]) {
                //方法大类
                FuncNivaModel *bigModel = [[FuncNivaModel alloc] init];
                bigModel.func_id = bigDic[@"id_"];
                bigModel.func_name = bigDic[@"name_"];
                bigModel.parent_id = bigDic[@"parent_id_"];
                //大类下面的具体方法
                NSMutableArray *indexArray = [NSMutableArray arrayWithCapacity:1];
                for (NSDictionary *funcIndexDic in bigDic[@"children"]) {
                    FuncIndexModel *indexModel = [[FuncIndexModel alloc] init];
                    indexModel.parent_id = funcIndexDic[@"parent_id_"];
                    indexModel.func_index_id = funcIndexDic[@"id_"];
                    indexModel.func_index_name = funcIndexDic[@"name_"];
                    [indexArray addObject:indexModel];
                }
                bigModel.func_index_array = [indexArray copy];
                [funcArray addObject:bigModel];
            }
            weakSelf.func_array = [funcArray copy];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"导航";
    [self setBack];
    
    CGFloat width = SCREENBOUNDS.width / 3;
    self.left_view = [[LeftNaviView alloc] init];
    self.left_view.delegate = self;
    [self.view addSubview:self.left_view];
    
    self.center_view = [[CenterNaviView alloc] init];
    self.center_view.delegate = self;
    [self.view addSubview:self.center_view];
    
    self.right_view = [[RightNaviView alloc] init];
    self.right_view.delegate = self;
    [self.view addSubview:self.right_view];
    
    __weak typeof(self) weakSelf = self;
    [self.left_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.left.equalTo(weakSelf.view.mas_left);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.width.mas_equalTo(width);
    }];
    
    [self.center_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.left.equalTo(weakSelf.left_view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.width.mas_equalTo(width);
    }];
    
    [self.right_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.left.equalTo(weakSelf.center_view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.width.mas_equalTo(width);
    }];
    
    //模块
    NSMutableArray *module = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < 6; i++) {
        FuncNivaModel *model = [[FuncNivaModel alloc] init];
        model.parent_id = @"";
        model.func_id = @[@"00000000000000000001000100010000",
                          @"00000000000000000001000100020000",
                          @"00000000000000000001000100030000",
                          @"00000000000000000001000100040000",
                          @"00000000000000000001000100050000",
                          @"00000000000000000001000100060000"][i];
        model.func_name = @[@"言语理解",@"数量关系",@"常识判断",@"判断推理",@"资料分析",@"综合分析"][i];
        [module addObject:model];
    }
    
    //时间
    NSMutableArray *time = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < 4; i++) {
        FuncNivaModel *model = [[FuncNivaModel alloc] init];
        model.parent_id = @"";
        model.func_id = [NSString stringWithFormat:@"%d", i + 1];
        model.func_name = @[@"最近一周",@"最近一月",@"最近三月",@"最近半年"][i];
        [time addObject:model];
    }
    
    //星级
    NSMutableArray *stars = [NSMutableArray arrayWithCapacity:1];
    for (int i = 0; i < 4; i++) {
        FuncNivaModel *model = [[FuncNivaModel alloc] init];
        model.parent_id = @"";
        model.func_id = [NSString stringWithFormat:@"%d", i + 1];
        model.func_name = @[@"一星",@"两星",@"三星",@"四星",@"五星"][i];
        [stars addObject:model];
    }
    
    
    self.center_all_array = @[[module copy], [time copy], [stars copy]];
    
    self.module_array = @[@"00000000000000000001000100010000",
                          @"00000000000000000001000100020000",
                          @"00000000000000000001000100030000",
                          @"00000000000000000001000100040000",
                          @"00000000000000000001000100050000",
                          @"00000000000000000001000100060000"];
    
    [self getFuncData];
}

//左边视图点击
- (void)leftViewSelectRow:(NSInteger)index DataString:(NSString *)data {
    self.left_select_index = index;
    if (index < 3) {
        self.center_view.center_data_array = self.center_all_array[self.left_select_index];
    }else {
        self.center_view.center_data_array = self.func_array;
    }
}

//中间视图点击
- (void)centerViewSelectRow:(NSInteger)index DataString:(NSString *)data {
    //记录中间视图点击的index
    self.center_select_index = index;
    NSDictionary *data_dic;
    if (self.left_select_index == 0) {
        FuncNivaModel *model = self.center_all_array[self.left_select_index][index];
        //模块
        data_dic = @{@"big_type":[NSString stringWithFormat:@"%ld", self.left_select_index + 5],
                     @"small_type":model.func_id
                     };
    }else if (self.left_select_index == 1) {
        //时间
        FuncNivaModel *model = self.center_all_array[self.left_select_index][index];
        data_dic = @{@"big_type":[NSString stringWithFormat:@"%ld", self.left_select_index + 5],
                     @"small_type":model.func_id
                     };
    }else if (self.left_select_index == 2) {
        //难度系数
        FuncNivaModel *model = self.center_all_array[self.left_select_index][index];
        data_dic = @{@"big_type":[NSString stringWithFormat:@"%ld", self.left_select_index + 5],
                     @"small_type":model.func_id
                     };
    }else {
        //方法
        FuncNivaModel *model = self.func_array[index];
        self.right_view.right_data_array = model.func_index_array;
        return;
    }
    
    if ([_delegate respondsToSelector:@selector(returnSearchData:)]) {
        [_delegate returnSearchData:data_dic];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

//右边视图点击
- (void)rightViewSelectRow:(NSInteger)index DataString:(NSString *)data {
    FuncNivaModel *model = self.func_array[self.center_select_index];
    FuncIndexModel *indexModel = model.func_index_array[index];
    NSDictionary *data_dic = @{@"big_type":[NSString stringWithFormat:@"%ld", self.left_select_index + 5],
                               @"small_type":indexModel.func_index_id
                               };
    if ([_delegate respondsToSelector:@selector(returnSearchData:)]) {
        [_delegate returnSearchData:data_dic];
    }
    [self.navigationController popViewControllerAnimated:YES];
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
