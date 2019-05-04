//
//  MaterialsViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/15.
//  Copyright © 2018 钟文斌. All rights reserved.
//       材料采点页面

#import "MaterialsViewController.h"
//加入采点view
#import "AddCustomMaterialsView.h"

//第三步  整理分类   小申论
#import "ClassifyViewController.h"

//第三步  整理分类   大申论
#import "Big_ThreeViewController.h"

#import "ShowMaterialsView.h"

#import "MaterialsModel.h"

@interface MaterialsViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSString *content_string;

//采点分块区
@property (nonatomic, strong) UIView *bottom_back_view;

//材料一 材料二 材料三 材料四。。。。。
@property (nonatomic, strong) UIScrollView *title_scroll;

//承载材料内容的scrollview
@property (nonatomic, strong) UIScrollView *content_scroll;

//加载后台返回的材料分词之后的数据
@property (nonatomic, strong) UICollectionView *collectionview;

//加载材料的具体内容
@property (nonatomic, strong) UILabel *content_label;

//确认显示的是分词状态   还是整体材料状态  NO === 整体状态   YES === 分词状态
@property (nonatomic, assign) BOOL showMaterialsStatus;

//保存当前点击的材料按钮
@property (nonatomic, assign) NSInteger selected_title_button;

//选择的材料采点   只用于判断哪些是已经选择的
@property (nonatomic, strong) NSMutableArray *select_materials_array;

//保存选择的采点数据    用于添加到采点库里面
@property (nonatomic, strong) NSMutableArray *select_materials_title;

@property (nonatomic, strong) NSIndexPath *m_lastAccessed;

@property (nonatomic, strong) UIPanGestureRecognizer *panGes;

@property (nonatomic, strong) UITapGestureRecognizer *tapGes;

@property (nonatomic, assign) BOOL isScrollCollectionview;


@end

@implementation MaterialsViewController

/**
 获取小申论材料数据
 */
- (void)getHttpData {
    [self showHUD];
    
    NSString *essay_test_id = self.isBigEssayTests ? self.big_essay_id : self.essay_id;
    
    NSDictionary *parma = @{@"essay_id_":essay_test_id};
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_small_essay_material" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"small test materials data === %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            __weak typeof(self) weakSelf = self;
            NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *dic in responseObject[@"data"]) {
                MaterialsModel *model = [[MaterialsModel alloc] init];
                model.materials_id = dic[@"id_"];
                model.content_string = dic[@"content_"];
                model.materials_image_array = dic[@"material_picture_list_"];
                model.materials_array = dic[@"seg_list"];
                [array addObject:model];
            }
            weakSelf.dataArray = [array copy];
            [weakSelf setViewUI];
            [weakSelf hidden];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    self.selected_title_button = 0;
    self.select_materials_array = [NSMutableArray arrayWithCapacity:1];
    self.select_materials_title = [NSMutableArray arrayWithCapacity:1];
    
//    self.content_string = self.dataArray[0][@"content_"];
    self.showMaterialsStatus = NO;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(nextAction)];
    self.navigationItem.rightBarButtonItem = right;
    
//    [self setViewUI];
    
    [self getHttpData];
}


/**
 格式化材料标题

 @param startString 传入材料的index
 @return 返回格式化的材料标题
 */
- (NSString *)replacingString:(NSString *)startString {
    NSString *newStr = @"";
    NSString *replacString = @"";
    for (NSInteger index = 0; index < startString.length; index++) {
        //获取字符串的每个字符
        NSString *temp = [startString substringWithRange:NSMakeRange(index, 1)];
        //进行替换
        switch ([temp integerValue]) {
            case 1:
                replacString = [temp stringByReplacingOccurrencesOfString:temp withString:@"一"];
                break;
            case 2:
                replacString = [temp stringByReplacingOccurrencesOfString:temp withString:@"二"];
                break;
            case 3:
                replacString = [temp stringByReplacingOccurrencesOfString:temp withString:@"三"];
                break;
            case 4:
                replacString = [temp stringByReplacingOccurrencesOfString:temp withString:@"四"];
                break;
            case 5:
                replacString = [temp stringByReplacingOccurrencesOfString:temp withString:@"五"];
                break;
            case 6:
                replacString = [temp stringByReplacingOccurrencesOfString:temp withString:@"六"];
                break;
            case 7:
                replacString = [temp stringByReplacingOccurrencesOfString:temp withString:@"七"];
                break;
            case 8:
                replacString = [temp stringByReplacingOccurrencesOfString:temp withString:@"八"];
                break;
            case 9:
                replacString = [temp stringByReplacingOccurrencesOfString:temp withString:@"九"];
                break;
            default:
                break;
        }
        newStr = [newStr stringByAppendingString:replacString];
    }
    return newStr;
}

- (void)setViewUI {
    UILabel *label = [[UILabel alloc] initWithFrame:FRAME(0, 0, SCREENBOUNDS.width, 40)];
    label.font = SetFont(16);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"第二步：材料采点";
    [self.view addSubview:label];
    
    
    self.title_scroll = [[UIScrollView alloc] initWithFrame:FRAME(0, CGRectGetMaxY(label.frame), SCREENBOUNDS.width, 40)];
    self.title_scroll.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.title_scroll];
    CGFloat width = (SCREENBOUNDS.width - 120) / 5;
    self.title_scroll.contentSize = CGSizeMake((width + 20) * self.dataArray.count + 20, 40);
    for (NSInteger index = 0; index < self.dataArray.count; index++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        ViewRadius(button, 5.0);
        button.backgroundColor = DetailTextColor;
        if (index == 0) {
            button.backgroundColor = ButtonColor;
        }
        button.tag = index;
        button.titleLabel.font = SetFont(12);
        NSString *index_string = [NSString stringWithFormat:@"%ld", index + 1];
        [button setTitle:[NSString stringWithFormat:@"材料%@", [self replacingString:index_string]] forState:UIControlStateNormal];
        button.frame = FRAME(20 + (width + 20) * index, 0, width, 40);
        [button addTarget:self action:@selector(changeMaterialsAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.title_scroll addSubview:button];
    }
    
    //添加材料内容显示视图  默认显示第一段材料
    MaterialsModel *model = self.dataArray[0];
    [self setContent_label_view_UI:model.content_string];
    
    
    //最下方的五个采点分类标签
    self.bottom_back_view = [[UIView alloc] initWithFrame:FRAME(0, CGRectGetMaxY(self.content_scroll.frame), SCREENBOUNDS.width, SCREENBOUNDS.height - CGRectGetMaxY(self.content_scroll.frame))];
    [self.view addSubview:self.bottom_back_view];
    
    UILabel *message = [[UILabel alloc] initWithFrame:FRAME(0, 10, SCREENBOUNDS.width, 20)];
    message.font = SetFont(14);
    message.textColor = DetailTextColor;
    message.textAlignment = NSTextAlignmentCenter;
    message.text = @"长按上方材料进入采点模式";
    [self.bottom_back_view addSubview:message];
    
    UILabel *message1 = [[UILabel alloc] initWithFrame:FRAME(0, 30, SCREENBOUNDS.width, 20)];
    message1.font = SetFont(12);
    message1.textAlignment = NSTextAlignmentCenter;
    message1.text = @"选中材料后点击下方对应类型的分析加入采点区";
    [self.bottom_back_view addSubview:message1];
    
    NSArray *tag_array = @[@"表现", @"效果", @"原因", @"对策", @"背景"];
    CGFloat tag_width = (SCREENBOUNDS.width - 80) / 5;
    for (NSInteger index = 0; index < 5; index++) {
        UIButton *tag_button = [UIButton buttonWithType:UIButtonTypeCustom];
        tag_button.tag = index;
        tag_button.backgroundColor = RandomColor;
        [tag_button setTitle:tag_array[index] forState:UIControlStateNormal];
        ViewRadius(tag_button, 5.0);
        tag_button.frame = FRAME(20 + (tag_width + 10) * index, CGRectGetMaxY(message1.frame) + 10, tag_width, 32);
        [tag_button addTarget:self action:@selector(touch_tag_button_action:) forControlEvents:UIControlEventTouchUpInside];
        [self.bottom_back_view addSubview:tag_button];
    }
    
    UIButton *look_button = [UIButton buttonWithType:UIButtonTypeCustom];
    [look_button setTitleColor:SetColor(48, 132, 252, 1) forState:UIControlStateNormal];
    ViewBorderRadius(look_button, 20.0, 1.0, SetColor(48, 132, 252, 1));
    [look_button setTitle:@"查看采点" forState:UIControlStateNormal];
    look_button.frame = FRAME(0, CGRectGetMaxY(message1.frame) + 52, 228, 40);
    look_button.center = CGPointMake(self.view.center.x, look_button.center.y);
    [look_button addTarget:self action:@selector(look_button_action) forControlEvents:UIControlEventTouchUpInside];
    [self.bottom_back_view addSubview:look_button];
}

//长按点击事件
- (void)longAction {
    self.showMaterialsStatus = YES;
    [self.content_scroll removeFromSuperview];
    [self setCollectionviewUI];
}

- (void)setContent_label_view_UI:(NSString *)content_string {
    //承载材料内容的scrollview
    self.content_scroll.frame = FRAME(0, CGRectGetMaxY(self.title_scroll.frame) + 10, SCREENBOUNDS.width, SCREENBOUNDS.height - CGRectGetMaxY(self.title_scroll.frame) - 170.0 - 64.0);
    [self.view addSubview:self.content_scroll];
    CGFloat content_string_height = [self calculateRowHeight:content_string fontSize:14 withWidth:SCREENBOUNDS.width - 40];
    self.content_scroll.contentSize = CGSizeMake(SCREENBOUNDS.width, content_string_height + 40);
    //材料的具体内容
    self.content_label.frame = FRAME(20, 20, self.content_scroll.bounds.size.width - 40, content_string_height);
    self.content_label.text = content_string;
    [self.content_scroll addSubview:self.content_label];
}

//添加collectionview   炸词之后的collectionview
- (void)setCollectionviewUI {
    [self.view addSubview:self.collectionview];
    [self.collectionview reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    MaterialsModel *model = self.dataArray[self.selected_title_button];
    return [model.materials_array count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MaterialsModel *model = self.dataArray[self.selected_title_button];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NSString *content_string = model.materials_array[indexPath.row];
    [self setCellContent:cell AndTitle:content_string];
    if ([self.select_materials_array containsObject:indexPath]) {
        cell.backgroundColor = ButtonColor;
    }else {
        cell.backgroundColor = WhiteColor;
    }
    return cell;
}

- (void)setCellContent:(UICollectionViewCell *)cell AndTitle:(NSString *)title {
    for (UIView *vv in cell.contentView.subviews) {
        [vv removeFromSuperview];
    }
    cell.backgroundColor = WhiteColor;
    ViewBorderRadius(cell, 10.0, 1.0, DetailTextColor);
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(14);
    label.textColor = DetailTextColor;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    [cell.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell.contentView).insets(UIEdgeInsetsMake(0, 10, 0, 10));
    }];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    MaterialsModel *model = self.dataArray[self.selected_title_button];
    NSString *content_string = model.materials_array[indexPath.row];
    CGFloat width = [self calculateRowWidth:content_string withFont:14];
    return CGSizeMake(width + 22, 40);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //确保点击的具体数据
    MaterialsModel *model = self.dataArray[self.selected_title_button];
    NSString *content_string = model.materials_array[indexPath.row];
    if ([self.select_materials_array containsObject:indexPath]) {
        [self.select_materials_array removeObject:indexPath];
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = WhiteColor;
        [self.select_materials_title removeObject:content_string];
    }else {
        [self.select_materials_array addObject:indexPath];
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = ButtonColor;
        [self.select_materials_title addObject:content_string];
    }
}

#pragma mark ---- custom action
//点击按钮  切换对应的材料数据   数据用sender.tag 区分
- (void)changeMaterialsAction:(UIButton *)sender {
    NSInteger btn_index = sender.tag;
    for (UIButton *button in self.title_scroll.subviews) {
        if (btn_index == button.tag) {
            button.backgroundColor = ButtonColor;
            //点击处于分词状态下的当前材料切换按钮   就保持当前状态
            if (btn_index == self.selected_title_button) {
                return;
            }else {
                [self.select_materials_title removeAllObjects];
                [self.select_materials_array removeAllObjects];
                //判断当前页面出于什么状态   YES分词状态   NO整体状态
                MaterialsModel *model = self.dataArray[btn_index];
//                self.content_string = model.content_string;
                if (self.showMaterialsStatus) {
                    self.showMaterialsStatus = NO;
                    [self.collectionview removeFromSuperview];
                    [self setContent_label_view_UI:model.content_string];
                }else {
                    //直接切换对应的材料
                    [self setContent_label_view_UI:model.content_string];
                }
            }
        }else {
            button.backgroundColor = DetailTextColor;
        }
    }
    self.selected_title_button = btn_index;
}

- (void)touch_tag_button_action:(UIButton *)sender {
    AppDelegate *app_delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //0  ===  表现
    //1  ===  效果
    //2  ===  原因
    //3  ===  对策
    //4  ===  背景
    NSString *tips_id = [NSString stringWithFormat:@"%ld", sender.tag];
    NSString *materials_string = [self.select_materials_title componentsJoinedByString:@""];
    AddCustomMaterialsView *add_view = [[AddCustomMaterialsView alloc] initWithFrame:CGRectZero AndTips_ID:tips_id AndContent_string:materials_string];
    __weak typeof(self) weakSelf = self;
    add_view.addMaterialsDataFinishBlock = ^{
        [weakSelf.select_materials_array removeAllObjects];
        [weakSelf.select_materials_title removeAllObjects];
        [weakSelf.collectionview reloadData];
    };
    [app_delegate.window addSubview:add_view];
    [add_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(app_delegate.window).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

//右上角下一步    方法
- (void)nextAction {
    if (self.isBigEssayTests) {
        Big_ThreeViewController *three = [[Big_ThreeViewController alloc] init];
        [self.navigationController pushViewController:three animated:YES];
        return;
    }
    ClassifyViewController *classify = [[ClassifyViewController alloc] init];
    [self.navigationController pushViewController:classify animated:YES];
}

//查看我的采点
- (void)look_button_action {
    AppDelegate *app_delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    ShowMaterialsView *show_view = [[ShowMaterialsView alloc] initWithFrame:app_delegate.window.bounds];
    [app_delegate.window addSubview:show_view];
}

#pragma mark ---- 懒加载
- (UIScrollView *)content_scroll {
    if (!_content_scroll) {
        _content_scroll = [[UIScrollView alloc] init];
        UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longAction)];
        [_content_scroll addGestureRecognizer:longGes];
    }
    return _content_scroll;
}

- (UILabel *)content_label {
    if (!_content_label) {
        _content_label = [[UILabel alloc] init];
        _content_label.font = SetFont(14);
        _content_label.textColor = SetColor(74, 74, 74, 1);
        _content_label.numberOfLines = 0;
    }
    return _content_label;
}

- (UICollectionView *)collectionview {
    if (!_collectionview) {
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc] init];
        flowlayout.sectionInset = UIEdgeInsetsMake(20, 30, 20, 30);
        flowlayout.minimumLineSpacing = 10.0;
        flowlayout.minimumInteritemSpacing = 10.0;
        
        _collectionview = [[UICollectionView alloc] initWithFrame:FRAME(0, CGRectGetMaxY(self.title_scroll.frame) + 10, SCREENBOUNDS.width, SCREENBOUNDS.height - CGRectGetMaxY(self.title_scroll.frame) - 170.0 - 64.0) collectionViewLayout:flowlayout];
        _collectionview.backgroundColor = WhiteColor;
        _collectionview.delegate = self;
        _collectionview.dataSource = self;
        [_collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        
        //滑动拖拽手势    拖拽选择采点数据
        self.panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesAction:)];
        [_collectionview addGestureRecognizer:self.panGes];
        
        self.tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesAction:)];
        [_collectionview addGestureRecognizer:self.tapGes];
        self.isScrollCollectionview = NO;
        
    }
    return _collectionview;
}

//改变响应手势
- (void)tapGesAction:(UITapGestureRecognizer *)longGes {
    self.isScrollCollectionview = !self.isScrollCollectionview;
    if (self.isScrollCollectionview) {
        [self.collectionview removeGestureRecognizer:self.panGes];
    }else {
        [self.collectionview addGestureRecognizer:self.panGes];
    }
}

- (void)panGesAction:(UIGestureRecognizer *)gestureRecognizer {
    float pointerX = [gestureRecognizer locationInView:self.collectionview].x;
    //    NSLog(@"pointerX = %f",pointerX);
    float pointerY = [gestureRecognizer locationInView:self.collectionview].y;
    
    for(UICollectionViewCell* cell1 in self.collectionview.visibleCells) {
        float cellLeftTop = cell1.frame.origin.x;
        //        NSLog(@"cellLeftTop = %f",cellLeftTop);
        float cellRightTop = cellLeftTop + cell1.frame.size.width;
        float cellLeftBottom = cell1.frame.origin.y;
        float cellRightBottom = cellLeftBottom + cell1.frame.size.height;
        
        if (pointerX >= cellLeftTop && pointerX <= cellRightTop && pointerY >= cellLeftBottom && pointerY <= cellRightBottom) {
            NSIndexPath* touchOver = [self.collectionview indexPathForCell:cell1];
            if (self.m_lastAccessed != touchOver) {
                
                if (cell1.selected) {
                    [self deselectCellForCollectionView:self.collectionview atIndexPath:touchOver];
                }
                else
                {
                    [self selectCellForCollectionView:self.collectionview atIndexPath:touchOver];
                }
            }
            self.m_lastAccessed = touchOver;
            [self.collectionview scrollToItemAtIndexPath:self.m_lastAccessed atScrollPosition:UICollectionViewScrollPositionTop animated:YES];
            
        }
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        self.m_lastAccessed = nil;
        self.collectionview.scrollEnabled = YES;
    }
}

/*Cell已经选择时回调*/
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = (UICollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = WhiteColor;//[UIColor colorWithRed:181.0 / 255.0 green:181.0 / 255.0 blue:181.0 / 255.0 alpha:1];
//    [cell.label setTextColor:[UIColor colorWithRed:181.0 / 255.0 green:181.0 / 255.0 blue:181.0 / 255.0 alpha:1]];
}

/*Cell未选择时回调*/
-(void)selectCellForCollectionView:(UICollectionView*)collection atIndexPath:(NSIndexPath*)indexPath
{
    [collection selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    
    [self collectionView:collection didSelectItemAtIndexPath:indexPath];
}

-(void)deselectCellForCollectionView:(UICollectionView*)collection atIndexPath:(NSIndexPath*)indexPath
{
    [collection deselectItemAtIndexPath:indexPath animated:YES];
    [self collectionView:collection didDeselectItemAtIndexPath:indexPath];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
