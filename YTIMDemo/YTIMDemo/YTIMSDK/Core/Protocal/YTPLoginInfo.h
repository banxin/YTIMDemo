//
//  YTPLoginInfo.h
//  YTIMDemo
//
//  Created by yanl on 2018/2/2.
//  Copyright © 2018年 yanl. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 登陆信息DTO类
 */
@interface YTPLoginInfo : NSObject

/*! 登陆时提交的准一id，保证唯一就可以通信，可能是登陆用户名、也可能是任意不重复的id等，具体意义由业务层决定 */
@property (nonatomic, retain) NSString* loginUserId;

/*! 登陆时提交到服务端用于身份鉴别和合法性检查的token，它可能是登陆密码，也可能是通过前置单点登陆接口拿到的token等，具体意义由业务层决定 */
@property (nonatomic, retain) NSString* loginToken;

/*!
 * 额外信息字符串。本字段目前为保留字段，供上层应用自行放置需要的内容。
 * @since 2.1.6
 */
@property (nonatomic, retain) NSString* extra;

@end
