//
//  MYLabel.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/3.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    VerticalAlignmentTop = 0, //default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
    
} VerticalAlignment;

@interface MYLabel : UILabel {
    
@private
    VerticalAlignment _verticalAlignment;
}

@property (nonatomic) VerticalAlignment verticalAlignment;

@end
