//
//  YTMainViewController.m
//  YTIMDemo
//
//  Created by yanl on 2018/2/2.
//  Copyright © 2018年 yanl. All rights reserved.
//

#import "YTMainViewController.h"
#import "YTClientCoreSDK.h"
#import "YTIMClientManager.h"
#import "YTLocalUDPDataSender.h"
#import "YTErrorCode.h"
#import "YTChatModel.h"
#import "YTChatCell.h"
#import "YTChatTransDataEventImpl.h"

static const NSInteger TABLE_CELL_COLOR_BLACK      = 0;
static const NSInteger TABLE_CELL_COLOR_BLUE       = 1;
static const NSInteger TABLE_CELL_COLOR_BRIGHT_RED = 2;
static const NSInteger TABLE_CELL_COLOR_RED        = 3;
static const NSInteger TABLE_CELL_COLOR_GREEN      = 4;

@interface YTMainViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UILabel     *_lblIMState;
    UILabel     *_lblCurrenAccount;
    UIButton    *_btnLogout;
    
    UITextField *_txtSendUserId;
    UITextField *_txtMessage;
    UIButton    *_btnSend;
    
    UITableView *_tableView;
    
    NSDateFormatter *hhmmssFormat;
}

// 用于主界面表格的数据显示
@property (nonatomic, strong) NSMutableArray* chatInfoList;

@property (nonatomic, copy) YTObserverCompletion receivedObserver;

@end

@implementation YTMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // chat info time
    hhmmssFormat = [[NSDateFormatter alloc] init];
    [hhmmssFormat setDateFormat:@"HH:mm:ss"];
    
    self.view.backgroundColor = HexColor(@"f7f7f7");
    
    self.title = @"IM";
    
    [self setupUI];
    
    [self bindHandle];
    
    [self initChat];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationItem setHidesBackButton:YES];
    self.navigationItem.leftBarButtonItem = nil;
    
    [self refreshConnecteStatus];
    
    // 将当前账号显示出来
    _lblCurrenAccount.text = [YTClientCoreSDK sharedInstance].currentLoginUserId;
}

- (void)setupUI
{
    UILabel *lblStateTitle = [UILabel new];
    
    lblStateTitle.textColor = HexColor(@"444444");
    lblStateTitle.font = Font(14.f);
    lblStateTitle.textAlignment = NSTextAlignmentCenter;
    lblStateTitle.text = @"通信状态:";
    
    [self.view addSubview:lblStateTitle];
    
    [lblStateTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(@15);
        make.top.mas_equalTo(@(15));
    }];
    
    UILabel *lblState = [UILabel new];

    lblState.textColor = [UIColor greenColor];
    lblState.font = Font(14.f);
    lblState.textAlignment = NSTextAlignmentCenter;
    lblState.text = @"通信正常";
    
    [self.view addSubview:lblState];
    
    _lblIMState = lblState;
    
    [lblState mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(lblStateTitle.mas_right).offset(2);
        make.top.equalTo(lblStateTitle);
    }];
    
    UILabel *lblAccountTitle = [UILabel new];
    
    lblAccountTitle.textColor = HexColor(@"444444");
    lblAccountTitle.font = Font(14.f);
    lblAccountTitle.textAlignment = NSTextAlignmentCenter;
    lblAccountTitle.text = @"当前账号:";
    
    [self.view addSubview:lblAccountTitle];
    
    [lblAccountTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.width.height.equalTo(lblStateTitle);
        make.top.equalTo(lblStateTitle.mas_bottom).offset(5);
    }];
    
    UILabel *lblAccount = [UILabel new];
    
    lblAccount.textColor = [UIColor blueColor];
    lblAccount.font = Font(14.f);
    lblAccount.textAlignment = NSTextAlignmentCenter;
    lblAccount.text = @"xxxxx";
    
    [self.view addSubview:lblAccount];
    
    _lblCurrenAccount = lblAccount;
    
    [lblAccount mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(lblAccountTitle.mas_right).offset(2);
        make.top.equalTo(lblAccountTitle);
    }];
    
    _btnLogout = [UIButton new];
    
    _btnLogout.titleLabel.font = Font(16.f);
    [_btnLogout setBackgroundColor:[UIColor orangeColor]];
    [_btnLogout setTitle:@"退出登录" forState:UIControlStateNormal];
    [_btnLogout setTitleColor:HexColor(@"ffffff") forState:UIControlStateNormal];
    
    _btnLogout.layer.masksToBounds = YES;
    _btnLogout.layer.cornerRadius = 2.f;
    
    [self.view addSubview:_btnLogout];
    
    [_btnLogout mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo(@-15);
        make.bottom.equalTo(lblAccount);
        make.width.mas_equalTo(@100);
        make.height.mas_equalTo(@25);
    }];
    
    UIImageView *imgLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dashed_line"]];
    
    [self.view addSubview:imgLine];
    
    [imgLine mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(@60);
        make.left.right.equalTo(self.view);
    }];
    
    UITextField *txtUser = [UITextField new];
    
    txtUser.placeholder = @"请输入接收方ID";
    txtUser.borderStyle = UITextBorderStyleRoundedRect;
    txtUser.font = Font(14.f);
    txtUser.textColor = HexColor(@"444444");
    
    [self.view addSubview:txtUser];
    
    _txtSendUserId = txtUser;
    
    UITextField *txtMsg = [UITextField new];
    
    txtMsg.placeholder = @"请输入发送内容";
    txtMsg.borderStyle = UITextBorderStyleRoundedRect;
    txtMsg.font = Font(14.f);
    txtMsg.textColor = HexColor(@"444444");
    
    [self.view addSubview:txtMsg];
    
    _txtMessage = txtMsg;
    
    [_txtSendUserId mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(@15);
        make.top.equalTo(imgLine.mas_bottom).offset(10);
        make.height.mas_equalTo(@25);
        make.right.equalTo(_txtMessage.mas_left).offset(-10);
        make.width.mas_equalTo(@120);
    }];
    
    [_txtMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_txtSendUserId.mas_right).offset(10);
        make.right.equalTo(@-15);
        make.top.height.equalTo(_txtSendUserId);
    }];
    
    _btnSend = [UIButton new];
    
    _btnSend.titleLabel.font = Font(16.f);
    [_btnSend setBackgroundColor:HexColor(@"ed3a4a")];
    [_btnSend setTitle:@"发 送" forState:UIControlStateNormal];
    [_btnSend setTitleColor:HexColor(@"ffffff") forState:UIControlStateNormal];
    
    _btnSend.layer.masksToBounds = YES;
    _btnSend.layer.cornerRadius = 3.f;
    
    [self.view addSubview:_btnSend];
    
    [_btnSend mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(@15);
        make.right.mas_equalTo(@-15);
        make.top.equalTo(_txtMessage.mas_bottom).offset(10);
        make.height.mas_equalTo(@30);
    }];
    
    _tableView = [UITableView new];
    
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.tableFooterView = [UIView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellEditingStyleNone;
    
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(_btnSend);
        make.top.equalTo(_btnSend.mas_bottom).offset(10);
        make.bottom.equalTo(self.view);
    }];
}

/// 绑定操作
- (void)bindHandle
{
    /// 绑定login btn 是否可用
    RAC(_btnSend, enabled) = [RACSignal combineLatest:@[_txtSendUserId.rac_textSignal, _txtMessage.rac_textSignal] reduce:^id _Nonnull (NSString *userId, NSString *message) {
        
        /// 对方ID，发送内容 均不为空时可用
        return @(userId.length && message.length);
    }];
    
    // 监听 _btnLogin 的enabled变化
    @weakify(self)
    [RACObserve(_btnSend, enabled) subscribeNext:^(id x) {
        
        @strongify(self)
        NSNumber *newValue = x;
        
        if (newValue.integerValue == 1) {
            
            self -> _btnSend.alpha = 1.f;
            
        } else {
            
            self -> _btnSend.alpha = 0.6f;
        }
    }];
    
    /// 绑定事件操作
    [[_btnSend rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self)
        [self doSendMessage];
    }];
    
    /// 绑定事件操作
    [[_btnLogout rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self)
        [self doLogout];
    }];
}

- (void)initChat
{
    @weakify(self)
    self.receivedObserver = ^(id observerble, id arg1) {
        
        NSString *received = (NSString *)arg1;
        
        @strongify(self)
        [self showIMInfo_black:received];
    };
    
    [[[YTIMClientManager shareInstance] getTransDataListener] setReceivedBlock:self.receivedObserver];
}

- (void)refreshConnecteStatus
{
    BOOL connectedToServer = [YTClientCoreSDK sharedInstance].connectedToServer;
    _lblIMState.text = (connectedToServer ? @"通信正常" : @"连接断开");
}

// 退出登录
- (void)doLogout
{
    // 发出退出登陆请求包
    int code = [[YTLocalUDPDataSender sharedInstance] sendLoginout];
    if(code == COMMON_CODE_OK)
    {
        NSLog(@"注销登陆请求已完成。。。");
        [self refreshConnecteStatus];
    }
    else
    {
        NSString *msg = [NSString stringWithFormat:@"注销登陆请求发送失败，错误码：%d", code];
        
        NSLog(@"%@", msg);
    }
    
    //## BUG FIX: 20170713 START by JackJiang
    // 退出登陆时记得一定要调用此行，不然不退出APP的情况下再登陆时会报 code=203错误哦！
    [[YTIMClientManager shareInstance] resetInitFlag];
    //## BUG FIX: 20170713 END by JackJiang
    
    [self.navigationController popViewControllerAnimated:YES];
}

// 发送消息
- (void)doSendMessage
{
    NSString *friendIdStr = _txtSendUserId.text;
    if ([friendIdStr length] == 0)
    {
        NSLog(@"请输入对方id！");
        return;
    }
    
    NSString *dicStr = _txtMessage.text;
    if ([dicStr length] == 0)
    {
        NSLog(@"请输入消息内容！");
        return;
    }
    
    // 显示信息到本地
    [self showIMInfo_black:[NSString stringWithFormat:@"我对%@说：%@", friendIdStr, dicStr]];
    
    // 发送消息
    int code = [[YTLocalUDPDataSender sharedInstance] sendCommonDataWithStr:dicStr toUserId:friendIdStr qos:YES fp:nil withTypeu:-1];
    
    if (code == COMMON_CODE_OK) {
        
        NSLog(@"您的消息已成功发出。。。");
        
    } else {
        
        NSString *msg = [NSString stringWithFormat:@"您的消息发送失败，错误码：%d", code];
        
        NSLog(@"%@", msg);
    }
}

- (void) showIMInfo_black:(NSString*)txt
{
    [self showIMInfo:txt withColorType:TABLE_CELL_COLOR_BLACK];
}

- (void) showIMInfo_blue:(NSString*)txt
{
    [self showIMInfo:txt withColorType:TABLE_CELL_COLOR_BLUE];
}

- (void) showIMInfo_brightred:(NSString*)txt
{
    [self showIMInfo:txt withColorType:TABLE_CELL_COLOR_BRIGHT_RED];
}

- (void) showIMInfo_red:(NSString*)txt
{
    [self showIMInfo:txt withColorType:TABLE_CELL_COLOR_RED];
}

- (void) showIMInfo_green:(NSString*)txt
{
    [self showIMInfo:txt withColorType:TABLE_CELL_COLOR_GREEN];
}

- (void) showIMInfo:(NSString*)txt withColorType:(int)colorType
{
    YTChatModel *dto = [[YTChatModel alloc] init];
    dto.colorType = colorType;
    dto.content = [NSString stringWithFormat:@"[%@] %@", [hhmmssFormat stringFromDate:[[NSDate alloc] init]], txt];
    [self.chatInfoList addObject:dto];
    [_tableView reloadData];
    
    // 自动显示最后一行
    NSInteger s = [_tableView numberOfSections];
    if (s<1) return;
    NSInteger r = [_tableView numberOfRowsInSection:s-1];
    if (r<1) return;
    NSIndexPath *ip = [NSIndexPath indexPathForRow:r-1 inSection:s-1];
    [_tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - Table view delegate

// 根据显示内容计算行高
- (CGSize)_calculateCellSize:(NSIndexPath *)indexPath
{
    // 列寬
    CGFloat contentWidth = _tableView.frame.size.width;
    if(self.chatInfoList == nil)
        return CGSizeMake(contentWidth, 16);
    YTChatModel * item = [self.chatInfoList objectAtIndex:indexPath.section];
    
    // 用何種字體進行顯示
    //### Bug FIX: 此字号设为12时，在iPhone5C(iOS7.0(11A466))真机上会出现字体显示不全的bug（下偏），
    //              但其它真机包括模拟器上却不会，难道是iOS7.0的bug？-- By Jack Jiang 2015-09-16
    UIFont *font = [UIFont systemFontOfSize:14];
    // 該行要顯示的內容
    NSString *content = item.content;
    // 計算出顯示完內容需要的最小尺寸
    CGSize size = [content sizeWithFont:font constrainedToSize:CGSizeMake(contentWidth, 1000) lineBreakMode:NSLineBreakByCharWrapping];
    
    // NSLog(@"-------计算出的高度=%f", size.height);
    
    return size;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.chatInfoList == nil ? 0 : [self.chatInfoList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self _calculateCellSize:indexPath].height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.chatInfoList == nil)
        return nil;
    
    YTChatModel * item = [self.chatInfoList objectAtIndex:indexPath.section];
    
    // 表格单元可重用ui
    static NSString *idenfity = @"Cell";
    
    YTChatCell * cell = [tableView dequeueReusableCellWithIdentifier:idenfity];
    
    if(cell == nil) {
        
        cell = [[YTChatCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idenfity];
    }

    // 利表格单元对应的数据对象对ui进行设置
    cell.lblContent.text = item.content;
    NSInteger colorType = item.colorType;
    UIColor *cellColor = nil;
    switch(colorType)
    {
        case TABLE_CELL_COLOR_BLUE:
            cellColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:255/255.0f alpha:1];
            break;
        case TABLE_CELL_COLOR_BRIGHT_RED:
            cellColor = [UIColor colorWithRed:255/255.0f green:0/255.0f blue:255/255.0f alpha:1];
            break;
        case TABLE_CELL_COLOR_RED:
            cellColor = [UIColor colorWithRed:255/255.0f green:0/255.0f blue:0/255.0f alpha:1];
            break;
        case TABLE_CELL_COLOR_GREEN:
            cellColor = [UIColor colorWithRed:0/255.0f green:128/255.0f blue:0/255.0f alpha:1];
            break;
        case TABLE_CELL_COLOR_BLACK:
        default:
            cellColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1];
            break;
    }
    if(cellColor != nil)
        cell.lblContent.textColor = cellColor;
    
    // ** 设置cell的lable高度
    CGRect rect = [cell.textLabel textRectForBounds:cell.textLabel.frame limitedToNumberOfLines:0];
    // 設置顯示榘形大小
    rect.size = [self _calculateCellSize:indexPath];
    // 重置列文本區域
    cell.lblContent.frame = rect;
    
    return cell;
}

- (NSMutableArray *)chatInfoList
{
    if (!_chatInfoList) {
        
        _chatInfoList = [NSMutableArray arrayWithCapacity:0];
    }
    
    return _chatInfoList;
}

@end


















