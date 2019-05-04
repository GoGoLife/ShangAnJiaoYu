//
//  TextViewMenu.m
//  砺行公考
//
//  Created by 钟文斌 on 2019/4/8.
//  Copyright © 2019 钟文斌. All rights reserved.
//

#import "TextViewMenu.h"

@implementation TextViewMenu

- (instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        UIMenuItem *menuItem = [[UIMenuItem alloc]initWithTitle:@"摘记" action:@selector(digestAction:)];
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        [menuController setMenuItems:[NSArray arrayWithObject:menuItem]];
        [menuController setMenuVisible:NO];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
//        UIMenuItem *menuItem = [[UIMenuItem alloc]initWithTitle:@"摘记" action:@selector(digestAction:)];
//        UIMenuController *menuController = [UIMenuController sharedMenuController];
//        [menuController setMenuItems:[NSArray arrayWithObject:menuItem]];
//        [menuController setMenuVisible:NO];
    }
    return self;
}

- (instancetype)initWithType:(actionType)type {
    self = [super init];
    if (self) {
        if (type == actionType_Digest) {
            UIMenuItem *menuItem = [[UIMenuItem alloc]initWithTitle:@"摘记" action:@selector(digestAction:)];
            UIMenuController *menuController = [UIMenuController sharedMenuController];
            [menuController setMenuItems:[NSArray arrayWithObject:menuItem]];
            [menuController setMenuVisible:NO];
        }else {
            UIMenuItem *menuItem = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(CollectPointAction:)];
            UIMenuController *menuController = [UIMenuController sharedMenuController];
            [menuController setMenuItems:[NSArray arrayWithObject:menuItem]];
            [menuController setMenuVisible:NO];
        }
    }
    return self;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (action == @selector(digestAction:)) {
        return YES;
    }else if (action == @selector(CollectPointAction:)) {
        return YES;
    }
    return NO;
}

//自定义的事件
- (void)digestAction:(id)sender {
    if ([_CustomDelegate respondsToSelector:@selector(touchDigestAction)]) {
        [_CustomDelegate touchDigestAction];
    }
}


/**
 采点

 @param sender 采点
 */
- (void)CollectPointAction:(id)sender {
    NSLog(@"采点");
    NSString *string = [self textInRange:[self selectedTextRange]];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = string;
    if ([_CustomDelegate respondsToSelector:@selector(touchCollectionPoints)]) {
        [_CustomDelegate touchCollectionPoints];
    }
}
@end
