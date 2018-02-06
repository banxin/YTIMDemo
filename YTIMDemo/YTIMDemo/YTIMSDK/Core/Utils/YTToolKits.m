//
//  YTToolKits.m
//  YTIMDemo
//
//  Created by yanl on 2018/2/2.
//  Copyright © 2018年 yanl. All rights reserved.
//

#import "YTToolKits.h"
#import "YTCharsetHelper.h"
#import "RMMapper.h"

@implementation YTToolKits

+ (NSString *) toJSONString:(NSData *)datas
{
    NSString *jsonStr = [YTCharsetHelper getString:datas];
    
    return jsonStr;
}
+ (NSData *) toJSONBytesWithDictionary:(NSDictionary *)dic
{
    NSData *jsonData = [YTCharsetHelper getJSONBytesWithDictionary:dic];
    
    return jsonData;
}

+ (NSMutableDictionary *) toMutableDictionary:(id)obj
{
    NSMutableDictionary *dic = [RMMapper mutableDictionaryForObject:obj];
    return dic;
}

+ (NSDictionary *) fromJSONBytesToDictionary:(NSData *)jsonBytes
{
    return [NSJSONSerialization JSONObjectWithData:jsonBytes options:0 error:nil];
}
+ (id) fromDictionaryToObject:(NSDictionary *)dic withClass:(Class)clazz
{
    return [RMMapper objectWithClass:clazz fromDictionary:dic];
}

+ (NSString *) generateUUID
{
    NSString *uuid = [[NSUUID UUID] UUIDString];
    return uuid;
}

+ (NSTimeInterval) getTimeStampWithMillisecond
{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970] * 1000;
    return a;
}

+ (long) getTimeStampWithMillisecond_l
{
    return [[NSNumber numberWithDouble:[YTToolKits getTimeStampWithMillisecond]] longValue];
}

@end
