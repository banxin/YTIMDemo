//
//  YTConfigEntity.m
//  YTIMDemo
//
//  Created by yanl on 2018/2/2.
//  Copyright © 2018年 yanl. All rights reserved.
//

#import "YTConfigEntity.h"

static NSString *serverIp = @"openmob.net";
static int serverPort = 7901;
static int localUdpSendAndListeningPort = 7801;
static NSString *appKey = nil;

@implementation YTConfigEntity

+ (void)registerWithAppKey:(NSString *)key
{
    appKey = key;
}

+ (void) setServerIp:(NSString*)sIp
{
    serverIp = sIp;
}

+ (NSString *)getServerIp
{
    return serverIp;
}

+ (void) setServerPort:(int)sPort
{
    serverPort = sPort;
}

+ (int) getServerPort
{
    return serverPort;
}

+ (void) setLocalUdpSendAndListeningPort:(int)lPort
{
    localUdpSendAndListeningPort = lPort;
}

+ (int) getLocalUdpSendAndListeningPort
{
    return localUdpSendAndListeningPort;
}

//+ (void) setSenseMode:(YTSenseMode)mode
//{
//    int keepAliveInterval = 0;
//    int networkConnectionTimeout = 0;
//    
//    switch(mode)
//    {
//        case YTSenseMode3S:
//            keepAliveInterval = 3000;// 3s
//            networkConnectionTimeout = 3000 * 3 + 1000;// 10s
//            break;
//        case YTSenseMode10S:
//            keepAliveInterval = 10000;// 10s
//            networkConnectionTimeout = 10000 * 2 + 1000;// 21s
//            break;
//        case YTSenseMode30S:
//            keepAliveInterval = 30000;// 30s
//            networkConnectionTimeout = 30000 * 2 + 1000;// 61s
//            break;
//        case YTSenseMode60S:
//            keepAliveInterval = 60000;// 60s
//            networkConnectionTimeout = 60000 * 2 + 1000;// 121s
//            break;
//        case YTSenseMode120S:
//            keepAliveInterval = 120000;// 120s
//            networkConnectionTimeout = 120000 * 2 + 1000;// 241s
//            break;
//    }
//    
//    if(keepAliveInterval > 0)
//    {
//        [KeepAliveDaemon setKEEP_ALIVE_INTERVAL:keepAliveInterval];
//    }
//    
//    if(networkConnectionTimeout > 0)
//    {
//        [KeepAliveDaemon setNETWORK_CONNECTION_TIME_OUT:networkConnectionTimeout];
//    }
//}

@end
