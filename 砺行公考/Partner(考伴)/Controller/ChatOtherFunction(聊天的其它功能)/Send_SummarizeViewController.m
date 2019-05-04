//
//  Send_SummarizeViewController.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/2/28.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "Send_SummarizeViewController.h"
#import "Send_TipsViewController.h"
#import "Send_ExamViewController.h"
#import "Send_StudyViewController.h"
#import "Send_DrillViewController.h"

@interface Send_SummarizeViewController ()

@end

@implementation Send_SummarizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.add_button.hidden = YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SummarizeModel *model = self.dataArray[indexPath.row];
    switch (self.current_type) {
        case 1:
        {
            Send_TipsViewController *tips = [[Send_TipsViewController alloc] init];
            tips.isShowSendItem = YES;
            tips.tips_id = model.notes_id;
            [self.navigationController pushViewController:tips animated:YES];
        }
            break;
        case 2:
        {
            Send_ExamViewController *exam = [[Send_ExamViewController alloc] init];
            exam.isShowSendItem = YES;
            exam.exam_id = model.notes_id;
            [self.navigationController pushViewController:exam animated:YES];
        }
            break;
        case 3:
        {
            Send_StudyViewController *study = [[Send_StudyViewController alloc] init];
            study.isShowSendItem = YES;
            study.study_id = model.notes_id;
            [self.navigationController pushViewController:study animated:YES];
        }
            break;
        case 4:
        {
            Send_DrillViewController *details = [[Send_DrillViewController alloc] init];
            details.isShowSendItem = YES;
            details.Drill_details_id = model.notes_id;
            details.Drill_question_id = model.question_id;
            [self.navigationController pushViewController:details animated:YES];
        }
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
