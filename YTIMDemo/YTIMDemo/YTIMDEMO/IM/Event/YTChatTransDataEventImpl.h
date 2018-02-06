//
//  YTChatTransDataEventImpl.h
//  YTIMDemo
//
//  Created by yanl on 2018/2/5.
//  Copyright © 2018年 yanl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTChatTransDataEventProtocol.h"
#import "YTCompletionDefine.h"

@interface YTChatTransDataEventImpl : NSObject<YTChatTransDataEventProtocol>

// 收到消息的回调
@property (nonatomic, copy) YTObserverCompletion receivedBlock;

@end
