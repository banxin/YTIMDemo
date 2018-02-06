//
//  YTIMClientManager.h
//  YTIMDemo
//
//  Created by yanl on 2018/2/2.
//  Copyright © 2018年 yanl. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YTChatTransDataEventImpl, YTChatBaseEventImpl;

@interface YTIMClientManager : NSObject

/// 单例
+ (YTIMClientManager *)shareInstance;

// 初始化 SDK，APPdelegate 中调用
- (void)initMobileIMSDK;

/**
 * 重置init标识
 *
 * 重要说明：不退出APP的情况下，重新登陆时记得调用一下本方法，不然再
 * 次调用 {@link #initMobileIMSDK()} 时也不会重新初始化MobileIMSDK（
 * 详见 {@link #initMobileIMSDK()}代码）而报 code=203错误！
 */
- (void)resetInitFlag;

- (YTChatTransDataEventImpl *) getTransDataListener;
- (YTChatBaseEventImpl *) getBaseEventListener;

@end
