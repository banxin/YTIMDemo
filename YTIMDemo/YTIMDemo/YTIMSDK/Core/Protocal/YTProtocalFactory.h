//
//  YTProtocalFactory.h
//  YTIMDemo
//
//  Created by yanl on 2018/2/5.
//  Copyright © 2018年 yanl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTProtocal.h"
#import "YTPLoginInfoResponse.h"
#import "YTPErrorResponse.h"

@interface YTProtocalFactory : NSObject

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 协议解析相关方法
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*!
 * 将JSON转换而来的byte数组反序列化成Protocal类的对象.
 * <p>
 * <b>本方法主要由MobileIMSDK框架内部使用。</b>
 *
 * @param fullProtocalJASOnBytes JSON转换而来的byte数组
 * @return 如果返回列化成功则返回对象，否则返回nil
 */
+ (id) parse:(NSData *)fullProtocalJASOnBytes;

/*!
 * 将JSON转换而来的byte数组反序列化成指定类的对象.
 * <p>
 * <b>本方法主要由MobileIMSDK框架内部使用。</b>
 *
 * @param fullProtocalJASOnBytes JSON转换而来的byte数组
 * @param clazz 类
 * @return 如果返回列化成功则返回对象，否则返回nil
 */
+ (id) parse:(NSData *)fullProtocalJASOnBytes withClass:(Class)clazz;

/*!
 * 将指定的JSON字符串反序列化成指定类的对象.
 * <p>
 * <b>本方法主要由MobileIMSDK框架内部使用。</b>
 *
 * @param dataContentJSONOfProtocal json字符串
 * @param clazz 类
 * @return 如果返回列化成功则返回对象，否则返回nil
 *
 */
+ (id) parseObject:(NSString *)dataContentJSONOfProtocal withClass:(Class)clazz;

/*!
 * 接收用户登陆响应消息对象（该对象由客户端接收）.
 * <p>
 * <b>本方法主要由MobileIMSDK框架内部使用。</b>
 *
 * @param dataContentOfProtocal 内容
 * @return 登陆响应消息对象
 */
+ (YTPLoginInfoResponse *) parseYTPLoginInfoResponse:(NSString *)dataContentOfProtocal;

/*!
 * 解析错误响应消息对象（该对象由客户端接收）.
 * <p>
 * <b>本方法主要由MobileIMSDK框架内部使用。</b>
 *
 * @param dataContentOfProtocal 内容
 * @return 误响应消息对象
 */
+ (YTPErrorResponse *) parseYTPErrorResponse:(NSString *) dataContentOfProtocal;


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 协议组装相关方法
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*!
 * 创建用户注消登陆消息对象（该对象由客户端发出）.
 * <p>
 * <b>本方法主要由MobileIMSDK框架内部使用。</b>
 *
 * @param user_id 用户ID
 * @return 注消登陆消息对象
 */
+ (YTProtocal *) createPLoginoutInfo:(NSString *) user_id;

/*!
 * 创建用户登陆消息对象（该对象由客户端发出）.
 * <p>
 * <b>本方法主要由MobileIMSDK框架内部使用。</b>
 *
 * @param loginUserId 提交到服务端的唯一id，保证唯一就可以通信，可能是登陆用户名、也可能是任意不重复的id等，具体意义由业务层决定
 * @param loginToken 提交到服务端用于身份鉴别和合法性检查的token，它可能是登陆密码，也可能是通过前置单点登陆接口拿到的token等，具体意义由业务层决定
 * @param extra 额外信息字符串。本字段目前为保留字段，供上层应用自行放置需要的内容
 * @return 登陆消息对象
 */
+ (YTProtocal *) createPLoginInfo:(NSString *)loginUserId withToken:(NSString *)loginToken andExtra:(NSString *)extra;

///*!
// * 创建用户心跳包对象（该对象由客户端发出）.
// * <p>
// * <b>本方法主要由MobileIMSDK框架内部使用。</b>
// *
// * @param from_user_id
// * @return
// */
//+ (YTProtocal *) createPKeepAlive:(NSString *)from_user_id;

/*!
 *  通用消息的Protocal对象新建方法（默认不需要Qos支持）。
 * <p>
 * <b>本方法主要由MobileIMSDK框架内部使用。</b>
 *
 *  @param dataContent  要发送的数据内容（字符串方式组织）
 *  @param from_user_id 发送人的user_id
 *  @param to_user_id   接收人的user_id
 *
 *  @return 新建的Protocal对象
 */
+ (YTProtocal *) createCommonData:(NSString *)dataContent fromUserId:(NSString *)from_user_id toUserId:(NSString *)to_user_id;


/*!
 *  通用消息的Protocal对象新建方法（默认不需要Qos支持）。
 * <p>
 * <b>本方法主要由MobileIMSDK框架内部使用。</b>
 *
 *  @param dataContent  要发送的数据内容（字符串方式组织）
 *  @param from_user_id 发送人的user_id
 *  @param to_user_id   接收人的user_id
 *
 *  @return 新建的Protocal对象
 */
+ (YTProtocal *) createCommonData:(NSString *)dataContent fromUserId:(NSString *)from_user_id toUserId:(NSString *)to_user_id withTypeu:(int)typeu;

/*!
 *  通用消息的Protocal对象新建方法。
 * <p>
 * <b>本方法主要由MobileIMSDK框架内部使用。</b>
 *
 *  @param dataContent  要发送的数据内容（字符串方式组织）
 *  @param from_user_id 发送人的user_id
 *  @param to_user_id   接收人的user_id
 *  @param QoS          是否需要QoS支持，true表示需要，否则不需要
 *  @param fingerPrint  消息指纹特征码，为nil则表示由系统自动生成指纹码，否则使用本参数指明的指纹码
 *
 *  @return 新建的Protocal对象
 */
+ (YTProtocal *) createCommonData:(NSString *)dataContent fromUserId:(NSString *)from_user_id toUserId:(NSString *)to_user_id qos:(bool)QoS fp:(NSString *)fingerPrint withTypeu:(int)typeu;

/*!
 * 客户端from_user_id向to_user_id发送一个QoS机制中需要的“收到消息应答包” (bridge标识默认为false).
 * <p>
 * <b>本方法主要由MobileIMSDK框架内部使用。</b>
 *
 * @param from_user_id 发起方
 * @param to_user_id 接收方
 * @param recievedMessageFingerPrint 已收到的消息包指纹码
 * @return 收到消息应答包
 */
+ (YTProtocal *) createRecivedBack:(NSString *)from_user_id toUserId:(NSString *)to_user_id withFingerPrint:(NSString *)recievedMessageFingerPrint;

/*!
 * 客户端from_user_id向to_user_id发送一个QoS机制中需要的“收到消息应答包”.
 * <p>
 * <b>本方法主要由MobileIMSDK框架内部使用。</b>
 *
 * @param from_user_id 发起方
 * @param to_user_id 接收方
 * @param recievedMessageFingerPrint 已收到的消息包指纹码
 * @return 收到消息应答包
 */
+ (YTProtocal *) createRecivedBack:(NSString *)from_user_id toUserId:(NSString *)to_user_id withFingerPrint:(NSString *)recievedMessageFingerPrint andBridge:(bool)bridge;

@end
