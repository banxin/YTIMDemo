//
//  YTUDPUtils.m
//  YTIMDemo
//
//  Created by yanl on 2018/2/2.
//  Copyright © 2018年 yanl. All rights reserved.
//

#import "YTUDPUtils.h"

@implementation YTUDPUtils

// 发送一条数据
+ (BOOL) send:(GCDAsyncUdpSocket *) skt withData:(NSData *)d
{
    BOOL sendSucess = YES;
    
    // Socket 存在 且 发送数据存在的情况下
    if (skt != nil && d != nil) {
        
        if ([skt isConnected]) {
            
            /*
             参数的意思：
             
             data:
             如果数据是零或零长度的，这个方法什么也不做。
             如果传递NSMutableData，请阅读下面的线程安全通知。
             
             timeout:
             发送操作的超时。
             如果超时值为负，发送操作不会使用超时。
             
             tag:
             标签是为了您的方便。
             它不会以任何方式通过套接字发送或接收。
             它在udpSocket：didSendDataWithTag中被报告为一个参数：
             或者udpSocket：didNotSendDataWithTag：dueToError：方法。
             你可以使用它作为一个数组索引，状态ID，类型常量等
             */
            [skt sendData:d withTimeout:-1 tag:0];
        }
        
    } else {
        
        NSLog(@"【IMCORE】在send()UDP数据报时没有成功执行，原因是：skt==null || d == null!");
    }
    
    return sendSucess;
}

@end
