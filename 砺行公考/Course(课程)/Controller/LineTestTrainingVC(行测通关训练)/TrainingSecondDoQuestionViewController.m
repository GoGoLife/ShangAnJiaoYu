//
//  TraningDoQuestionViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/10.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "TrainingSecondDoQuestionViewController.h"
#import <SJVideoPlayer.h>
#import "QuestionCollectionViewCell.h"
#import "QuestionModuleModel.h"
#import "CustomAnswerModel.h"
#import "TrainingAnswerCardViewController.h"

@interface TrainingSecondDoQuestionViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, QuestionCollectionViewCellDelegate>

@property (nonatomic, strong) UICollectionView *collectionview;

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, strong) NSMutableArray *AnswerSheet_array;

@end

@implementation TrainingSecondDoQuestionViewController

- (void)getDataWithExam {
    NSString *order = @"2";
    if (self.rounds == DoQuestionRounds_FIRST) {
        order = @"2";
    }else if (self.rounds == DoQuestionRounds_SECOND) {
        order = @"2";
    }else {
        order = @"3";
    }
    
    __weak typeof(self) weakSelf = self;
    NSDictionary *param = @{@"fiveTrainNodeId":[[NSUserDefaults standardUserDefaults] objectForKey:@"current_exam_id"], @"order":order};
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/course/five_training/find_exam_details" Dic:param SuccessBlock:^(id responseObject) {
        NSLog(@"exam data == %@", responseObject);
        if ([responseObject[@"state"] integerValue] == 1) {
            [weakSelf formatData:responseObject[@"data"][@"exam_details"]];
        }
    } FailureBlock:^(id error) {
        
    }];
}

//数据
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
            for (NSDictionary *materialsDic in @[]) {
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBack];
    // Do any additional setup after loading the view.
    
    self.AnswerSheet_array = [NSMutableArray arrayWithCapacity:1];
    
    __weak typeof(self) weakSelf = self;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionview.backgroundColor = WhiteColor;
    self.collectionview.pagingEnabled = YES;
    /// 设置此属性为yes 不满一屏幕 也能滚动
    self.collectionview.alwaysBounceHorizontal = YES;
    self.collectionview.showsHorizontalScrollIndicator = NO;
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    [self.collectionview registerClass:[QuestionCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionview];
    [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top);
        make.left.equalTo(weakSelf.view.mas_left);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.right.equalTo(weakSelf.view.mas_right);
    }];
    
    [self getDataWithExam];
//    [self formatData:@{}];
}

#pragma mark ---- collectionview delegate  datasource flowlayout ----
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArr.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    QuestionModuleModel *model = self.dataArr[section];
    return model.moduleQuestionArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf.collectionview scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QuestionModuleModel *model = self.dataArr[indexPath.section];
    QuestionModel *questionModel = model.moduleQuestionArray[indexPath.row];
    NSString *identifier = [NSString stringWithFormat:@"cell+%ld+%ld", indexPath.section, indexPath.row];
    [self.collectionview registerClass:[QuestionCollectionViewCell class] forCellWithReuseIdentifier:identifier];
    QuestionCollectionViewCell *cell = [QuestionCollectionViewCell creatQuestionCollectionViewCell:collectionView Identifier:identifier indexPath:indexPath withModel:questionModel];
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.question_index = [NSString stringWithFormat:@"%ld", [self returnQuestionIndexWithIndexPath:indexPath] + 1];
    cell.question_all_numbers = [NSString stringWithFormat:@"%ld", self.AnswerSheet_array.count];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(SCREENBOUNDS.width, SCREENBOUNDS.height - 70);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(0.0, 0.0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(0.0, 0.0);
}

#pragma mark ---- questionCollectionViewCell delegate -----
- (void)returnSelectAnswerArray:(NSArray *)result AndIndexPath:(NSIndexPath *)indexPath {
    QuestionModuleModel *moduleModel = self.dataArr[indexPath.section];
    QuestionModel *model = moduleModel.moduleQuestionArray[indexPath.row];
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
        if (self.rounds == DoQuestionRounds_SECOND) {
            TrainingAnswerCardViewController *answerCard = [[TrainingAnswerCardViewController alloc] init];
            answerCard.answerArray = [self.AnswerSheet_array copy];
            answerCard.type = AnswerCardType_Second;
            [self.navigationController pushViewController:answerCard animated:YES];
        }else if (self.rounds == DoQuestionRounds_THIRD){
            TrainingAnswerCardViewController *answerCard = [[TrainingAnswerCardViewController alloc] init];
            answerCard.answerArray = [self.AnswerSheet_array copy];
            answerCard.type = AnswerCardType_Third;
            [self.navigationController pushViewController:answerCard animated:YES];
        }
    }else {
        //获取当前collectionview的偏移量
        CGFloat collectionview_offset_x = self.collectionview.contentOffset.x;
        [self.collectionview setContentOffset:CGPointMake(collectionview_offset_x + SCREENBOUNDS.width, 0) animated:YES];
    }
}

#pragma mark --- 做题逻辑处理 -----
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
