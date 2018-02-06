//
//  AppMacro.h
//  ytmallApp
//
//  Created by lxw on 2017/6/8.
//  Copyright © 2017年 ios. All rights reserved.
//

#ifndef AppMacro_h
#define AppMacro_h

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#pragma mark -常量值

//屏幕宽度
#define screenW ([[UIScreen mainScreen] bounds].size.width)
#define getW(w) ([[UIScreen mainScreen] bounds].size.width)/375.0*w
//屏幕高度
#define screenH ([[UIScreen mainScreen] bounds].size.height)
//字体
#define Font(fontSize)  [UIFont systemFontOfSize:fontSize]
#define KRedColor       [UIColor colorWithHexString:@"#ed3a4a"]
#define KUnCheckColor   [UIColor colorWithHexString:@"#c7c7c7"]
#define kBlackColor     [UIColor colorWithHexString:@"#444444"]
#define kGrayColor     [UIColor colorWithHexString:@"#a8a8a8"]
#define kLineColor      [UIColor colorWithRed:(200)/255.0 green:(199)/255.0 blue:(204)/255.0 alpha:1.0]

#define VersionLargeOS11 ([UIDevice currentDevice].systemVersion.doubleValue >= 11.0)

// 底部导航栏的高度
static CGFloat const tarBarButtom = 49;
// 顶部导航栏的高度
static CGFloat const navigationHeight = 64;

static CGFloat const XNavigationHeight = 88;

#pragma mark -  ui color

static NSString * const mainRedColor = @"ed3a4a";

// 十六进制颜色
#define HexColor(hexcolor) [UIColor colorWithHexString:hexcolor]

static NSString * const viewBackColor = @"f8f8f8";
static NSString * const maidenStart = @"MAIDENSTART";

#pragma -- mark net work

static NSString * const YT_NO_NETWORK_TIPS = @"网络竟然崩溃了~";
static NSString * const YT_NON_EXISTENT_TIPS = @"对不起，您访问的页面跑路了";

#pragma --mark "login module"

static NSString * const APPKEY = @"1101";
static NSString * const SID = @"YT_SID";
static NSString * const PWD = @"PASS_WORD";
static NSString * const TOKEN = @"USER_TOKEN";
static NSString * const USER_ID = @"USER_ID";
static NSString * const LOGINFLAG = @"LOGIN_FLAG";

static NSString * const BASE_RED_COLOR = @"ED3A4A";

static NSString * const UserAccount = @"user_account";
static NSString * const LoginSession = @"LOGIN_SESSION";
static NSString * const LoginSid = @"loginSid";
static NSString * const LoginRole = @"ROLE";

#define isIphoneX ([UIScreen mainScreen].bounds.size.height == 812)

//iOS7以后系统
#define IOS7_OR_LATER    ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )
#define IOS11_OR_LATER    ( [[[UIDevice currentDevice] systemVersion] compare:@"11.0"] != NSOrderedAscending )
#ifdef DEBUG
#define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define DLog(...)

#endif /* ytmallApp_pch */

static CGFloat const TabbarCustomItemCout = 5;

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////

// 单例模式
#define SINGLETON_GENERATOR(class_name, shared_func_name)    \
static class_name * s_##class_name = nil;                       \
+ (class_name *)shared_func_name                                \
{                                                               \
static dispatch_once_t once;                                \
dispatch_once(&once, ^{                                     \
s_##class_name = [[super alloc] init];                  \
});                                                         \
return s_##class_name;                                      \
}                                                               \

// 配合SINGLETON_GENERATOR 返回静态实例
#define SINGLETON_SHARED_INSTANCE(class_name)    s_##class_name

// 用在init中检测是否已经init过
#define SINGLETON_CHECK_INITED(class_name)                   \
{if (SINGLETON_SHARED_INSTANCE(class_name)) return SINGLETON_SHARED_INSTANCE(class_name);}

// 基础判空
#define YT_IS_NULL(string) (!string || [string isEqual: @""] || [string isEqual:[NSNull null]])
#define NOT_NONE_STRING(string) string ? string : @""

// 对 传入 nil crash 的保护宏
#define NOT_NONE_STRING(string) string ? string : @""

// 去掉连续空格的判空
#define YT_IS_NULL_WHITE(string) (!string || [string isEqual: @""] || [string isEqual:[NSNull null]] || ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]== 0))

// 判断block是否可用，可用则执行
/*
 // 宏定义之前的用法
 
 if (completionBlock)
 {
    completionBlock(arg1, arg2);
 }

// 宏定义之后的用法
// BLOCK_EXEC(completionBlock, arg1, arg2);
*/
#define BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); };
#endif /* AppMacro_h */
