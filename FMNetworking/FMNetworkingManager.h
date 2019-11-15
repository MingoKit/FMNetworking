
//  FMNetworkingManager.h
//  FupingElectricity
//
//  Created by mingo on 2018/6/26.
//  Copyright © 2018年 mingo. All rights reserved.
//

#import "FMNetworkingHelper.h"

#define kFormatWithMainHostUrl(parameter) [NSString stringWithFormat:@"%@/%@",FMNetworkingManager.sharedInstance.mainHostUrl,parameter]

typedef NS_ENUM(NSInteger, FMNetworkingHandlerType) {
    FMNetworkingHandlerTypeLogout = 1,
    FMNetworkingHandlerTypeRequestLog

};

typedef void (^FMNetworkingHandler)(FMNetworkingHandlerType type, id objc);

@interface FMNetworkingManager : FMNetworkingHelper
@property (nonatomic, assign) NSInteger codetokenError;
@property (nonatomic, assign) NSInteger codeSuccess;
@property (nonatomic, assign) NSInteger codeLogout;
@property (nonatomic, copy) NSString *loginClassString;

@property (nonatomic, copy) NSString *mainHostUrl;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *tokenKeyName;
@property (nonatomic, copy) NSString *messagekey;
@property (nonatomic, strong) NSMutableDictionary *dicDefaultHeader;


@property (nonatomic, copy) FMNetworkingHandler networkingHandler;
/// 初始化全局管家
+ (instancetype)sharedInstance;
/// post请求 有成功回调
+(void)fm_postUrl:(NSString *)url params:(NSDictionary *)params isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock;

/// post请求 有成功和失败回调
+(void)fm_postUrl:(NSString *)url params:(NSDictionary *)params isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock;
/// post请求 需要手动判断code
+(void)fm_postUrlCodeYourself:(NSString *)url params:(NSDictionary *)params isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock  failureBlock:(RequestFailureBlock)failureBlock;

/// post请求 失败自动再次请求 【开发中ing】
+(void)fm_postRepeatedlyUrl:(NSString *)url failureTimes:(NSInteger)times params:(NSDictionary *)params isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock ;

/// get请求 有成功和失败回调
+(void)fm_getUrl:(NSString *)url params:(NSDictionary *)params isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock  failureBlock:(RequestFailureBlock)failureBlock;
/// get请求 需要手动判断code
+(void)fm_getUrlCodeYourself:(NSString *)url params:(NSDictionary *)params isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock  failureBlock:(RequestFailureBlock)failureBlock;

@end
