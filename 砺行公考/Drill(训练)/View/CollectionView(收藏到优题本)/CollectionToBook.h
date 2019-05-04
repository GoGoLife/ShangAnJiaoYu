//
//  CollectionToBook.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/6.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CollectionToBookDelegate <NSObject>

- (void)returnSelectYouTiBookID:(NSString *)idString;

@end

@interface CollectionToBook : UIView

@property (nonatomic, strong) NSString *question_id;

@property (nonatomic, weak) id<CollectionToBookDelegate> delegate;

@end
