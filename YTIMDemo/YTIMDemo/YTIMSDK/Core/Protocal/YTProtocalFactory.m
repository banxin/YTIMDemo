//
//  YTProtocalFactory.m
//  YTIMDemo
//
//  Created by yanl on 2018/2/5.
//  Copyright © 2018年 yanl. All rights reserved.
//

#import "YTProtocalFactory.h"
#import "YTToolKits.h"
#import "YTCharsetHelper.h"
#import "YTPErrorResponse.h"
#import "YTProtocalType.h"
#import "YTProtocalFactory.h"
#import "YTPLoginInfoResponse.h"
#import "YTPLoginInfo.h"
#import "YTProtocal.h"

@implementation YTProtocalFactory

/// 将 modle 转成 JSONString
+ (NSString *) create:(id)protocalDataContentObj
{
    return [YTToolKits toJSONString:[YTToolKits toJSONBytesWithDictionary:[YTToolKits toMutableDictionary:protocalDataContentObj]]];
}

+ (id) parse:(NSData *)fullProtocalJASOnBytes
{
    return [YTProtocalFactory parse:fullProtocalJASOnBytes withClass:YTProtocal.class];
}
+ (id) parse:(NSData *)fullProtocalJASOnBytes withClass:(Class)clazz
{
    return [YTToolKits fromDictionaryToObject:
            [YTToolKits fromJSONBytesToDictionary:fullProtocalJASOnBytes] withClass:clazz];
}
+ (id) parseObject:(NSString *)dataContentJSONOfProtocal withClass:(Class)clazz
{
    return [YTToolKits fromDictionaryToObject:
            [YTToolKits fromJSONBytesToDictionary:
             [YTCharsetHelper getBytesWithString:dataContentJSONOfProtocal]] withClass:clazz];
}

//+ (PKeepAliveResponse *) parsePKeepAliveResponse:(NSString *)dataContentOfProtocal
//{
//    return [ProtocalFactory parseObject:dataContentOfProtocal withClass:[PKeepAliveResponse class]];
//}

//+ (YTProtocal *) createPKeepAlive:(NSString *)from_user_id
//{
//    NSString *dataContent = [YTProtocalFactory create:[[PKeepAlive alloc] init]];
//    return [YTProtocal initWithType:FROM_CLIENT_TYPE_OF_KEEP_ALIVE content:dataContent from:from_user_id to:@"0"];
//}

+ (YTPErrorResponse *) parseYTPErrorResponse:(NSString *) dataContentOfProtocal
{
    return [YTProtocalFactory parseObject:dataContentOfProtocal withClass:[YTPErrorResponse class]];
}

+ (YTProtocal *) createPLoginoutInfo:(NSString *) user_id
{
    NSString *dataContent = nil; // 空JSON对象
    return [YTProtocal initWithType:FROM_CLIENT_TYPE_OF_LOGOUT content:dataContent from:user_id to:@"0"];
}

/*!
 * 创建用户登陆消息对象（该对象由客户端发出）.
 * <p>
 * <b>本方法主要由MobileIMSDK框架内部使用。</b>
 *
 * @param loginUserId 提交到服务端的唯一id，保证唯一就可以通信，可能是登陆用户名、也可能是任意不重复的id等，具体意义由业务层决定
 * @param loginToken 提交到服务端用于身份鉴别和合法性检查的token，它可能是登陆密码，也可能是通过前置单点登陆接口拿到的token等，具体意义由业务层决定
 * @param extra 额外信息字符串。本字段目前为保留字段，供上层应用自行放置需要的内容
 * @return 用户登陆消息对象
 */
+ (YTProtocal *) createPLoginInfo:(NSString *)loginUserId withToken:(NSString *)loginToken andExtra:(NSString *)extra
{
    // 实例PLoginInfo
    YTPLoginInfo *li = [[YTPLoginInfo alloc] init];
    
    li.loginUserId = loginUserId;
    li.loginToken = loginToken;
    li.extra = extra;
    
    // 将对象转成 string
    NSString *dataContent = [YTProtocalFactory create:li];
    
    // FROM_CLIENT_TYPE_OF_LOGIN 由客户端发出 - 协议类型：客户端登陆
    return [YTProtocal initWithType:FROM_CLIENT_TYPE_OF_LOGIN content:dataContent
                               from:loginUserId//@"-1"
                                 to:@"0"];
}
+ (YTPLoginInfoResponse *) parseYTPLoginInfoResponse:(NSString *)dataContentOfProtocal
{
    return [YTProtocalFactory parseObject:dataContentOfProtocal withClass:[YTPLoginInfoResponse class]];
}

+ (YTProtocal *) createCommonData:(NSString *)dataContent fromUserId:(NSString *)from_user_id toUserId:(NSString *)to_user_id
{
    return [YTProtocalFactory createCommonData:dataContent fromUserId:from_user_id toUserId:to_user_id qos:YES fp:nil withTypeu:-1];
}
+ (YTProtocal *) createCommonData:(NSString *)dataContent fromUserId:(NSString *)from_user_id toUserId:(NSString *)to_user_id withTypeu:(int)typeu
{
    return [YTProtocalFactory createCommonData:dataContent fromUserId:from_user_id toUserId:to_user_id qos:YES fp:nil withTypeu:typeu];
}
+ (YTProtocal *) createCommonData:(NSString *)dataContent fromUserId:(NSString *)from_user_id toUserId:(NSString *)to_user_id qos:(bool)QoS fp:(NSString *)fingerPrint withTypeu:(int)typeu
{
    return [YTProtocal initWithType:FROM_CLIENT_TYPE_OF_COMMON_DATA content:dataContent from:from_user_id to:to_user_id qos:QoS fp:fingerPrint tu:typeu];
}

+ (YTProtocal *) createRecivedBack:(NSString *)from_user_id toUserId:(NSString *)to_user_id withFingerPrint:(NSString *)recievedMessageFingerPrint
{
    return [YTProtocalFactory createRecivedBack:from_user_id toUserId:to_user_id withFingerPrint:recievedMessageFingerPrint andBridge:NO];
}

+ (YTProtocal *) createRecivedBack:(NSString *)from_user_id toUserId:(NSString *)to_user_id withFingerPrint:(NSString *)recievedMessageFingerPrint andBridge:(bool)bridge
{
    return [YTProtocal initWithType:FROM_CLIENT_TYPE_OF_RECIVED content:recievedMessageFingerPrint from:from_user_id to:to_user_id qos:NO fp:nil bg:bridge tu:-1];
}

@end
