//
//  ErrorBookThreeViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/3/18.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "ErrorBookThreeViewController.h"
#import "BookCollectionViewCell.h"
#import "ErrorQuestionBookViewController.h"

@interface ErrorBookThreeViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionview;

@property (nonatomic, strong) NSArray *numberArray;

@end

@implementation ErrorBookThreeViewController

- (void)getNumberWithErrorBook {
    __weak typeof(self) weakSelf = self;
    [MOLoadHTTPManager PostHttpDataWithUrlStr:@"/app_user/ass/find_pitfalls_question_total" Dic:@{} SuccessBlock:^(id responseObject) {
        if ([responseObject[@"state"] integerValue] == 1) {
            weakSelf.numberArray = responseObject[@"data"];
            [weakSelf.collectionview reloadData];
        }
    } FailureBlock:^(id error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"错题本";
    [self setBack];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 20, 10, 20);
    layout.minimumLineSpacing = 10.0;
    layout.minimumInteritemSpacing = 20.0;
    CGFloat item_width = (SCREENBOUNDS.width - 80) / 3;
    layout.itemSize = CGSizeMake(item_width, item_width + 60);
    
    self.collectionview = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.collectionview.backgroundColor = WhiteColor;
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    [self.collectionview registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"oneCell"];
    [self.collectionview registerClass:[BookCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.collectionview];
    __weak typeof(self) weakSelf = self;
    [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self getNumberWithErrorBook];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BookCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.isShowEditButton = NO;
    cell.imageview.image = [UIImage imageNamed:@[@"errorBook_1",@"errorBook_2",@"errorBook_3",@"errorBook_4"][indexPath.row]];
    cell.name_label.text = @[@"一错本", @"一错再错", @"屡错不改", @"错误终结"][indexPath.row];
    NSInteger number = [self.numberArray[indexPath.row] integerValue];
    cell.numbers_label.text = [NSString stringWithFormat:@"已收录%ld条", number];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ErrorQuestionBookViewController *errorQuestion = [[ErrorQuestionBookViewController alloc] init];
    errorQuestion.type = indexPath.row;
    [self.navigationController pushViewController:errorQuestion animated:YES];
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
