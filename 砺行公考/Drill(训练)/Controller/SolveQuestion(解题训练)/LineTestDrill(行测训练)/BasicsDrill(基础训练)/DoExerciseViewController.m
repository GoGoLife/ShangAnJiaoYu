//
//  DoExerciseViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/7.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "DoExerciseViewController.h"
#import "DoExerciseCollectionViewCell.h"
#import "AnswerResultView.h"
#import "SolveResultViewController.h"
#import "QuestionModuleModel.h"
#import "AnswerModel.h"
#import "CustomAnswerModel.h"
//重写的做题cell
#import "QuestionCollectionViewCell.h"
//收藏到优题本
#import "CollectionToBook.h"
//草稿纸
#import "DrawView.h"
#import "SolveFunctionViewController.h"

@interface DoExerciseViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, QuestionCollectionViewCellDelegate, ChainReactionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionview;

//题目数据数组
@property (nonatomic, strong) NSArray *dataArr;

//result 数组  所选择的答案   不是后台返回的答案
@property (nonatomic, strong) NSMutableArray *resultArray;

//答题卡数据
@property (nonatomic, strong) NSMutableArray *AnswerSheet_array;

@property (nonatomic, assign) NSInteger nextRow;

@property (nonatomic, assign) NSInteger nextSection;

@property (nonatomic, strong) DrawView *drawView;

@property (nonatomic, strong) AnswerResultView *answerView;

/**
 当前indexPath
 */
@property (nonatomic, strong) NSIndexPath *current_indexPath;

@end

@implementation DoExerciseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBack];
    // Do any additional setup after loading the view.
    self.resultArray = [NSMutableArray arrayWithCapacity:1];
    self.AnswerSheet_array = [NSMutableArray arrayWithCapacity:1];
    self.nextRow = 0;
    self.nextSection = 0;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"答题卡" style:UIBarButtonItemStylePlain target:self action:@selector(answerAction)];
    UIBarButtonItem *right1 = [[UIBarButtonItem alloc] initWithTitle:@"草稿纸" style:UIBarButtonItemStylePlain target:self action:@selector(scratchAction)];
    UIBarButtonItem *right2 = [[UIBarButtonItem alloc] initWithTitle:@"优题" style:UIBarButtonItemStylePlain target:self action:@selector(collectionAction)];
    self.navigationItem.rightBarButtonItems = @[right2, right1, right];
    
    [self setViewUI];
    
    //整理数据
    if (self.type == EXERCISE_TYPE_ERRORBOOK_ONE || self.type == EXERCISE_TYPE_ERRORBOOK_TWO || self.type == EXERCISE_TYPE_ERRORBOOK_MORE) {
        [self formatterErrorBookDoExersise:self.question_data];
    }else {
        [self formatData:self.question_data];
    }
    
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"StartTime"];
    
}

//除错题本做题的整理数据通用方法
- (void)formatData:(NSDictionary *)dic {
    NSMutableArray *data_array = [NSMutableArray arrayWithCapacity:1];
    //大模块的数据
    for (NSDictionary *moduleDic in dic[@"bigTopicList"]) {
        QuestionModuleModel *moduleModel = [[QuestionModuleModel alloc] init];
        moduleModel.moduleID = moduleDic[@"examThreeType"];
        moduleModel.moduleName = moduleDic[@"content_"];
        moduleModel.modeuleTitle = moduleDic[@"title"];
        //模块下的题目数据
        NSMutableArray *question_data = [NSMutableArray arrayWithCapacity:1];
        for (NSDictionary *questionDic in moduleDic[@"topicList"]) {
            QuestionModel *questionModel = [[QuestionModel alloc] init];
            //初始化用户选择的答案
            questionModel.user_selected_answer_array = @[];
            //题目ID
            questionModel.question_id = questionDic[@"id"];
            //题目 单选  多选
            questionModel.question_type = questionDic[@"isMultipleSelection"];
            //题目题干
            questionModel.question_content = questionDic[@"title"];
            //题目下划线
            questionModel.underlineTextList = questionDic[@"underlineTextList"];
            //题目图片数据
            NSMutableArray *question_image_array = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *question_image_dic in questionDic[@"fileList"]) {
                [question_image_array addObject:question_image_dic[@"path_"]];
            }
            questionModel.question_picture_array = [question_image_array copy];;
            //材料数据
            NSMutableArray *question_materials = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *materialsDic in questionDic[@"materialList"]) {
                QuestionMaterialsModel *materialsModel = [[QuestionMaterialsModel alloc] init];
                materialsModel.materials_id = materialsDic[@"id_"] ?: materialsDic[@"id"];
                materialsModel.materials_content = materialsDic[@"content_"] ?: materialsDic[@"content"];
                //材料图片
                NSMutableArray *materials_image_array = [NSMutableArray arrayWithCapacity:1];
                for (NSDictionary *materials_image in materialsDic[@"fileList"]) {
                    [materials_image_array addObject:materials_image[@"path_"]];
                }
                materialsModel.materials_image_array = materials_image_array;
                [question_materials addObject:materialsModel];
            }
            questionModel.question_materials_array = [question_materials copy];
            
            //选项数组
            NSMutableArray *answer_array = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *answerDic in questionDic[@"optionList"]) {
                AnswerModel *answerModel = [[AnswerModel alloc] init];
                answerModel.answer_id = @"";
                answerModel.answer_content = answerDic[@"content"];
                answerModel.answer_order = [NSString stringWithFormat:@"%ld", [answerDic[@"order"] integerValue]];
                answerModel.answer_content_image = answerDic[@"path"];
                answerModel.isCorrect = [NSString stringWithFormat:@"%ld", [answerDic[@"answer"] integerValue]];
                [answer_array addObject:answerModel];
            }
            questionModel.answer_array = [answer_array copy];
            
            [question_data addObject:questionModel];
            
            //添加所有题目到答题卡
            CustomAnswerModel *customModel = [[CustomAnswerModel alloc] init];
            customModel.question_id = questionDic[@"id"];
            //还没有作答
            customModel.option_id_array = @[];
            customModel.isHaveAnswer = NO;
            customModel.isCorrect = NO;
            //材料ID数组
            NSMutableArray *materials_id_array = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *materialsDic in questionDic[@"materialList"]) {
                [materials_id_array addObject:materialsDic[@"id_"] ?: materialsDic[@"id"]];
            }
            customModel.question_materials_id_array = [materials_id_array copy];
            [self.AnswerSheet_array addObject:customModel];
            
        }
        //单个题目数据加入到模块Model中
        moduleModel.moduleQuestionArray = [question_data copy];
        [data_array addObject:moduleModel];
    }
    self.dataArr = [data_array copy];
    [self.collectionview reloadData];
    [self hidden];
}

//整理错题本训练的题目
- (void)formatterErrorBookDoExersise:(NSDictionary *)dataDic {
    NSMutableArray *data_array = [NSMutableArray arrayWithCapacity:1];
    //大模块的数据
    QuestionModuleModel *moduleModel = [[QuestionModuleModel alloc] init];
    moduleModel.moduleID = @"";//moduleDic[@"examThreeType"];
    moduleModel.moduleName = @"";//moduleDic[@"content_"];
    moduleModel.modeuleTitle = @"";//moduleDic[@"title"];
    //模块下的题目数据
    NSMutableArray *question_data = [NSMutableArray arrayWithCapacity:1];
    for (NSDictionary *questionDic in dataDic[@"data"]) {
        QuestionModel *questionModel = [[QuestionModel alloc] init];
        //题目ID
        questionModel.question_id = questionDic[@"id_"];
        //题目 单选  多选
        questionModel.question_type = [NSString stringWithFormat:@"%ld", [questionDic[@"is_multiple_selection_"] integerValue]];
        //题目题干
        questionModel.question_content = questionDic[@"content_"];
        //题目下划线
        questionModel.underlineTextList = @[];//questionDic[@"underlineTextList"];
        //题目图片数据
//        NSMutableArray *question_image_array = [NSMutableArray arrayWithCapacity:1];
//        for (NSString *question_image_url in questionDic[@"question_choice_picture_result"]) {
//            [question_image_array addObject:question_image_url];
//        }
        questionModel.question_picture_array = questionDic[@"question_choice_picture_result"]; //[question_image_array copy];;
        //材料数据
        NSMutableArray *question_materials = [NSMutableArray arrayWithCapacity:1];
        for (NSDictionary *materialsDic in questionDic[@"question_material_result"]) {
            QuestionMaterialsModel *materialsModel = [[QuestionMaterialsModel alloc] init];
            materialsModel.materials_id = materialsDic[@"id_"] ?: materialsDic[@"id"];
            materialsModel.materials_content = materialsDic[@"content_"] ?: materialsDic[@"content"];
            //材料图片
            NSMutableArray *materials_image_array = [NSMutableArray arrayWithCapacity:1];
            for (NSDictionary *materials_image in materialsDic[@"fileList"]) {
                [materials_image_array addObject:materials_image[@"path_"]];
            }
            materialsModel.materials_image_array = materials_image_array;
            [question_materials addObject:materialsModel];
        }
        questionModel.question_materials_array = [question_materials copy];
        
        //选项数组
        NSMutableArray *answer_array = [NSMutableArray arrayWithCapacity:1];
        for (NSDictionary *answerDic in questionDic[@"tp_options_result"]) {
            AnswerModel *answerModel = [[AnswerModel alloc] init];
            answerModel.answer_id = @"";
            answerModel.answer_content = answerDic[@"content_"];
            answerModel.answer_order = @"";//[NSString stringWithFormat:@"%ld", [answerDic[@"order"] integerValue]];
            answerModel.answer_content_image = answerDic[@"question_picture_id_"];
            answerModel.isCorrect = [NSString stringWithFormat:@"%ld", [answerDic[@"answer_"] integerValue]];
            [answer_array addObject:answerModel];
        }
        questionModel.answer_array = [answer_array copy];
        
        [question_data addObject:questionModel];
        
        //添加所有题目到答题卡
        CustomAnswerModel *customModel = [[CustomAnswerModel alloc] init];
        customModel.question_id = questionDic[@"id_"];
        //还没有作答
        customModel.option_id_array = @[];
        customModel.isHaveAnswer = NO;
        customModel.isCorrect = NO;
        //材料ID数组
        NSMutableArray *materials_id_array = [NSMutableArray arrayWithCapacity:1];
        for (NSDictionary *materialsDic in questionDic[@"question_material_result"]) {
            [materials_id_array addObject:materialsDic[@"id_"] ?: materialsDic[@"id"]];
        }
        customModel.question_materials_id_array = [materials_id_array copy];
        [self.AnswerSheet_array addObject:customModel];
        
    }
    //单个题目数据加入到模块Model中
    moduleModel.moduleQuestionArray = [question_data copy];
    [data_array addObject:moduleModel];
    self.dataArr = [data_array copy];
    [self.collectionview reloadData];
    [self hidden];
}

- (void)setViewUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.minimumLineSpacing = 20;
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(SCREENBOUNDS.width - 20, SCREENBOUNDS.height - 20 - 64);
    
    self.collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionview.backgroundColor = WhiteColor;
    self.collectionview.pagingEnabled = YES;
    /// 设置此属性为yes 不满一屏幕 也能滚动
    self.collectionview.alwaysBounceHorizontal = YES;
    self.collectionview.showsHorizontalScrollIndicator = NO;
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    [self.collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    [self.view addSubview:self.collectionview];
    __weak typeof(self) weakSelf = self;
    [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    QuestionModuleModel *model = self.dataArr[section];
    return model.moduleQuestionArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QuestionModuleModel *model = self.dataArr[indexPath.section];
    QuestionModel *questionModel = model.moduleQuestionArray[indexPath.row];
    NSString *identifier = [NSString stringWithFormat:@"cell+%ld+%ld", indexPath.section, indexPath.row];
    [self.collectionview registerClass:[QuestionCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    QuestionCollectionViewCell *cell = [QuestionCollectionViewCell creatQuestionCollectionViewCell:collectionView Identifier:identifier indexPath:indexPath withModel:questionModel];
    cell.backgroundColor = [UIColor yellowColor];
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.question_index = [NSString stringWithFormat:@"%ld", [self returnQuestionIndexWithIndexPath:indexPath] + 1];
    cell.question_all_numbers = [NSString stringWithFormat:@"%ld", self.AnswerSheet_array.count];
    cell.model = questionModel;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (self.type == EXERCISE_TYPE_BANK) {
        return CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height);
    }
    return CGSizeZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *header_view = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
    header_view.backgroundColor = WhiteColor;
    QuestionModuleModel *model = self.dataArr[indexPath.section];
    NSString *finish = [NSString stringWithFormat:@"%@\n\n%@", model.moduleName, model.modeuleTitle];
    
    for (UIView *vv in header_view.subviews) {
        [vv removeFromSuperview];
    }
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(16);
    label.numberOfLines = 0;
    label.text = finish;
    [header_view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header_view.mas_top).offset(20);
        make.left.equalTo(header_view.mas_left).offset(20);
        make.right.equalTo(header_view.mas_right).offset(-20);
    }];
    
    return header_view;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ---- delegate
/**
 表示用户选择了答案

 @param result 返回的结果
 @param indexPath 题目的indexPath
 */
- (void)returnSelectAnswerArray:(NSArray *)result AndIndexPath:(NSIndexPath *)indexPath {
    self.current_indexPath = indexPath;
    NSString *module = @"";
    if (self.type == EXERCISE_TYPE_BASICS) {
        module = @"公考基础能力训练";
    }else if (self.type == EXERCISE_TYPE_FUNCTION) {
        module = @"公考解题方法训练";
    }else if (self.type == EXERCISE_TYPE_BANK) {
        module = @"全真题库训练";
    }else if (self.type == EXERCISE_TYPE_OPTIONAL) {
        module = @"自选题库训练";
    }
    
    //百度统计
//    [[BaiduMobStat defaultStat] logEvent:@"90cdbaffc2128e79" eventLabel:@"做题分析" attributes:@{@"class":@"砺行测试版",@"module":module}];
    NSString *class_name = [[NSUserDefaults standardUserDefaults] objectForKey:@"class_name"] ?: @"";
    [[BaiduMobStat defaultStat] logEventWithDurationTime:@"90cdbaffc2128e79" eventLabel:@"做题分析" durationTime:1.0 attributes:@{@"class":class_name,@"module":module}];
    
    QuestionModuleModel *moduleModel = self.dataArr[indexPath.section];
    QuestionModel *model = moduleModel.moduleQuestionArray[indexPath.row];
    model.user_selected_answer_array = result;
    BOOL isCorrect = NO;
    //将数据存入答题卡Model中
    CustomAnswerModel *customModel = self.AnswerSheet_array[[self returnQuestionIndexWithIndexPath:indexPath]];
    for (NSIndexPath *AnswerIndexPath in result) {
        //获取选择的答案
        AnswerModel *answerModel = model.answer_array[AnswerIndexPath.row];
        if ([answerModel.isCorrect isEqualToString:@"0"]) {
            //表示有错误答案
            isCorrect = NO;
            //表示做了
            customModel.isHaveAnswer = YES;
            //保存是否做正确了
            customModel.isCorrect = isCorrect;
            break;
        }else {
            isCorrect = YES;
        }
    }
    //表示做了
    customModel.isHaveAnswer = YES;
    //保存是否做正确了
    customModel.isCorrect = isCorrect;
    
    if (indexPath.section == self.dataArr.count - 1 && indexPath.row == moduleModel.moduleQuestionArray.count - 1) {
        [self answerAction];
    }else {
        //获取当前collectionview的偏移量
        CGFloat collectionview_offset_x = self.collectionview.contentOffset.x;
        [self.collectionview setContentOffset:CGPointMake(collectionview_offset_x + SCREENBOUNDS.width, 0) animated:YES];
    }
    
    //记录该题已经做过
    [self recordCurrentQuestionIsDo:model.question_id];
    
//    if (indexPath.row < moduleModel.moduleQuestionArray.count - 1) {
//        self.nextRow++;
//    }else if (indexPath.row == moduleModel.moduleQuestionArray.count - 1){
//        self.nextRow = 0;
//        self.nextSection++;
//    }
    
}

/**
 将试卷所有题目都整合在了一个数组里面
 本方法旨在根据indexPath  获取到在整个数组中当前题目的位置

 @param indexPath 当前的indexPath
 @return 当前题目的位置
 */
- (NSInteger)returnQuestionIndexWithIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return indexPath.row;
    }
    
    NSInteger question_index = 0;
    for (NSInteger section = indexPath.section - 1; section >= 0; section--) {
        QuestionModuleModel *model = self.dataArr[section];
        NSInteger count = model.moduleQuestionArray.count;
        question_index += count;
    }
    
    return question_index + indexPath.row;
}

//答题卡
- (void)answerAction {
    self.answerView = [[AnswerResultView alloc] initWithFrame:self.view.bounds withCordArray:[self setAnswerCardData]];
    self.answerView.reactionView.delegate = self;
    self.answerView.data_array = [self.AnswerSheet_array copy];
    __weak typeof(self) weakSelf = self;
    self.answerView.touchSaveActionBlock = ^{
//        [weakSelf showHUDWithTitle:@"退出"];
        [weakSelf.answerView removeFromSuperview];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"退出将无法保存答案" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            [weakSelf.navigationController popViewControllerAnimated:YES];
            for (UIViewController *vc in weakSelf.navigationController.viewControllers) {
                if ([vc isKindOfClass:[SolveFunctionViewController class]]) {
                    [weakSelf.navigationController popToViewController:vc animated:YES];
                }
            }
        }]];
        [weakSelf presentViewController:alert animated:YES completion:nil];
    };
    
    //答题卡  点击交卷
    self.answerView.touchSubmitActionBlock = ^{
        SolveResultViewController *result = [[SolveResultViewController alloc] init];
        result.information_id = weakSelf.information_id;
        result.nameArray = [weakSelf setAnswerCardData];
        result.result_array = [weakSelf.AnswerSheet_array copy];
        NSInteger index = -1;
        if (self.type == EXERCISE_TYPE_ERRORBOOK_ONE) {
            index = 1;
        }else if (self.type == EXERCISE_TYPE_ERRORBOOK_TWO) {
            index = 2;
        }else if (self.type == EXERCISE_TYPE_ERRORBOOK_MORE) {
            index = 3;
        }
        result.DoExerciseType = index;
        [weakSelf.navigationController pushViewController:result animated:YES];
    };
    [self.view addSubview:self.answerView];
}

#pragma mark ---- 答题卡 delegate
- (void)returnCollectionviewDidSelectIndexPath:(NSIndexPath *)indexPath {
    [self.answerView removeFromSuperview];
    NSIndexPath *indexP = [self returnQuestionIndexPath:indexPath];
    [self.collectionview scrollToItemAtIndexPath:indexP atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

/**
 获取题目的indexPath

 @param indexPath 答题卡中点击的indexPath
 @return 题目的实际indexPath
 */
- (NSIndexPath *)returnQuestionIndexPath:(NSIndexPath *)indexPath {
    NSIndexPath *real_indexPath;
    NSInteger section = 0;
//    NSInteger row = 0;
    NSInteger questionCount = 0;
    for (NSInteger index = 0; index < self.dataArr.count; index++) {
        QuestionModuleModel *model = self.dataArr[index];
        questionCount += model.moduleQuestionArray.count;
        if (indexPath.row < questionCount) {
            NSInteger row =  model.moduleQuestionArray.count - (questionCount - indexPath.row);
            
            real_indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            
            return real_indexPath;
        }else {
            section+=1;
        }
    }
    
    return indexPath;
}

/**
 记录当前题目是否做过

 @param question_id 当前题目ID
 */
- (void)recordCurrentQuestionIsDo:(NSString *)question_id {
    NSDictionary *parma = @{
                            @"topic_id_":question_id,
                            @"topic_type_":@"1",
                            @"describe_":@"1",
                            @"reserved_":@"1"
                            };
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/question/insert_user_topic_record" Dic:parma SuccessBlock:^(id responseObject) {
        NSLog(@"记录题目是否做过  上传是否成功 == %@", responseObject);
    } FailureBlock:^(id error) {
        NSLog(@"记录题目是否做过  上传出错 == %@", error);
    }];
}

//草稿纸
- (void)scratchAction {
    AppDelegate *app_delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    DrawView *drawView = [[DrawView alloc] init];
    drawView.frame = app_delegate.window.bounds;//CGRectMake(0, 100, self.view.bounds.size.width, 300);
    [self setDrawViewButtonAction:drawView];
    [app_delegate.window addSubview:drawView];
    self.drawView = drawView;
    //设置画板背景颜色
    self.drawView.backgroundColor = SetColor(155, 155, 155, 0.8);
    //设置画笔宽度
    self.drawView.lineWidth = 5;
    //设置画笔颜色
    self.drawView.lineColor = WhiteColor;
}

//收藏题目到优题本
- (void)collectionAction {
    NSInteger all_question_index = 0;
    if (!self.current_indexPath) {
        all_question_index = self.collectionview.contentOffset.x / SCREENBOUNDS.width;
    }else {
        all_question_index = [self returnQuestionIndexWithIndexPath:self.current_indexPath];
    }
    CustomAnswerModel *model = self.AnswerSheet_array[all_question_index];
    AppDelegate *app_delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    CollectionToBook *youtiBook = [[CollectionToBook alloc] initWithFrame:app_delegate.window.frame];
    youtiBook.question_id = model.question_id;
    [app_delegate.window addSubview:youtiBook];
}

//根据选择的数据整理答题卡最上方题数汇总要显示的数据
- (NSArray *)setAnswerCardData {
    NSInteger sum = self.AnswerSheet_array.count;//self.resultArray.count;
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
    if (sum <= 20) {
        [array addObject:[NSString stringWithFormat:@"1~%ld", sum]];
    }else {
        NSInteger forIndex = sum / 20;
        NSInteger endIndex = sum % 20;
        for (NSInteger index = 0; index < forIndex; index++) {
            [array addObject:[NSString stringWithFormat:@"%ld~%ld", index * 20 + 1 , 20 * (index + 1)]];
        }
        if (endIndex > 0) {
            [array addObject:[NSString stringWithFormat:@"%ld~%ld", forIndex * 20 + 1, forIndex * 20 + endIndex]];
        }
    }
    return [array copy];
}

- (void)setDrawViewButtonAction:(UIView *)drawView {
    NSArray *title_array = @[@"撤销", @"清空", @"绘制", @"返回"];
    CGFloat width = SCREENBOUNDS.width / title_array.count;
    for (NSInteger index = 0; index < title_array.count; index++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = SetFont(14);
        [button setTitleColor:WhiteColor forState:UIControlStateNormal];
        [button setTitle:title_array[index] forState:UIControlStateNormal];
        button.tag = index;
        [button addTarget:self action:@selector(buttonIndexAction:) forControlEvents:UIControlEventTouchUpInside];
        [drawView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(drawView.mas_top).offset(20);
            make.left.equalTo(drawView.mas_left).offset(width * index);
            make.size.mas_equalTo(CGSizeMake(width, 40));
        }];
    }
}

- (void)buttonIndexAction:(UIButton *)sender {
    if ([sender.titleLabel.text isEqualToString:@"撤销"]) {
        [self.drawView undo];
    }else if ([sender.titleLabel.text isEqualToString:@"擦除"]) {
        //已放弃
//        [self.drawView eraser];
    }else if ([sender.titleLabel.text isEqualToString:@"清空"]) {
        [self.drawView clean];
    }else if ([sender.titleLabel.text isEqualToString:@"绘制"]) {
        self.drawView.lineColor = WhiteColor;
    }else if ([sender.titleLabel.text isEqualToString:@"返回"]) {
        [self.drawView removeFromSuperview];
    }
}

@end
