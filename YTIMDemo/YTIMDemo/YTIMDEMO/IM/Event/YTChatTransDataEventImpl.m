//
//  YTChatTransDataEventImpl.m
//  YTIMDemo
//
//  Created by yanl on 2018/2/5.
//  Copyright © 2018年 yanl. All rights reserved.
//

#import "YTChatTransDataEventImpl.h"
#import "YTErrorCode.h"
#import "AppMacro.h"

/**
 * 与IM服务器的数据交互事件在此ChatTransDataEvent子类中实现即可。
 *
 * @author Jack Jiang, 20170501
 * @version.1.1
 */
@implementation YTChatTransDataEventImpl

- (void) onTransBuffer:(NSString *)fingerPrintOfProtocal withUserId:(NSString *)dwUserid andContent:(NSString *)dataContent andTypeu:(int)typeu
{
    NSLog(@"【DEBUG_UI】[%d]收到来自用户%@的消息:%@", typeu, dwUserid, dataContent);
    
//    // UI显示
//    // Make toast with an image & title
//    [[CurAppDelegate getMainView] makeToast:dataContent
//                                   duration:3.0
//                                   position:@"center"
//                                      title:[NSString stringWithFormat:@"%@说：", dwUserid]
//                                      image:[UIImage imageNamed:@"qzone_mark_img_myvoice.png"]];
//    [[CurAppDelegate getMainViewController] showIMInfo_black:[NSString stringWithFormat:@"%@说：%@", dwUserid, dataContent]];
    
    BLOCK_EXEC(self.receivedBlock, nil, [NSString stringWithFormat:@"%@说：%@", dwUserid, dataContent]);
}

- (void) onErrorResponse:(int)errorCode withErrorMsg:(NSString *)errorMsg
{
    NSLog(@"【DEBUG_UI】收到服务端错误消息，errorCode=%d, errorMsg=%@", errorCode, errorMsg);
    
    // UI显示
//    if(errorCode == ForS_RESPONSE_FOR_UNLOGIN)
//    {
//        NSString *content = [NSString stringWithFormat:@"服务端会话已失效，自动登陆/重连将启动! (%d)", errorCode];
//        [[CurAppDelegate getMainViewController] showIMInfo_brightred:content];
//    }
//    else
//    {
//        NSString *content = [NSString stringWithFormat:@"Server反馈错误码：%d,errorMsg=%@", errorCode, errorMsg];
//        [[CurAppDelegate getMainViewController] showIMInfo_red:content];
//    }
}

@end
