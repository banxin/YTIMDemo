//
//  NSMutableDictionary+YTExt.h
//  YTIMDemo
//
//  Created by yanl on 2018/2/2.
//  Copyright © 2018年 yanl. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 一个增加了containsKey方法的NSMutableDictionary catlog实现
 */
@interface NSMutableDictionary (YTExt)

/*!
 *  是否包含指定key所对应的对象。
 *
 *  @param key 要进行判断的key值
 *  @return true表示是列表中忆包含此key，否则表示尚未包含
 */
- (BOOL) containsKey:(NSString *)key;

@end
