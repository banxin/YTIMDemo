//
//  YTProtocalType.h
//  YTIMDemo
//
//  Created by yanl on 2018/2/2.
//  Copyright © 2018年 yanl. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef YTProtocalType_h
#define YTProtocalType_h

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - from client
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*! 由客户端发出 - 协议类型：客户端登陆 */
static NSInteger const FROM_CLIENT_TYPE_OF_LOGIN = 0;
/*! 由客户端发出 - 协议类型：心跳包 */
static NSInteger const FROM_CLIENT_TYPE_OF_KEEP_ALIVE = 1;
/*! 由客户端发出 - 协议类型：发送通用数据 */
static NSInteger const FROM_CLIENT_TYPE_OF_COMMON_DATA = 2;
/*! 由客户端发出 - 协议类型：客户端退出登陆 */
static NSInteger const FROM_CLIENT_TYPE_OF_LOGOUT = 3;
/*! 由客户端发出 - 协议类型：QoS保证机制中的消息应答包（目前只支持客户端间的QoS机制哦） */
static NSInteger const FROM_CLIENT_TYPE_OF_RECIVED = 4;
/*! 由客户端发出 - 协议类型：C2S时的回显指令（此指令目前仅用于测试时） */
static NSInteger const FROM_CLIENT_TYPE_OF_ECHO = 5;


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - from server
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*! 由服务端发出 - 协议类型：响应客户端的登陆 */
static NSInteger const FROM_SERVER_TYPE_OF_RESPONSE_LOGIN = 50;
/*! 由服务端发出 - 协议类型：响应客户端的心跳包 */
static NSInteger const FROM_SERVER_TYPE_OF_RESPONSE_KEEP_ALIVE = 51;
/*! 由服务端发出 - 协议类型：反馈给客户端的错误信息 */
static NSInteger const FROM_SERVER_TYPE_OF_RESPONSE_FOR_ERROR = 52;
/*! 由服务端发出 - 协议类型：反馈回显指令给客户端 */
static NSInteger const FROM_SERVER_TYPE_OF_RESPONSE_ECHO = 53;

#endif /* YTProtocalType_h */
