//
//  YTAutoReLoginDaemon.m
//  YTIMDemo
//
//  Created by yanl on 2018/2/5.
//  Copyright © 2018年 yanl. All rights reserved.
//

#import "YTAutoReLoginDaemon.h"
#import "YTClientCoreSDK.h"
#import "YTLocalUDPDataReciever.h"
#import "YTLocalUDPDataSender.h"
#import "YTCompletionDefine.h"

static int AUTO_RE_LOGIN_INTERVAL = 2000;

@interface YTAutoReLoginDaemon ()

@property (nonatomic, assign) BOOL autoReLoginRunning;
@property (nonatomic, assign) BOOL _excuting;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, copy) YTObserverCompletion debugObserver_;// block代码块一定要用copy属性，否则报错！

@end

@implementation YTAutoReLoginDaemon

static YTAutoReLoginDaemon *instance = nil;

+ (YTAutoReLoginDaemon *)sharedInstance
{
    if (instance == nil)
    {
        instance = [[super allocWithZone:NULL] init];
    }
    return instance;
}

+ (void) setAUTO_RE_LOGIN_INTERVAL:(int)autoReLoginInterval
{
    AUTO_RE_LOGIN_INTERVAL = autoReLoginInterval;
}
+ (int) getAUTO_RE_LOGIN_INTERVAL
{
    return AUTO_RE_LOGIN_INTERVAL;
}


- (id)init
{
    if (![super init])
        return nil;
    
    NSLog(@"AutoReLoginDaemon已经init了！");
    
    self.autoReLoginRunning = NO;
    self._excuting = NO;
    
    return self;
}

- (void) run
{
    if(!self._excuting)
    {
        self._excuting = YES;
        if([YTClientCoreSDK isENABLED_DEBUG])
            NSLog(@"【IMCORE】自动重新登陆线程执行中, autoReLogin? %d...", [YTClientCoreSDK isAutoReLogin]);
        int code = -1;
        
        if([YTClientCoreSDK isAutoReLogin])
        {
            NSString *curLoginUserId = [YTClientCoreSDK sharedInstance].currentLoginUserId;
            NSString *curLoginToken = [YTClientCoreSDK sharedInstance].currentLoginToken;
            NSString *curLoginExtra = [YTClientCoreSDK sharedInstance].currentLoginExtra;
            code = [[YTLocalUDPDataSender sharedInstance] sendLogin:curLoginUserId withToken:curLoginToken andExtra:curLoginExtra];
            
            // form DEBUG
            if(self.debugObserver_ != nil)
                self.debugObserver_(nil, [NSNumber numberWithInt:2]);
        }
        
        if(code == 0)
        {
            if([YTClientCoreSDK isENABLED_DEBUG])
                NSLog(@"【IMCORE】自动重新登陆数据包已发出(iOS上无需自已启动UDP接收线程, GCDAsyncUDPTask自行解决了).");
        }
        
        //
        self._excuting = NO;
    }
}


- (void) stop
{
    if(self.timer != nil)
    {
        if([self.timer isValid])
            [self.timer invalidate];
        
        self.timer = nil;
    }
    self.autoReLoginRunning = NO;
    
    // form DEBUG
    if(self.debugObserver_ != nil)
        self.debugObserver_(nil, [NSNumber numberWithInt:0]);
}

- (void) start:(BOOL)immediately
{
    [self stop];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:AUTO_RE_LOGIN_INTERVAL / 1000
                                                  target:self
                                                selector:@selector(run)
                                                userInfo:nil
                                                 repeats:YES];
    if(immediately)
        [self.timer fire];
    self.autoReLoginRunning = YES;
    
    // form DEBUG
    if(self.debugObserver_ != nil)
        self.debugObserver_(nil, [NSNumber numberWithInt:1]);
}

- (BOOL) isAutoReLoginRunning
{
    return self.autoReLoginRunning;
}

- (void) setDebugObserver:(YTObserverCompletion)debugObserver
{
    self.debugObserver_ = debugObserver;
}

@end














