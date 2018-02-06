//
//  YTClientCoreSDK.m
//  YTIMDemo
//
//  Created by yanl on 2018/2/5.
//  Copyright © 2018年 yanl. All rights reserved.
//

#import "YTClientCoreSDK.h"
#import "Reachability.h"
#import "YTLocalUDPSocketProvider.h"
#import "YTAutoReLoginDaemon.h"

static BOOL ENABLED_DEBUG = NO;
static BOOL autoReLogin = YES;

@interface YTClientCoreSDK ()

// 是否已初始化
@property (nonatomic) BOOL _init;
// 监控网络状态的第三方
@property (nonatomic) Reachability *internetReachability;

@end

@implementation YTClientCoreSDK

static YTClientCoreSDK *instance = nil;

+ (YTClientCoreSDK *)sharedInstance
{
    if (instance == nil)
    {
        instance = [[super allocWithZone:NULL] init];
    }
    return instance;
}

+ (BOOL) isENABLED_DEBUG
{
    return ENABLED_DEBUG;
}

+ (void) setENABLED_DEBUG:(BOOL)enabledDebug
{
    ENABLED_DEBUG = enabledDebug;
}

+ (BOOL) isAutoReLogin
{
    return autoReLogin;
}
+ (void) setAutoReLogin:(BOOL)arl
{
    autoReLogin = arl;
}

- (id)init
{
    if (![super init])
        return nil;
    
    return self;
}

- (void)initCore
{
    if (!self._init) {
        
        // 设置网络不可用
        self.localDeviceNetworkOk = NO;
        // 设置未成功连接到服务器
        self.connectedToServer = NO;
        // 当且仅当用户从登陆界面成功登陆后设置本字段为true，系统退出
        self.loginHasInit = NO;
        
        if (self.internetReachability == nil) {
            
            // 监控网络状态变化
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
            
            self.internetReachability = [Reachability reachabilityForInternetConnection];
        }
        
        [self.internetReachability startNotifier];
        self.localDeviceNetworkOk = [self internetReachable];
        self._init = YES;
        
        NSLog(@"ClientCoreSDK已经完成initCore了！");
    }
}

- (void) releaseCore
{
    [[YTAutoReLoginDaemon sharedInstance] stop];
//    [[QoS4ReciveDaemon sharedInstance] stop];
//    [[KeepAliveDaemon sharedInstance] stop];
    //    [[LocalUDPDataReciever sharedInstance] stop];
//    [[QoS4SendDaemon sharedInstance] stop];
    [[YTLocalUDPSocketProvider sharedInstance] closeLocalUDPSocket];
    
    //## Bug FIX: 20180103 by Jack Jiang START
//    [[QoS4SendDaemon sharedInstance] clear];
//    [[QoS4ReciveDaemon sharedInstance] clear];
    //## Bug FIX: 20180103 by Jack Jiang END
    
    [self.internetReachability stopNotifier];
    
    self._init = NO;
    self.loginHasInit = NO;
    self.connectedToServer = NO;
}

- (BOOL) isInitialed
{
    return self._init;
}

/**
 获取网络是否可用
 
 @return 网络是否可用
 */
- (BOOL)internetReachable
{
    NetworkStatus netStatus = [self.internetReachability currentReachabilityStatus];
    return netStatus == ReachableViaWWAN || netStatus == ReachableViaWiFi;
}

- (void)reachabilityChanged:(NSNotification *)note
{
    Reachability* reachability = [note object];
    NSParameterAssert([reachability isKindOfClass:[Reachability class]]);
    
    NetworkStatus netStatus = [reachability currentReachabilityStatus];
    BOOL connectionRequired = [reachability connectionRequired];
    NSString* statusString = @"";
    
    switch (netStatus)
    {
        case NotReachable:
        {
            statusString = NSLocalizedString(@"【IMCORE】【本地网络通知】检测本地网络连接断开了!", @"Text field text for access is not available");
            connectionRequired = NO;
            
            self.localDeviceNetworkOk = false;
            [[YTLocalUDPSocketProvider sharedInstance] closeLocalUDPSocket];
            
            break;
        }
            
        case ReachableViaWWAN: // 蜂窝网络、3G网络等
        case ReachableViaWiFi: // WIFI
        {
            int wifi = (netStatus == ReachableViaWiFi);
            statusString= [NSString stringWithFormat:NSLocalizedString(@"【IMCORE】【本地网络通知】检测本地网络已连接上了! WIFI? %d", @""), wifi?@"YES":@"NO"];
            
            self.localDeviceNetworkOk = true;
            [[YTLocalUDPSocketProvider sharedInstance] closeLocalUDPSocket];
            
            break;
        }
    }
    
    if (connectionRequired)
    {
        NSString *connectionRequiredFormatString = NSLocalizedString(@"【IMCORE】%@, Connection Required", @"Concatenation of status string with connection requirement");
        statusString = [NSString stringWithFormat:connectionRequiredFormatString, statusString];
    }
    
    if(ENABLED_DEBUG)
        NSLog(@"%@", statusString);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kReachabilityChangedNotification object:nil];
}

@end
