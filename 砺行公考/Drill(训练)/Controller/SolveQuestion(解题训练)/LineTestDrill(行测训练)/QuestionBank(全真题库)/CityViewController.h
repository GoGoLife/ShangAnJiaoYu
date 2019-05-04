//
//  CityViewController.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/12.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import "BaseViewController.h"

@interface CityViewController : BaseViewController

//省份ID   根据省份ID  获取市级试卷
@property (nonatomic, strong) NSString *province_id;

@property (nonatomic, assign) NSInteger type;

@end
