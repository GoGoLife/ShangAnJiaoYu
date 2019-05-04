//
//  DigestContentViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/5.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BaseViewController.h"
#import "BookContentTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface DigestContentViewController : BaseViewController

//笔记本ID
@property (nonatomic, strong) NSString *book_id;

@property (nonatomic, strong) NSString *book_name;

@property (nonatomic, strong) NSString *book_numbers;

@property (nonatomic, strong) NSString *book_details;

@property (nonatomic, strong) NSString *book_image_url;

@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, assign) BOOL isEdit;

@property (nonatomic, strong) NSMutableArray *seleted_array;

@property (nonatomic, strong) UITableView *tableview;

@property (nonatomic, assign) BOOL isSend;

@end

NS_ASSUME_NONNULL_END
