//
//  YTToolKits.h
//  YTIMDemo
//
//  Created by yanl on 2018/2/2.
//  Copyright © 2018年 yanl. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 实用工具类
 */
@interface YTToolKits : NSObject

#pragma mark - JSON转换相关方法

/*!
 * 将本对象转换成JSON字符串.
 *
 * @return
 * @see toBytes:
 */
+ (NSString *) toJSONString:(NSData *)datas;

/*!
 * 将对象转换成JSON表示的byte数组（以便网络传输）.
 *
 * @return
 * @see toMutableDictionary:
 * @see toGsonString:
 */
+ (NSData *) toJSONBytesWithDictionary:(NSDictionary *)dic;

/*!
 * 将指定对象序列化成NSMutableDictionary。
 *
 * @param obj
 * @return 成功则返回，否则返回nil
 */
+ (NSMutableDictionary *) toMutableDictionary:(id)obj;

/*!
 * 将JSON格式的byte数组转成NSDictionary.
 * 本方法是 toJSONBytesWithDictionary:的逆方法.
 *
 * @param jsonBytes SON格式的byte数组
 * @return 转换成功则返回，否则返回nil
 * @see toJSONBytesWithDictionary:
 */
+ (NSDictionary *) fromJSONBytesToDictionary:(NSData *)jsonBytes;

/*!
 * 将Dictionary描述的Key-values数据反序列化成对象.
 *
 * @param dic key-values
 * @param clazz 要反射的类
 * @return 成功则返回反序列完成的对象，否则返回nil
 */
+ (id) fromDictionaryToObject:(NSDictionary *)dic withClass:(Class)clazz;

#pragma mark - 其它实用方法

/*!
 * 生成 UUID（或者叫GUID）.
 */
+ (NSString *) generateUUID;

/*!
 *  返回系统时间戳（单位：毫秒），浮点表示。
 *
 *  @return 形如：1414074342829.249023
 */
+ (NSTimeInterval) getTimeStampWithMillisecond;

/*!
 *  返回系统时间戳（单位：毫秒），long表示。
 *
 *  @return 形如：1414074342829
 */
+ (long) getTimeStampWithMillisecond_l;

@end
