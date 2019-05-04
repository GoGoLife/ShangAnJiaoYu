//
//  CallBack.h
//  TcpClientDemo02
//
//  Created by SQ.Li on 2019/3/19.
//  Copyright © 2019 macbook. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface CallBack : NSObject

-(void)Invoke:(NSString *) data cid:(int)cid;

@end

NS_ASSUME_NONNULL_END
