//
//  LJRequester.h
//  NetworkApplication
//
//  Created by Dennis Yang on 12-10-29.
//  Copyright (c) 2012年 Dennis Yang. All rights reserved.
//

/*!
 @header LJRequester
 @abstract 此类主要用来统一管理服务器请求。
 @author Dennis Yang
 @version 1.0.0 2012/10/29 Creation
 */

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

#import <RestKit/RestKit.h>
#import <RestKit/RKJSONParserJSONKit.h>

typedef void(^Block)(NSDictionary *dic);

/*!
 @class
 @abstract 这里封装了所有对服务器的请求，每个请求均需在函数最后携带一个指定回调的Block
 */
@interface LJRequester : NSObject <RKObjectLoaderDelegate>

@property (copy) Block callback;

/*!
 @method
 @abstract 获取单例
 @result 返回当前类的唯一实体
 */
+ (LJRequester *)sharedRequester;

/*!
 @method
 @abstract 请求获取 指定位置及指定数量 的Party
 @discussion 请求需指明指定位置、指定数量
 @param pos 开始位置
 @param len 数据长度
 @result 无
 */
- (void)partyListFromPosition:(int)pos withLength:(int)len;

/*!
 @method
 @abstract 请求获取 指定 Party 的详细信息
 @discussion 请求携带 Party Id
 @result 无
 */
- (void)partyDetail:(NSString *)pId;

/*!
 @method
 @abstract 请求获取 指定位置及指定数量 的 Party 会员列表
 @discussion 请求需指明指定位置、指定数量、指定 Party 的 id
 @param pId Party 的 Id
 @param pos 开始位置
 @param len 数据长度
 @result 无
 */
- (void)memberListOfParty:(NSString *)pId fromPosition:(int)pos withLength:(int)len;

/*!
 @method
 @abstract 请求获取 指定位置及指定数量 的 Party 图片列表
 @discussion 请求需指明指定位置、指定数量、指定 Party 的 id
 @param pId Party 的 Id
 @param pos 开始位置
 @param len 数据长度
 @result 无
 */
- (void)photoListOfParty:(NSString *)pId fromPosition:(int)pos withLength:(int)len;

/*!
 @method
 @abstract 请求登录
 @discussion 请求需携带用户名和密码
 @param name 登录帐号
 @param pass 登录密码
 @result 无
 */
- (void)loginWithUserName:(NSString *)name andPassword:(NSString *)pass;

/*!
 @method
 @abstract 请求更新用户信息
 @discussion 请求需携带一个包含用户信息的字典参数
 @param dic 包含昵称、真实姓名、所属部门、QQ号码、电子邮箱、性别、个人简介 的字典 
 @result 无
 */
- (void)updatePeopleInformation:(NSDictionary *)dic;

/*!
 @method
 @abstract 请求更新用户头像
 @discussion 请求需携带图片 icon
 @result 无
 */
- (void)updatePeopleHeaderIcon:(UIImage *)icon;

/*!
 @method
 @abstract 请求更改登录密码
 @discussion 请求需携带一个包含旧密码和新密码的字典参数
 @param old 旧密码
 @param new 新密码
 @result 无
 */
- (void)chagePassword:(NSString *)old newPassword:(NSString *)_new;

/*!
 @method
 @abstract 请求注销登录
 @discussion 不需要参数
 @result 无
 */
- (void)logout;

/*!
 @method
 @abstract 请求上传照片
 @discussion 请求需携带图片 image
 @param photo 照片
 @param voi 声音
 @result 无
 */
- (void)uploadPhoto:(UIImage *)photo;
- (void)uploadPhoto:(UIImage *)photo voice:(NSData *)voi;

/*!
 @method
 @abstract 请求获取 指定照片的评论列表
 @discussion 请求需指明指定位置、指定数量、指定照片 的id
 @param pId 照片Id
 @param pos 开始位置
 @param len 数据长度
 @result 无
 */
- (void)commentsOfPhoto:(NSString *)pId fromPosition:(int)pos withLength:(int)len;

/*!
 @method
 @abstract 请求 发送文字评论
 @discussion 请求需携带评论内容、指定照片 的id
 @param pId 照片Id
 @param tex 文字评论内容
 @result 无
 */
- (void)sendPhotoComment:(NSString *)pId comment:(NSString *)tex;

/*!
 @method
 @abstract 请求 发送语音评论
 @discussion 请求需携带评论内容、指定照片 的id
 @param pId 照片Id
 @param voi 语音评论内容
 @result 无
 */
- (void)sendPhotoComment:(NSString *)pId voice:(NSData *)voi;
- (void)sendPhotoComment:(NSString *)pId voice:(NSData *)voi length:(NSInteger)len;

/*!
 @method
 @abstract 请求 报名参加Party
 @discussion 请求需携带Party 的id
 @param pId Party Id
 @result 无
 */
- (void)joinParty:(NSString *)pId;

/*!
 @method
 @abstract 请求 为照片投票
 @discussion 请求需携带照片的id
 @param mId Image Id
 @result 无
 */
- (void)addGood:(NSString *)mId;

/*!
 @method
 @abstract 请求 获取短信验证码
 @discussion 请求需携带手机号
 @param mobile 手机号码
 @result 无
 */
- (void)getVerifyCode:(NSString *)mobile;

/*!
 @method
 @abstract 请求 注册
 @discussion 请求需携带手机号、密码、验证码
 @param mob 手机号码
 @param psd 密码
 @param cod 验证码
 @result 无
 */
- (void)registerWithMobile:(NSString *)mob pass:(NSString *)psd verify:(NSString *)cod;

/*!
 @method
 @abstract 忘记密码
 @discussion 请求需携带手机号
 @param mobile 手机号码
 @result 无
 */
- (void)getPassword:(NSString *)mobile;

@end
