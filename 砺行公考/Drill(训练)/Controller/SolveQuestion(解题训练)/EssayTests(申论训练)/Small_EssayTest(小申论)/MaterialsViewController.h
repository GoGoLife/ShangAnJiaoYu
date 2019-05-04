//
//  MaterialsViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/15.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

@interface MaterialsViewController : BaseViewController

//判断是否是大申论页面跳转过来的
@property (nonatomic, assign) BOOL isBigEssayTests;

@property (nonatomic, strong) NSString *title_string;

//材料数组-----数据
@property (nonatomic, strong) NSArray *dataArray;

/** 小申论大题的ID  用于获取材料数据 */
@property (nonatomic, strong) NSString *essay_id;


/** 大申论ID  用于获取材料数据 */
@property (nonatomic, strong) NSString *big_essay_id;

@end
