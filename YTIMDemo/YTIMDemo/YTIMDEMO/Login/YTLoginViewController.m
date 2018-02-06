//
//  YTLoginViewController.m
//  YTIMDemo
//
//  Created by yanl on 2018/2/5.
//  Copyright © 2018年 yanl. All rights reserved.
//

#import "YTLoginViewController.h"
#import "YTCompletionDefine.h"
#import "YTIMClientManager.h"
#import "YTChatBaseEventImpl.h"
#import "YTConfigEntity.h"
#import "YTErrorCode.h"
#import "YTLocalUDPDataSender.h"

@interface YTLoginViewController ()
{
    UITextField *_txtIP;
    UITextField *_txtPort;
    UITextField *_txtUsername;
    UITextField *_txtPassword;
    
    UILabel     *_lblColon;
    
    UIButton    *_btnLogin;
}

/* 收到服务端的登陆完成反馈时要通知的观察者（因登陆是异步实现，本观察者将由
 *  ChatBaseEvent 事件的处理者在收到服务端的登陆反馈后通知之）*/
@property (nonatomic, copy) YTObserverCompletion onLoginSucessObserver;// block代码块一定要用copy属性，否则报错！

@end

@implementation YTLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"登录";
    
    [self setupUI];
    
    [self bindHandle];
    
    [self initLogin];
}

// 设定主视图
- (void)setupUI
{
    UITextField *txtIP = [UITextField new];
    
    txtIP.placeholder = @"请输入域名或IP地址";
    txtIP.borderStyle = UITextBorderStyleRoundedRect;
    txtIP.font = Font(16.f);
    txtIP.textColor = HexColor(@"444444");
    txtIP.text = @"10.51.4.15";
    
    [self.view addSubview:txtIP];
    
    _txtIP = txtIP;
    
    _lblColon = [UILabel new];
    
    _lblColon.textColor = HexColor(@"444444");
    _lblColon.font = Font(16.f);
    _lblColon.textAlignment = NSTextAlignmentCenter;
    _lblColon.text = @":";
    
    [self.view addSubview:_lblColon];
    
    UITextField *txtPort = [UITextField new];
    
    txtPort.placeholder = @"请输入端口号";
    txtPort.borderStyle = UITextBorderStyleRoundedRect;
    txtPort.font = Font(16.f);
    txtPort.textColor = HexColor(@"444444");
    txtPort.text = @"7901";
    
    [self.view addSubview:txtPort];
    
    _txtPort = txtPort;
    
    UITextField *txtUsername = [UITextField new];
    
    txtUsername.placeholder = @"请输入用户名";
    txtUsername.borderStyle = UITextBorderStyleRoundedRect;
    txtUsername.font = Font(16.f);
    txtUsername.textColor = HexColor(@"444444");
    txtUsername.text = @"shanzhu";
    
    [self.view addSubview:txtUsername];
    
    _txtUsername = txtUsername;
    
    UITextField *txtPassword = [UITextField new];
    
    txtPassword.placeholder = @"请输入密码";
    txtPassword.borderStyle = UITextBorderStyleRoundedRect;
    txtPassword.font = Font(16.f);
    txtPassword.textColor = HexColor(@"444444");
    txtPassword.secureTextEntry = YES;
    txtPassword.text = @"123456";
    
    [self.view addSubview:txtPassword];
    
    _txtPassword = txtPassword;
    
    [_txtIP mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(@15);
        make.top.mas_equalTo(@40);
        make.height.mas_equalTo(@40);
        make.right.equalTo(_lblColon.mas_left);
    }];
    
    [_lblColon mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_txtIP.mas_right);
        make.right.equalTo(_txtPort.mas_left);
        make.top.height.equalTo(_txtIP);
        make.width.mas_equalTo(@15);
    }];
    
    [_txtPort mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_lblColon.mas_right);
        make.right.equalTo(@-15);
        make.top.height.equalTo(_txtIP);
        make.width.mas_equalTo(@100);
    }];
    
    [_txtUsername mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_txtIP.mas_bottom).offset(30);
        make.left.height.equalTo(_txtIP);
        make.right.equalTo(self.view.mas_centerX).offset(-10);
    }];
    
    [_txtPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_txtUsername);
        make.right.height.equalTo(_txtPort);
        make.left.equalTo(self.view.mas_centerX).offset(10);
    }];
    
    UIImageView *imgLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dashed_line"]];
    
    [self.view addSubview:imgLine];
    
    [imgLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_txtUsername.mas_bottom).offset(20);
        make.left.mas_equalTo(@15);
        make.right.mas_equalTo(@-15);
    }];
    
    _btnLogin = [UIButton new];
    
    _btnLogin.titleLabel.font = Font(20.f);
    [_btnLogin setBackgroundColor:HexColor(@"ed3a4a")];
    [_btnLogin setTitle:@"Login" forState:UIControlStateNormal];
    [_btnLogin setTitleColor:HexColor(@"ffffff") forState:UIControlStateNormal];
    
    _btnLogin.layer.masksToBounds = YES;
    _btnLogin.layer.cornerRadius = 5.f;
    
    [self.view addSubview:_btnLogin];
    
    [_btnLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(imgLine);
        make.top.equalTo(imgLine.mas_bottom).offset(15);
        make.height.mas_equalTo(@49);
    }];
}

/// 绑定操作
- (void)bindHandle
{
    /// 绑定login btn 是否可用
    RAC(_btnLogin, enabled) = [RACSignal combineLatest:@[_txtIP.rac_textSignal, _txtPort.rac_textSignal, _txtUsername.rac_textSignal, _txtPassword.rac_textSignal] reduce:^id _Nonnull (NSString *ip, NSString *port, NSString * username, NSString * password) {
        
        /// ip，端口，用户名，密码 均不为空时可用
        return @(ip.length && port.length && username.length && password.length);
    }];
    
    // 监听 _btnLogin 的enabled变化
    @weakify(self)
    [RACObserve(_btnLogin, enabled) subscribeNext:^(id x) {
        
        @strongify(self)
        NSNumber *newValue = x;
        
        if (newValue.integerValue == 1) {
            
            self -> _btnLogin.alpha = 1.f;
            
        } else {
            
            self -> _btnLogin.alpha = 0.6f;
        }
    }];
    
    /// 绑定事件操作
    [[_btnLogin rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self)
        [self doLogin];
    }];
}

#pragma mark - aciton

- (void)doLogin
{
    //** 设置服务器地址和端口号
    NSString *serverIP = [_txtIP.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *serverPort = _txtPort.text;
    
    if (!([serverIP length] <= 0) && !([serverPort length] <= 0)) {
        
        // 设置好服务端的连接地址
        [YTConfigEntity setServerIp:serverIP];
        // 设置好服务端的UDP监听端口号
        [YTConfigEntity setServerPort:[serverPort intValue]];
    }
    else
    {
        NSLog(@"请确保服务端地址和端口号都不为空！");
        //        [self showIMInfo_red: @"请确保服务端地址和端口号都不为空！"];
        return;
    }
    
    //** 登陆名和密码
    NSString *loginUserIdStr = _txtUsername.text;
    if ([loginUserIdStr length] == 0)
    {
        NSLog(@"请输入登陆名！");
        return;
    }
    NSString *loginTokenStr = _txtPassword.text;
    if ([loginTokenStr length] == 0)
    {
        NSLog(@"请输入登密码！");
        return;
    }
    
    //** 向服务端发送登陆信息
    [self doLoginImpl:loginUserIdStr withToken:loginTokenStr];
}

/*
 * 真正的登陆信息发送实现方法。
 */
- (void)doLoginImpl:(NSString *)loginUserIdStr withToken:(NSString *)loginTokenStr
{
    // * 立即显示登陆处理进度提示（并将同时启动超时检查线程）
    //    [self.onLoginProgress showProgressing:YES onParent:self.view];
    // * 设置好服务端反馈的登陆结果观察者（当客户端收到服务端反馈过来的登陆消息时将被通知）【2】
    [[[YTIMClientManager shareInstance] getBaseEventListener] setLoginOkForLaunchObserver:self.onLoginSucessObserver];
    
    // * 发送登陆数据包(提交登陆名和密码)
    int code = [[YTLocalUDPDataSender sharedInstance] sendLogin:loginUserIdStr withToken:loginTokenStr];
    
    if (code == COMMON_CODE_OK) {
        
        NSLog(@"登陆请求已发出。。。");
        
    } else {
        
        NSString *msg = [NSString stringWithFormat:@"登陆请求发送失败，错误码：%d", code];
        
        NSLog(msg);
        
        //        [self E_showToastInfo:@"错误" withContent:msg onParent:self.view];
        
        // * 登陆信息没有成功发出时当然无条件取消显示登陆进度条
        //        [self.onLoginProgress showProgressing:NO onParent:self.view];
    }
}

- (void)initLogin
{
    self.onLoginSucessObserver = ^(id observerble, id arg1) {
        
        // 服务端返回的登陆结果值
        int code = [(NSNumber *)arg1 intValue];
        
        // 登陆成功
        if (code == 0) {
            
            // TODO 提示：登陆MobileIMSDK服务器成功后的事情在此实现即可
            
            // 进入主界面
            //            [CurAppDelegate switchToMainViewController];
            
            NSLog(@"login suc, forward to IM View!");
            
            [self.navigationController pushViewController:[NSClassFromString(@"YTMainViewController") new] animated:YES];
            
            // 登陆失败
        } else {
            
            NSLog(@"login failed!");
        }
        
        //## try to bug FIX ! 20160810：此observer本身执行完成才设置为nil，解决之前过早被nil而导致有时怎么也无法跳过登陆界面的问题
        // * 取消设置好服务端反馈的登陆结果观察者（当客户端收到服务端反馈过来的登陆消息时将被通知）【1】
        [[[YTIMClientManager shareInstance] getBaseEventListener] setLoginOkForLaunchObserver:nil];
    };
}

@end
