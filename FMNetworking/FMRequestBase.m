//
//  FMRequestBase.m
//  FupingElectricity
//
//  Created by mingo on 2019/3/21.
//  Copyright © 2019年 mingo. All rights reserved.
//

#import "FMRequestBase.h"
#import "FMNetworkingTools.h"
#import "FMNetworkingManager.h"

@implementation FMRequestBase

+ (void)fm_postRequest:(NSString *)url params:(NSDictionary *)params forHTTPHeaderField:(NSDictionary *)dicHeader isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))constructingBodyblock progress:(RequestProgressBlock)progressBlock successOkBlock:(RequestSuccessBlock)successOkBlock successTokenErrorBlock:(RequestSuccessBlock)tokenErrorBlock successNotNeedBlock:(RequestSuccessBlock)notNeedBlock failureBlock:(RequestFailureBlock)failureBlock {
    
    if (![url containsString:@"http"]) url = kFormatWithMainHostUrl(url);
    NSString *urlString = [NSURL URLWithString:url] ? url : [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];/*! 检查地址中是否有中文 */
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.validatesDomainName = NO;
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30.0f;
    
    [self fm_forHTTPHeaderField:dicHeader manager:manager];
    if (params == nil) {
        params = @{};
    }
    [self fm_logRequestInfo:manager isGetRequest:NO urlStr:url params:params];
    if (isHanderClickRequst) [FMNetworkingTools fm_showHudLoadingIndicator];
    [manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (constructingBodyblock) constructingBodyblock(formData);
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        CGFloat progress = 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        !progressBlock? :progressBlock(uploadProgress,progress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self fm_isHandleClickRequst:isHanderClickRequst showStatusTips:showStatusTip responseObject:responseObject successOkBlock:successOkBlock successTokenErrorBlock:tokenErrorBlock successNotNeedBlock:notNeedBlock];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (isHanderClickRequst) {
            [FMNetworkingTools fm_hidenHudIndicator];
        }
        if (showStatusTip) [FMNetworkingTools fm_showHudText:[NSString stringWithFormat:@"%@",error.localizedDescription]];
        NSLog(@"error--------%@",error.localizedDescription);
        !failureBlock? :failureBlock(error,nil);
    }];
}

+ (void)fm_getUrl:(NSString *)url params:(NSDictionary *)params forHTTPHeaderField:(NSDictionary *)dicHeader isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))constructingBodyblock progress:(RequestProgressBlock)progressBlock successOkBlock:(RequestSuccessBlock)successOkBlock successTokenErrorBlock:(RequestSuccessBlock)tokenErrorBlock successNotNeedBlock:(RequestSuccessBlock)notNeedBlock failureBlock:(RequestFailureBlock)failureBlock {
    
    if (![url containsString:@"http"]) url = kFormatWithMainHostUrl(url);
    NSString *urlString = [NSURL URLWithString:url] ? url : [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];/*! 检查地址中是否有中文 */
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.validatesDomainName = NO;
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 25.0f;
    
    [self fm_forHTTPHeaderField:dicHeader manager:manager];
    if (params == nil) {
        params = @{};
    }
    [self fm_logRequestInfo:manager isGetRequest:NO urlStr:url params:params];
    if (isHanderClickRequst) [FMNetworkingTools fm_showHudLoadingIndicator];
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        CGFloat progress = 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        !progressBlock? :progressBlock(uploadProgress,progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self fm_isHandleClickRequst:isHanderClickRequst showStatusTips:showStatusTip responseObject:responseObject successOkBlock:successOkBlock successTokenErrorBlock:tokenErrorBlock successNotNeedBlock:notNeedBlock];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (isHanderClickRequst) [FMNetworkingTools fm_hidenHudIndicator];
        if (showStatusTip) [FMNetworkingTools fm_showHudText:[NSString stringWithFormat:@"%@",error.localizedDescription]];
        NSLog(@"error--------%@",error);
        !failureBlock? :failureBlock(error,nil);
    }];
}

+ (void)fm_postSetHttpHeader:(NSString *)url params:(NSDictionary *)params forHttpHeaderIfnilSetDefault:(NSDictionary *)dicHeader isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock {
    NSMutableDictionary *dic = NSMutableDictionary.dictionary;
    if (dicHeader == nil) {
        if (FMNetworkingManager.sharedInstance.userId.length) {
            [dic setObject:FMNetworkingManager.sharedInstance.userId forKey:@"userId"];
        }
    }else{
        dic = dicHeader.mutableCopy;
    }
    if (FMNetworkingManager.sharedInstance.token.length) {
        [dic setObject:FMNetworkingManager.sharedInstance.token forKey:@"token"];
    }
    
    [self fm_postRequest:url params:params forHTTPHeaderField:dic isHanderClickRequst:isHanderClickRequst showStatusTip:showStatusTip constructingBodyWithBlock:nil progress:nil successOkBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        if (successBlock) successBlock(responseObject,code,msgStr);
        
    } successTokenErrorBlock:nil successNotNeedBlock:nil failureBlock:^(NSError *error , id objc) {
        if (failureBlock) failureBlock(error,nil);
    }];
}
+ (void)fm_postSetHttpHeader:(NSString *)url params:(NSDictionary *)params forHttpHeaderIfnilSetDefault:(NSDictionary *)dicHeader isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock {
    [self fm_postSetHttpHeader:url params:params forHttpHeaderIfnilSetDefault:dicHeader isHanderClickRequst:isHanderClickRequst showStatusTip:showStatusTip successBlock:successBlock failureBlock:^(NSError *error, id objc) {
        
    }];
    
}


+ (void)fm_isHandleClickRequst:(BOOL)isHandleClickRequst showStatusTips:(BOOL)showStatusTip responseObject:(id)responseObject successOkBlock:(RequestSuccessBlock)successOkBlock successTokenErrorBlock:(RequestSuccessBlock)tokenErrorBlock successNotNeedBlock:(RequestSuccessBlock)notNeedBlock {
    NSLog(@"responseObject-------%@",responseObject);
    id jsonData = responseObject[@"data"];
    NSInteger code = [responseObject[@"code"] integerValue];
    NSString *msgStr = responseObject[@"msg"];
    if (isHandleClickRequst) [FMNetworkingTools fm_hidenHudIndicator];
    
   
    if (code == 1) {
        !successOkBlock? :successOkBlock(jsonData,code,msgStr);
        return;
    }
    if (code == 401) {//token失效
        !tokenErrorBlock? :tokenErrorBlock(jsonData,code,msgStr);
        //        [self fm_showReloginAlert:msgStr]; /// 重新登录
        return;
    }
    !notNeedBlock? :notNeedBlock(jsonData,code,msgStr);
    if (showStatusTip) [FMNetworkingTools fm_showHudText:msgStr];
    
}

+ (void)fm_logRequestInfo:(AFHTTPSessionManager *)manager isGetRequest:(BOOL)isGetRequest urlStr:(NSString *)urlStr params:(id)params{
    NSLog(@"\n******************** RequestInfo *********************\n\
RequestHeaders: %@\n\
Request Way: %@\n\
Request URL: %@\n\
RequestParams: %@\n\
******************************************************\n",(manager.requestSerializer.HTTPRequestHeaders), isGetRequest ? @"GET": @"POST" ,urlStr, params);
}
+ (void)fm_forHTTPHeaderField:(NSDictionary*)dicHeader manager:(AFHTTPSessionManager *)manager {
    if (dicHeader) { //将token 等等 封装入请求头
        for (NSInteger i = 0; i < dicHeader.allKeys.count; i++) {
            NSString *key = dicHeader.allKeys[i];
            [manager.requestSerializer setValue:dicHeader[key] forHTTPHeaderField:key];
        }
    }
}



@end
