
//  FMNetworkingManager.h
//  FupingElectricity
//
//  Created by mingo on 2018/6/26.
//  Copyright © 2018年 mingo. All rights reserved.
//

#import "FMNetworkingHelper.h"

#define kFormatWithMainHostUrl(parameter) [NSString stringWithFormat:@"%@/%@",FMNetworkingManager.sharedInstance.mainHostUrl,parameter]

typedef NS_ENUM(NSInteger, FMNetworkingHandlerType) {
    /// 退出登录
    FMNetworkingHandlerTypeLogout = 1,
    /// token 失效
    FMNetworkingHandlerTypeTokenError,
    /// 打印请求日志 
    FMNetworkingHandlerTypeRequestLog
};

typedef void (^FMNetworkingHandler)(FMNetworkingHandlerType type, id objc);

@interface FMNetworkingManager : FMNetworkingHelper
/// token 失效 code 码
@property (nonatomic, assign) NSInteger codetokenError;
/// 请求成功 code 码
@property (nonatomic, assign) NSInteger codeSuccess;
/// 退出登录code 码【会回调 FMNetworkingManager 中 networkingHandler(FMNetworkingHandlerTypeLogout, responseObject);】
@property (nonatomic, assign) NSInteger codeLogout; // 指定退出登录码
@property (nonatomic, assign) NSInteger codeLogoutMin; // 退出登录最小码
@property (nonatomic, assign) NSInteger codeLogoutMax; // 退出登录最大码 比如：300~400之间统一要求退出

/// 超时时间 【默认 20】
@property (nonatomic, assign) NSTimeInterval timeout;
/// 登录界面控制器名称
@property (nonatomic, copy) NSString *loginClassString;
/// 网络请求主 HOST
@property (nonatomic, copy) NSString *mainHostUrl;
/// token 的 值
@property (nonatomic, copy) NSString *token;
/// token 对应的 key
@property (nonatomic, copy) NSString *tokenKeyName;
/// 请求成功时 指定 最外层 message 取值哪个 key 【默认：message 或 msg】
@property (nonatomic, copy) NSString *messagekey;
/// 请求成功时 指定 最外层 code 码 取值哪个 key 【默认：code】
@property (nonatomic, copy) NSString *codekey;
/// 请求成功时 指定 最外层 data 业务数据 取值哪个 key 【默认：data】
@property (nonatomic, copy) NSString *datakey;
/// 默认必须要传的参数字典 【如 token，userId，Authorization，时间戳等等 】
@property (nonatomic, strong) NSMutableDictionary *dicDefaultHeader;
/// 特殊业务回调 【token失效，日志外传回调，退出登录 等等】
@property (nonatomic, copy) FMNetworkingHandler networkingHandler;
/// 初始化全局管家
+ (instancetype)sharedInstance;
/// post请求 有成功回调
+(void)fm_postUrl:(NSString *)url params:(NSMutableDictionary *)params showIndicator:(BOOL)showIndicator showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock;

/// post请求 有成功和失败回调
+(void)fm_postUrl:(NSString *)url params:(NSMutableDictionary *)params showIndicator:(BOOL)showIndicator showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock;
/// post请求 需要手动判断code
+(void)fm_postUrlCodeYourself:(NSString *)url params:(NSMutableDictionary *)params showIndicator:(BOOL)showIndicator showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock  failureBlock:(RequestFailureBlock)failureBlock;

/// get请求 有成功和失败回调
+(void)fm_getUrl:(NSString *)url params:(NSMutableDictionary *)params showIndicator:(BOOL)showIndicator showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock  failureBlock:(RequestFailureBlock)failureBlock;
/// get请求 需要手动判断code
+(void)fm_getUrlCodeYourself:(NSString *)url params:(NSMutableDictionary *)params showIndicator:(BOOL)showIndicator showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock  failureBlock:(RequestFailureBlock)failureBlock;

@end
