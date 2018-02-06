//
//  YTProtocal.m
//  YTIMDemo
//
//  Created by yanl on 2018/2/2.
//  Copyright © 2018年 yanl. All rights reserved.
//

#import "YTProtocal.h"
#import "YTToolKits.h"
#import "RMMapper.h"
#import "YTCharsetHelper.h"
#import "YTPErrorResponse.h"
#import "YTProtocalType.h"
#import "YTProtocalFactory.h"
#import "YTPLoginInfoResponse.h"
#import "YTPLoginInfo.h"

@interface YTProtocal ()

@property (nonatomic, assign) int retryCount;

@end

@implementation YTProtocal

/*!
 *  创建Protocal对象的快捷方法（QoS标记默认为true、typeu默认=-1）。
 *
 *  @param type        协议类型
 *  @param dataContent 协议数据内容
 *  @param from        消息发出方的id（当用户登陆时，此值可不设置）
 *  @param to          消息接收方的id（当用户退出时，此值可不设置）
 *
 *  @return 新建的Protocal对象
 */
+ (YTProtocal *) initWithType:(int)type content:(NSString *)dataContent from:(NSString *)from to:(NSString *)to
{
    return [YTProtocal initWithType:type content:dataContent from:from to:to qos:YES fp:nil tu:-1];
}
+ (YTProtocal *) initWithType:(int)type content:(NSString *)dataContent from:(NSString *)from to:(NSString *)to tu:(int)typeu
{
    return [YTProtocal initWithType:type content:dataContent from:from to:to qos:YES fp:nil tu:typeu];
}
+ (YTProtocal *) initWithType:(int)type content:(NSString *)dataContent from:(NSString *)from to:(NSString *)to qos:(bool)QoS fp:(NSString *)fingerPrint tu:(int)typeu
{
    return [YTProtocal initWithType:type content:dataContent from:from to:to qos:QoS fp:fingerPrint bg:NO tu:typeu];
}
+ (YTProtocal *) initWithType:(int)type content:(NSString *)dataContent from:(NSString *)from to:(NSString *)to qos:(bool)QoS fp:(NSString *)fingerPrint bg:(bool)bridge tu:(int)typeu
{
    YTProtocal *p = [[YTProtocal alloc] init];
    
    p.type = type;
    p.dataContent = dataContent;
    p.from = from;
    p.to = to;
//    p.QoS = QoS;
    p.bridge = bridge;
    p.typeu = typeu;
    
    if(QoS && fingerPrint == nil)
        p.fp = [YTProtocal genFingerPrint];
    else
        p.fp = fingerPrint;
    
    return p;
}

- (id)init
{
    if(self = [super init])
    {
        self.type = 0;
        self.from = @"-1";
        self.to = @"-1";
//        self.QoS = NO;
        self.bridge = NO;
        self.typeu = -1;
        self.retryCount = 0;
    }
    return self;
}

- (int) getRetryCount
{
    return self.retryCount;
}

- (void) increaseRetryCount
{
    self.retryCount += 1;
}

- (NSString *) toGsonString
{
    return [YTToolKits toJSONString:[self toBytes]];
}

- (NSData *) toBytes
{
    NSMutableDictionary *dic = [self toMutableDictionary:YES];
    return [YTToolKits toJSONBytesWithDictionary:dic];
}
- (NSMutableDictionary *) toMutableDictionary:(BOOL)deleteRetryCountProperty
{
    NSMutableDictionary *dic = [YTToolKits toMutableDictionary:self];
    if(deleteRetryCountProperty)
        [dic removeObjectForKey:@"retryCount"];
    return dic;
}

- (YTProtocal *) clone
{
    NSMutableDictionary *dic = [self toMutableDictionary:YES];
    YTProtocal *pepFromJASON = [RMMapper objectWithClass:[YTProtocal class] fromDictionary:dic];
    return pepFromJASON;
}

+ (NSString *) genFingerPrint
{
    return [YTToolKits generateUUID];
}

@end
