//
//  FMRequestBase.h
//  FupingElectricity
//
//  Created by mingo on 2019/3/21.
//  Copyright © 2019年 mingo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

typedef void(^RequestSuccessBlock)(id responseObject,NSInteger code,NSString *msgStr);
typedef void(^RequestFailureBlock)(NSError *error , id objc);
typedef void(^RequestProgressBlock)(NSProgress *uploadProgress, CGFloat progress);//进入条需要

@interface FMRequestBase : NSObject

+ (void)fm_postRequest:(NSString *)url params:(NSDictionary *)params forHTTPHeaderField:(NSDictionary *)dicHeader isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))constructingBodyblock progress:(RequestProgressBlock)progressBlock successOkBlock:(RequestSuccessBlock)successOkBlock successTokenErrorBlock:(RequestSuccessBlock)tokenErrorBlock successNotNeedBlock:(RequestSuccessBlock)notNeedBlock failureBlock:(RequestFailureBlock)failureBlock;

+ (void)fm_getUrl:(NSString *)url params:(NSDictionary *)params forHTTPHeaderField:(NSDictionary *)dicHeader isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))constructingBodyblock progress:(RequestProgressBlock)progressBlock successOkBlock:(RequestSuccessBlock)successOkBlock successTokenErrorBlock:(RequestSuccessBlock)tokenErrorBlock successNotNeedBlock:(RequestSuccessBlock)notNeedBlock failureBlock:(RequestFailureBlock)failureBlock;

+ (void)fm_postSetHttpHeader:(NSString *)url params:(NSDictionary *)params forHttpHeaderIfnilSetDefault:(NSDictionary *)dicHeader isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock;
+ (void)fm_postSetHttpHeader:(NSString *)url params:(NSDictionary *)params forHttpHeaderIfnilSetDefault:(NSDictionary *)dicHeader isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock;


+ (void)fm_isHandleClickRequst:(BOOL)isHandleClickRequst showStatusTips:(BOOL)showStatusTip responseObject:(id)responseObject successOkBlock:(RequestSuccessBlock)successOkBlock successTokenErrorBlock:(RequestSuccessBlock)tokenErrorBlock successNotNeedBlock:(RequestSuccessBlock)notNeedBlock;

//+ (void)fm_logRequestInfo:(AFHTTPSessionManager *)manager isGetRequest:(BOOL)isGetRequest urlStr:(NSString *)urlStr params:(id)params;
@end
