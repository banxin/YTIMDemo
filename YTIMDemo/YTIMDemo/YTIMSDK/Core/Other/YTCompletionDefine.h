//
//  YTCompletionDefine.h
//  YTIMDemo
//
//  Created by yanl on 2018/2/2.
//  Copyright © 2018年 yanl. All rights reserved.
//

#ifndef YTCompletionDefine_h
#define YTCompletionDefine_h

/*
 本接口中定义了一些用于回调的block类型
 */

/*!
 *  @Author Jack Jiang, 14-10-29 19:10:17
 *
 *  通用回调，应用场景是模拟Java中的Obsrver观察者模式。
 *
 *  @param observerble 此参数通常为nil，字段意义可自行定义
 *  @param arg1        通常为回调时的数据（字段意义可自行定义），可为nil
 */
typedef void (^YTObserverCompletion)(id observerble ,id arg1);

/*!
 *  @Author Jack Jiang, 14-10-29 19:10:41
 *
 *  UDP Socket连接结果回调。
 *
 *  @param connectRsult YES表示连接成功，NO否则表示连接失败
 */
typedef void (^ConnectionCompletion)(BOOL connectRsult);

#endif /* YTCompletionDefine_h */
