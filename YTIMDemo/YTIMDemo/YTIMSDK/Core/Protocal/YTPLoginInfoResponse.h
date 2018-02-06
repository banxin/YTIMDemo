//
//  YTPLoginInfoResponse.h
//  YTIMDemo
//
//  Created by yanl on 2018/2/2.
//  Copyright © 2018年 yanl. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 服务端反馈的用户登陆结果数据封装类
 */
@interface YTPLoginInfoResponse : NSObject

/*! 错误码：0表示认证成功，否则是用户自定的错误码（该码应该是>1024的整数） */
@property (nonatomic, assign) int code;

@end
