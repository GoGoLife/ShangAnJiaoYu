//
//  GlobarFile.h
//  砺行公考
//
//  Created by 钟文斌 on 2018/11/1.
//  Copyright © 2018 钟文斌. All rights reserved.
//

#ifndef GlobarFile_h
#define GlobarFile_h

#import <UIImageView+WebCache.h>

//账号相关
//微吼账号：13588383837 密码：Lixing001
//账号：s32340934   密码：Lixing001
//用户账号:18268865135   用户密码：888888   ID：32815603

#define SCREENBOUNDS [UIScreen mainScreen].bounds.size
#define FRAME(X, Y, W, H) CGRectMake(X, Y, W, H)
//#define IS_IPHONE_X     (( fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)812) < DBL_EPSILON ) || (fabs((double)[[UIScreen mainScreen] bounds].size.width - (double)812) < DBL_EPSILON ))
//#define STATUS_HEIGHT   (IS_IPHONE_X?44:20)
//#define BOTTOM_SAFEAREA_HEIGHT (IS_IPHONE_X? 34 : 0)
//#define TABBAR_HEIGHT   (IS_IPHONE_X? (49 + 34) : 49)

// 判断是否是iPhone X
#define IS_IPHONEX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
// 状态栏高度
#define STATUS_BAR_HEIGHT (IS_IPHONEX ? 44.f : 20.f)
// 导航栏高度
#define KNAVIVIEWHEIGHT (IS_IPHONEX ? 88.f : 64.f)
// tabBar高度
#define TAB_BAR_HEIGHT (IS_IPHONEX ? (49.f + 34.f) : 49.f)
// home indicator
#define HOME_INDICATOR_HEIGHT (IS_IPHONEX ? 34.f : 0.f)

#define APP_TOKEN @"app_token"

//返回按钮
#define setBack()\
\
- (void)setUpNav {\
UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(pop)];\
self.navigationItem.leftBarButtonItem = backItem;\
}

//返回方法
#define pop()\
\
- (void)pop {\
[self.navigationController popViewControllerAnimated:YES];\
}

//判断是不是null类型
#define isNullClass(object)\
({\
NSString *string = @"";\
if ([object isKindOfClass:[NSNull class]])\
string = @"";\
else\
string = [NSString stringWithFormat:@"%@", object];\
(string);\
})\

//判断是否为整形：
#define isPureInt(string) \
({\
BOOL success;\
NSScanner* scan = [NSScanner scannerWithString:string];\
int val;\
success = [scan scanInt:&val] && [scan isAtEnd];\
(success);\
})\

//判断是否为浮点数
#define isPureFloat(string) \
({\
BOOL success;\
NSScanner* scan = [NSScanner scannerWithString:string];\
int val;\
success = [scan scanInt:&val] && [scan isAtEnd];\
(success);\
})\

//View圆角和加边框
#define ViewBorderRadius(View,Radius,Width,Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View圆角
#define ViewRadius(View,Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

//tableview 设置group样式  去除顶部多余部分
#define DropView(tableView)\
\
tableView.contentInset = UIEdgeInsetsMake(-35, 0, 0, 0);\


#define StringWidth() - (CGFloat)calculateRowWidth:(NSString *)string withFont:(CGFloat)font {\
NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};\
CGRect rect = [string boundingRectWithSize:CGSizeMake(0, 30) options:NSStringDrawingUsesLineFragmentOrigin |\
NSStringDrawingUsesFontLeading attributes:dic context:nil];\
return rect.size.width;\
}\

#define StringHeight() - (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize withWidth:(CGFloat)width{\
NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};\
CGRect rect = [string boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin |\
NSStringDrawingUsesFontLeading attributes:dic context:nil];\
return rect.size.height;\
}\


#define RandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1]//随机色生成

#define SetColor(R,G,B,A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]  //设置颜色

#define SetFont(font) [UIFont systemFontOfSize:font]

#define BaseViewColor [UIColor colorWithRed:243/255.0 green:242/255.0 blue:247/255.0 alpha:1]

//分割线颜色
#define LineColor [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1]

#define Color176 [UIColor colorWithRed:176/255.0 green:176/255.0 blue:176/255.0 alpha:1]

#define WhiteColor [UIColor whiteColor]   //白色

//灰色字体
#define DetailTextColor [UIColor colorWithRed:155/255.0 green:155/255.0 blue:155/255.0 alpha:1]

//按钮颜色  浅蓝色
#define ButtonColor SetColor(36, 111, 245, 1)

//文件管理   创建文件
#define CREATE_FILE_DOCUMENT(fileName) [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:fileName]

//采点数据文件
#define Materials_data_file CREATE_FILE_DOCUMENT(@"selected_materials_data")

//大申论   引言数据文件
#define YinYan_data_file CREATE_FILE_DOCUMENT(@"yinyanFile")

//大申论   分析数据文件
#define FenXi_data_file CREATE_FILE_DOCUMENT(@"fenxiFile")

//大申论   对策数据文件
#define DuiCe_data_file CREATE_FILE_DOCUMENT(@"duiceFile")

//大申论  系统给的最佳引言
#define Big_Default_YinYan_file CREATE_FILE_DOCUMENT(@"defaultYinYanFile")

//大申论  系统给的最佳分析
#define Big_Default_FenXi_file CREATE_FILE_DOCUMENT(@"defaultFenXiFile")

//大申论  系统给的最佳对策
#define Big_Default_DuiCe_file CREATE_FILE_DOCUMENT(@"defaultDuiCeFile")

//NSUserDefaults  偏好存储字段
//小申论模板   总题数
#define Small_EssayTests_All_Numbers @"questionCount"

//小申论   当前题目的ID
#define Small_EssayTests_Current_Question_ID @"current_question_id"

//小申论   当前题目的答案
#define Small_EssayTests_Current_Question_Answer @"current_question_answer"

//大申论    保存大申论做题类型
#define Big_EssayTests_Do_type @"chooseType"

//大申论    我的标题
#define BigEssayTests_my_title @"my_title"

#pragma mark ******** 大申论通关训练 **********

/**
 用户自己写的引言段

 @param @"bigTraining_user_yinyan" 引言
 @return file
 */
#define BigTraining_YinYan_File_Data CREATE_FILE_DOCUMENT(@"bigTraining_user_yinyan")

/**
 用户自己写的分析段
 
 @param @"bigTraining_user_fenxi" 分析
 @return file
 */
#define BigTraining_FenXi_File_Data CREATE_FILE_DOCUMENT(@"bigTraining_user_fenxi")

/**
 用户自己写的承接段
 
 @param @"bigTraining_user_chengjie" 承接
 @return file
 */
#define BigTraining_ChengJie_File_Data CREATE_FILE_DOCUMENT(@"bigTraining_user_chengjie")

/**
 用户自己写的对策段
 
 @param @"bigTraining_user_duice" 对策
 @return file
 */
#define BigTraining_DuiCe_File_Data CREATE_FILE_DOCUMENT(@"bigTraining_user_duice")

/**
 用户自己写的结尾段
 
 @param @"bigTraining_user_jiewei" 结尾
 @return file
 */
#define BigTraining_JieWei_File_Data CREATE_FILE_DOCUMENT(@"bigTraining_user_jiewei")

/**
 用户采点数据

 @param @"smallTraining_user_points" 采点（小申论通关训练）
 @return file
 */
#define SmallTraining_Points_FIle_Data CREATE_FILE_DOCUMENT(@"smallTraining_user_points")

/**
 当前申论训练的题目信息

 @param @"currentTestTraining_questionInfo" 文件名
 @return file 文件
 */
#define CurrentTestTraining_QuestionInfo_File_Data CREATE_FILE_DOCUMENT(@"currentTestTraining_questionInfo")

#endif /* GlobarFile_h */
