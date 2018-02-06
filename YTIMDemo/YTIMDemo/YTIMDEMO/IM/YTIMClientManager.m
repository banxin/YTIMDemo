//
//  YTIMClientManager.m
//  YTIMDemo
//
//  Created by yanl on 2018/2/2.
//  Copyright © 2018年 yanl. All rights reserved.
//

#import "YTIMClientManager.h"
#import "YTChatTransDataEventImpl.h"
#import "YTChatBaseEventImpl.h"
#import "YTConfigEntity.h"
#import "YTClientCoreSDK.h"

@interface YTIMClientManager ()

/// MobileIMSDK是否已被初始化. true表示已初化完成，否则未初始化
@property (nonatomic, assign) BOOL _init;

@property (nonatomic, strong) YTChatBaseEventImpl *baseEventListener;

@property (nonatomic, strong) YTChatTransDataEventImpl *transDataListener;

@end

@implementation YTIMClientManager

static YTIMClientManager *_instance;

/// 初始化单例
+ (YTIMClientManager *)shareInstance
{
    if (!_instance) {
        
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            
            _instance = [[YTIMClientManager alloc] init];
        });
    }
    
    return _instance;
}

/*
 *  重写init实例方法实现。
 *
 *  @return
 *  @see [NSObject init:]
 */
- (id)init
{
    if (![super init]) {
        
        return nil;
    }
    
    [self initMobileIMSDK];
    
    return self;
}

// 初始化 SDK，APPdelegate 中调用
- (void)initMobileIMSDK
{
    if(!self._init)
    {
        // 设置AppKey
        [YTConfigEntity registerWithAppKey:@"5418023dfd98c579b6001741"];
        
        // 设置服务器ip和服务器端口
        //      [ConfigEntity setServerIp:@"rbcore.openmob.net"];
        //      [ConfigEntity setServerPort:7901];
        
        // 使用以下代码表示不绑定固定port（由系统自动分配），否则使用默认的7801端口
        //      [ConfigEntity setLocalUdpSendAndListeningPort:-1];
        
        // RainbowCore核心IM框架的敏感度模式设置
        //      [ConfigEntity setSenseMode:SenseMode10S];
        
        // 开启DEBUG信息输出
        [YTClientCoreSDK setENABLED_DEBUG:YES];
        
        // 设置事件回调
        self.baseEventListener = [[YTChatBaseEventImpl alloc] init];
        self.transDataListener = [[YTChatTransDataEventImpl alloc] init];
//        self.messageQoSListener = [[MessageQoSEventImpl alloc] init];
        [YTClientCoreSDK sharedInstance].chatBaseEvent = self.baseEventListener;
        [YTClientCoreSDK sharedInstance].chatTransDataEvent = self.transDataListener;
//        [ClientCoreSDK sharedInstance].messageQoSEvent = self.messageQoSListener;
        
        self._init = YES;
    }
}

- (void)releaseMobileIMSDK
{
    [[YTClientCoreSDK sharedInstance] releaseCore];
    [self resetInitFlag];
}

- (void)resetInitFlag
{
    self._init = NO;
}

- (YTChatTransDataEventImpl *) getTransDataListener
{
    return self.transDataListener;
}

- (YTChatBaseEventImpl *) getBaseEventListener
{
    return self.baseEventListener;
}

@end
