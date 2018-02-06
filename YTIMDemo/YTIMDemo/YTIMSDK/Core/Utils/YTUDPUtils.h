//
//  YTUDPUtils.h
//  YTIMDemo
//
//  Created by yanl on 2018/2/2.
//  Copyright © 2018年 yanl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncUdpSocket.h"

/*
 一个本地UDP消息发送工具类。
 */
@interface YTUDPUtils : NSObject

/*!
 * 发送一条UDP消息。
 *
 * @param skt GCDAsyncUdpSocket对象引用
 * @param d 要发送的比特数组
 * @return true表示成功发出，否则表示发送失败
 * @see #send(DatagramSocket, DatagramPacket)
 */
+ (BOOL) send:(GCDAsyncUdpSocket *) skt withData:(NSData *)d;

@end
