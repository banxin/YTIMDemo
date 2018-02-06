//
//  YTPErrorResponse.h
//  YTIMDemo
//
//  Created by yanl on 2018/2/2.
//  Copyright © 2018年 yanl. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 错误信息DTO类
 */
@interface YTPErrorResponse : NSObject

@property (nonatomic, assign) int errorCode;
@property (nonatomic, retain) NSString* errorMsg;

@end
