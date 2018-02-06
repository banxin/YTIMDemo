//
//  YTChatBaseEventImpl.h
//  YTIMDemo
//
//  Created by yanl on 2018/2/5.
//  Copyright © 2018年 yanl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTChatBaseEventProtocol.h"
#import "YTCompletionDefine.h"

@interface YTChatBaseEventImpl : NSObject<YTChatBaseEventProtocol>

/** 本Observer目前仅用于登陆时（因为登陆与收到服务端的登陆验证结果是异步的，所以有此观察者来完成收到验证后的处理）*/
@property (nonatomic, copy) YTObserverCompletion loginOkForLaunchObserver;// block代码块一定要用copy属性，否则报错！

@end
