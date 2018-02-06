//
//  YTCharsetHelper.h
//  YTIMDemo
//
//  Created by yanl on 2018/2/2.
//  Copyright © 2018年 yanl. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 数据交互的编解码实现类
 */
@interface YTCharsetHelper : NSObject

/*!
 * 将byte数组按UTF-8编码组织成字符串并返回.
 *
 * @param data byte数组
 * @return 成功解码完成则返回字符串，否则返回nil
 */
+ (NSString *) getString:(NSData *)data;

/*!
 * 将key-values对象转换成JSON表示的byte数组（以便网络传输待场景下）.
 *
 * @param keyValuesForJASON key-values对象
 * @return 如果JSON转换成功则返回JSON表示的byte数组，否则返回nil
 */
+ (NSData *) getJSONBytesWithDictionary:(NSDictionary *)keyValuesForJASON;

/*!
 *  将字符串按UTF-8编码成byte数组。
 *
 *  @param str 字符串
 *
 *  @return 编码后的byte数组结果
 */
+ (NSData *) getBytesWithString:(NSString *)str;

@end
