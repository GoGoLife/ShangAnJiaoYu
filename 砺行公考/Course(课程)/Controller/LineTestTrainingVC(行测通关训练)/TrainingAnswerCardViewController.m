//
//  TrainingAnswerCardViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/11.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "TrainingAnswerCardViewController.h"
#import "AnswerCollectionViewCell.h"
#import "TrainingAnalysisViewController.h"
#import "CustomAnswerModel.h"

@interface TrainingAnswerCardViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionview;

/**
 题目ID数组   用于获取解析
 */
@property (nonatomic, strong) NSMutableArray *question_id_array;

@end

@implementation TrainingAnswerCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBack];
    
    self.question_id_array = [NSMutableArray arrayWithCapacity:1];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = SetFont(16);
    label.text = @"答题时间：08：31";
    [self.view addSubview:label];
    __weak typeof(self) weakSelf = self;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view.mas_top).offset(20);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
    }];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(20, 30, 20, 30);
    layout.minimumLineSpacing = 20.0;
    layout.minimumInteritemSpacing = 30.0;
    CGFloat width = (SCREENBOUNDS.width - 30 * 6) / 5;
    layout.itemSize = CGSizeMake(width, width);
    
    NSInteger line = self.answerArray.count / 5;
    self.answerArray.count % 5 > 0 ? line++ : line;
    self.collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionview.backgroundColor = WhiteColor;
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    [self.collectionview registerClass:[AnswerCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionview];
    [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(label.mas_bottom).offset(20);
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.height.mas_equalTo((width + 20) * line + 20);
    }];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = SetColor(67, 154, 247, 1);
    button.titleLabel.font = SetFont(16);
    [button setTitleColor:WhiteColor forState:UIControlStateNormal];
    [button setTitle:@"查看精解" forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.collectionview.mas_bottom).offset(30);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(160, 50));
    }];
    ViewRadius(button, 25.0);
    [button addTarget:self action:@selector(pushAnalysisVC) forControlEvents:UIControlEventTouchUpInside];
    
    for (CustomAnswerModel *model in self.answerArray) {
        [self.question_id_array addObject:model.question_id];
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.answerArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomAnswerModel *model = self.answerArray[indexPath.row];
    AnswerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.label.backgroundColor = SetColor(246, 246, 246, 1);
    cell.label.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    //判断是否有答案
    if (model.isHaveAnswer) {
        if (model.isCorrect) {
            cell.label.backgroundColor = ButtonColor;
        }else {
            cell.label.backgroundColor = [UIColor redColor];
        }
    }else {
        cell.label.backgroundColor = DetailTextColor;
    }
    return cell;
}

/** 进入解析界面 */
- (void)pushAnalysisVC {
    TrainingAnalysisViewController *analysis = [[TrainingAnalysisViewController alloc] init];
    analysis.type = [self returnAnalysisTypeWithAnswerCardType:self.type];
    analysis.analysis_question_id_array = [self.question_id_array copy];
    [self.navigationController pushViewController:analysis animated:YES];
}

- (AnalysisType)returnAnalysisTypeWithAnswerCardType:(AnswerCardType)type {
    switch (type) {
        case AnswerCardType_First:
            return AnalysisType_First;
            break;
        case AnswerCardType_Second:
            return AnalysisType_Second;
            break;
        case AnswerCardType_Third:
            return AnalysisType_Third;
            break;
        case AnswerCardType_Fourth:
            return AnalysisType_Fourth;
            break;
        case AnswerCardType_Fifth:
            return AnalysisType_Fifth;
            break;
        case AnswerCardType_Sixth:
            return AnalysisType_Sixth;
            break;
        case AnswerCardType_Seventh:
            return AnalysisType_Seventh;
            break;
        case AnswerCardType_Eighth:
            return AnalysisType_Eighth;
            break;
        case AnswerCardType_Nineth:
            return AnalysisType_Nineth;
            break;
        case AnswerCardType_Tenth:
            return AnalysisType_Tenth;
            break;
        case AnswerCardType_FiveRounds_First:
            return AnalysisType_FiveRounds_First;
            break;
            
        default:
            break;
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
