//
//  YTCharsetHelper.m
//  YTIMDemo
//
//  Created by yanl on 2018/2/2.
//  Copyright © 2018年 yanl. All rights reserved.
//

#import "YTCharsetHelper.h"

@implementation YTCharsetHelper

+ (NSString *) getString:(NSData *)data
{
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+ (NSData *) getJSONBytesWithDictionary:(NSDictionary *)keyValuesForJASON
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:keyValuesForJASON options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error != nil) {
        
        NSLog(@"【IMCORE】将对象转成JSON数据时出错了：%@", error);
    }
    
    return jsonData;
}

+ (NSData *) getBytesWithString:(NSString *)str
{
    return [str dataUsingEncoding:NSUTF8StringEncoding];
}

@end
