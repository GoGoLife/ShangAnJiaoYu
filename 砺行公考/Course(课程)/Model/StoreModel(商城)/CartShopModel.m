//
//  CartShopModel.m
//  砺行公考
//
//  Created by 钟文斌 on 2018/12/27.
//  Copyright © 2018 钟文斌. All rights reserved.
//

//{id: '1', title: '超值课程'},
//{id: '2', title: '精品课程'},
//{id: '3', title: '思维训练'},
//{id: '4', title: '言语'},
//{id: '5', title: '数量'},
//{id: '6', title: '资料'},
//{id: '7', title: '文化产品'},
//{id: '8', title: '判断'},
//{id: '9', title: '申论'},
//{id: '10', title: '面试'}

#import "CartShopModel.h"

@implementation CartShopModel

- (NSString *)cart_category_title {
    switch ([_cart_category_title integerValue]) {
        case 1:
            _cart_category_title = @"超值课程";
            break;
        case 2:
            _cart_category_title = @"精品课程";
            break;
        case 3:
            _cart_category_title = @"思维训练";
            break;
        case 4:
            _cart_category_title = @"言语";
            break;
        case 5:
            _cart_category_title = @"数量";
            break;
        case 6:
            _cart_category_title = @"资料";
            break;
        case 7:
            _cart_category_title = @"文化产品";
            break;
        case 8:
            _cart_category_title = @"判断";
            break;
        case 9:
            _cart_category_title = @"申论";
            break;
        case 10:
            _cart_category_title = @"面试";
            break;
        default:
//            _cart_category_title = @"不明确分类";
            break;
    }
    return _cart_category_title;
}

@end
