//
//  YTChatTransDataEventProtocol.h
//  YTIMDemo
//
//  Created by yanl on 2018/2/2.
//  Copyright © 2018年 yanl. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 MobileIMSDK的通用数据通信消息的回调事件接口（如：收到聊天数据事件通知、服务端返回的错误信息事件通知等）
 
 实现此接口后，通过 @link [ClientCoreSDK setChatTransDataEvent:] @/link 方法设置之，可实现回调事件的通知和处理
 */
@protocol YTChatTransDataEventProtocol <NSObject>

/*!
 * 收到普通消息的回调事件通知。
 * <br>
 * 应用层可以将此消息进一步按自已的IM协议进行定义，从而实现完整的即时通信软件逻辑。
 *
 * @param fingerPrintOfProtocal 当该消息需要QoS支持时本回调参数为该消息的特征指纹码，否则为null
 * @param userid 消息的发送者id（RainbowCore框架中规定发送者id=“0”即表示是由服务端主动发过的，否则表示的是其它客户端发过来的消息）
 * @param dataContent 消息内容的文本表示形式
 */
- (void) onTransBuffer:(NSString*)fingerPrintOfProtocal withUserId:(NSString*)userid andContent:(NSString*)dataContent andTypeu:(int)typeu;

/*!
 * 服务端反馈的出错信息回调事件通知。
 *
 * @param errorCode 错误码，定义在常量表 ErrorCode 中有关服务端错误码的定义
 * @param errorMsg 描述错误内容的文本信息
 * @see ErrorCode
 */
- (void) onErrorResponse:(int)errorCode withErrorMsg:(NSString*)errorMsg;

@end
