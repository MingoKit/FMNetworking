//
//  FMRequestBase.m
//  FupingElectricity
//
//  Created by mingo on 2019/3/21.
//  Copyright © 2019年 mingo. All rights reserved.
//

#import "FMRequestBase.h"
#import "FMNetworkingTools+FMAdd.h"
#import "FMNetworkingManager.h"
#import <AFNetworking.h>

@implementation FMRequestBase


+ (void)fm_postRequest:(NSString *)url params:(NSMutableDictionary *)params forHTTPHeaderField:(NSDictionary *)dicHeader showIndicator:(BOOL)showIndicator showStatusTip:(BOOL)showStatusTip constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))constructingBodyblock progress:(RequestProgressBlock)progressBlock successOkBlock:(RequestSuccessBlock)successOkBlock successTokenErrorBlock:(RequestSuccessBlock)tokenErrorBlock successNotNeedBlock:(RequestSuccessBlock)notNeedBlock failureBlock:(RequestFailureBlock)failureBlock {
    NSString *urlStr = [FMNetworkingTools fm_checkRequestUrl:url];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 是否允许无效证书, 默认为NO
//    manager.securityPolicy.allowInvalidCertificates = YES;
//    // 是否校验域名, 默认为YES
//    manager.securityPolicy.validatesDomainName = NO;
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript",@"text/plain", nil];
//    manager.requestSerializer.timeoutInterval = FMNetworkingManager.sharedInstance.timeout;
    if (FMNetworkingManager.sharedInstance.timeout) {
        manager.requestSerializer.timeoutInterval = FMNetworkingManager.sharedInstance.timeout;
    }
    [FMNetworkingTools fm_forHTTPHeaderField:dicHeader manager:manager mutableURLRequest:nil];
    if (params == nil) {
        params = @{}.mutableCopy;
    }
    if (showIndicator) [FMNetworkingTools fm_showHudLoadingIndicator];
    [manager POST:urlStr parameters:params headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (constructingBodyblock) constructingBodyblock(formData);

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        CGFloat progress = 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        !progressBlock? :progressBlock(uploadProgress,progress);

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self fm_responseObject:responseObject httpSessionManager:manager requestMethod:@"POST Params" urlStr:urlStr params:params showIndicator:showIndicator showStatusTip:showStatusTip successOkBlock:successOkBlock successTokenErrorBlock:tokenErrorBlock successNotNeedBlock:notNeedBlock];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (showIndicator) {
            [FMNetworkingTools fm_hidenHudIndicator];
        }
        if (showStatusTip) [FMNetworkingTools fm_showHudText:[NSString stringWithFormat:@"%@",error.localizedDescription]];
        [FMNetworkingTools fm_logRequestFailure:error httpSessionManager:manager requestMethod:@"POST Params" urlStr:urlStr params:params];
        !failureBlock? :failureBlock(error,nil);
    }];
//    [self fm_requestDodyRawUrl:url requestType:FMNetworkingRequestTypePOST bodyraw:params forHttpHeader:dicHeader showIndicator:showIndicator showStatusTip:showStatusTip successOkBlock:successOkBlock successTokenErrorBlock:tokenErrorBlock successNotNeedBlock:notNeedBlock failureBlock:failureBlock];
    
}

+ (void)fm_getUrl:(NSString *)url params:(NSMutableDictionary *)params forHTTPHeaderField:(NSDictionary *)dicHeader showIndicator:(BOOL)showIndicator showStatusTip:(BOOL)showStatusTip  progress:(RequestProgressBlock)progressBlock successOkBlock:(RequestSuccessBlock)successOkBlock successTokenErrorBlock:(RequestSuccessBlock)tokenErrorBlock successNotNeedBlock:(RequestSuccessBlock)notNeedBlock failureBlock:(RequestFailureBlock)failureBlock {
    [self fm_requestDodyRawUrl:url requestType:FMNetworkingRequestTypeGET bodyraw:params forHttpHeader:dicHeader showIndicator:showIndicator showStatusTip:showStatusTip successOkBlock:successOkBlock successTokenErrorBlock:tokenErrorBlock successNotNeedBlock:notNeedBlock failureBlock:failureBlock];
}



+ (void)fm_postSetDodyRawUrl:(NSString *)url bodyraw:(id)bodyraw forHttpHeader:(NSDictionary *)dicHeader showIndicator:(BOOL)showIndicator showStatusTips:(BOOL)showStatusTips successOkBlock:(RequestSuccessBlock)successOkBlock successTokenErrorBlock:(RequestSuccessBlock)tokenErrorBlock successNotNeedBlock:(RequestSuccessBlock)notNeedBlock failureBlock:(RequestFailureBlock)failureBlock {
    [self fm_requestDodyRawUrl:url requestType:FMNetworkingRequestTypePOST bodyraw:bodyraw forHttpHeader:dicHeader showIndicator:showIndicator showStatusTip:showStatusTips successOkBlock:successOkBlock successTokenErrorBlock:tokenErrorBlock successNotNeedBlock:notNeedBlock failureBlock:failureBlock];
}

+ (void)fm_deleteDodyRawUrl:(NSString *)url bodyraw:(id)bodyraw forHttpHeader:(NSDictionary *)dicHeader showIndicator:(BOOL)showIndicator showStatusTips:(BOOL)showStatusTips successOkBlock:(RequestSuccessBlock)successOkBlock  failureBlock:(RequestFailureBlock)failureBlock {
    [self fm_requestDodyRawUrl:url requestType:FMNetworkingRequestTypeDELETE bodyraw:bodyraw forHttpHeader:dicHeader showIndicator:showIndicator showStatusTip:showStatusTips successOkBlock:successOkBlock successTokenErrorBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        
    } successNotNeedBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        
    } failureBlock:failureBlock];

}


+ (void)fm_requestDodyRawUrl:(NSString *)url requestType:(FMNetworkingRequestType)requestType bodyraw:(id)bodyraw forHttpHeader:(NSDictionary *)dicHeader showIndicator:(BOOL)showIndicator showStatusTip:(BOOL)showStatusTip successOkBlock:(RequestSuccessBlock)successOkBlock successTokenErrorBlock:(RequestSuccessBlock)tokenErrorBlock successNotNeedBlock:(RequestSuccessBlock)notNeedBlock failureBlock:(RequestFailureBlock)failureBlock {
    NSString *urlStr = [FMNetworkingTools fm_checkRequestUrl:url];
    NSString *requestMethod = [self fm_requestMethodWithType:requestType];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSMutableURLRequest *request =  [self fm_bulidSessionManager:urlStr requestType:requestType bodyraw:bodyraw];
    manager.responseSerializer = [self fm_bulidResponseSerializer];
   
    [FMNetworkingTools fm_forHTTPHeaderField:dicHeader manager:manager mutableURLRequest:request];
    if (showIndicator) [FMNetworkingTools fm_showHudLoadingIndicator];
    
    [[manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (showIndicator)  [FMNetworkingTools fm_hidenHudIndicator];
            if (showStatusTip && error.localizedDescription) {
                [FMNetworkingTools fm_showHudText:[NSString stringWithFormat:@"%@",error.localizedDescription]];
            }
            [FMNetworkingTools fm_logRequestFailure:error httpSessionManager:manager requestMethod:requestMethod urlStr:urlStr params:bodyraw];
            !failureBlock? :failureBlock(error,nil);
        } else {
            if (showIndicator) [FMNetworkingTools fm_hidenHudIndicator];
            
            NSDictionary * dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            [self fm_responseObject:dicJson httpSessionManager:manager requestMethod:requestMethod urlStr:urlStr params:bodyraw showIndicator:showIndicator showStatusTip:showStatusTip successOkBlock:successOkBlock successTokenErrorBlock:tokenErrorBlock successNotNeedBlock:notNeedBlock];
        }
    }] resume];;
}

#pragma mark -  私有方法
+ (NSString *)fm_requestMethodWithType:(FMNetworkingRequestType)requestType {
    NSString *requestMethod = @"";
    switch (requestType) {
        case FMNetworkingRequestTypeGET:
            requestMethod = @"GET";
            break;
        case FMNetworkingRequestTypePOST:
            requestMethod = @"POST";
            break;
        case FMNetworkingRequestTypeDELETE:
            requestMethod = @"DELETE";
            break;
        case FMNetworkingRequestTypePUT:
            requestMethod = @"PUT";
            break;
        default:
            break;
    }
    return requestMethod;
}

+ (NSMutableURLRequest *)fm_bulidSessionManager:(NSString *)urlStr requestType:(FMNetworkingRequestType)requestType bodyraw:(id)bodyraw {
    
    NSString *requestMethod = [self fm_requestMethodWithType:requestType];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:requestMethod URLString:urlStr parameters:nil error:nil];
    request.timeoutInterval = FMNetworkingManager.sharedInstance.timeout;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    if (requestType == FMNetworkingRequestTypeGET) {
        request.URL = [FMNetworkingTools fm_buildGetRequestUrl:urlStr params:bodyraw];
    }else{
        request.HTTPBody =  [FMNetworkingTools fm_setDodyRawForHttpBody:bodyraw]; // 设置body
    }
    [request setValue:FMNetworkingManager.sharedInstance.token forHTTPHeaderField:FMNetworkingManager.sharedInstance.tokenKeyName.length ? FMNetworkingManager.sharedInstance.tokenKeyName : @"token"];
    return request;
}

+ (AFHTTPResponseSerializer *)fm_bulidResponseSerializer{
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/json",@"text/javascript",@"text/plain", nil];
    return responseSerializer;
}

+ (void)fm_responseObject:(id)responseObject httpSessionManager:(AFHTTPSessionManager *)manager requestMethod:(NSString *)requestMethod urlStr:(NSString *)urlStr params:(id)params showIndicator:(BOOL)showIndicator showStatusTip:(BOOL)showStatusTip  successOkBlock:(RequestSuccessBlock)successOkBlock successTokenErrorBlock:(RequestSuccessBlock)tokenErrorBlock successNotNeedBlock:(RequestSuccessBlock)notNeedBlock {
    if (FMNetworkingManager.sharedInstance.mingok) {
        return;
    }
    [FMNetworkingTools fm_logRequestSuccess:responseObject httpSessionManager:manager requestMethod:requestMethod urlStr:urlStr params:params];
 
    NSString *msgStr = @"msg", *codeStr = @"code",*dataStr = @"data";
    if (FMNetworkingManager.sharedInstance.codekey.length) {
        codeStr = responseObject[FMNetworkingManager.sharedInstance.codekey];
    }
    if (FMNetworkingManager.sharedInstance.datakey.length) {
        dataStr = responseObject[FMNetworkingManager.sharedInstance.datakey];
    }
    if (FMNetworkingManager.sharedInstance.messagekey.length) {
        msgStr = responseObject[FMNetworkingManager.sharedInstance.messagekey];
    }else{
        msgStr = responseObject[@"msg"];
        if (!msgStr.length) {
            msgStr = responseObject[@"message"];
        }
    }
    id jsonData = responseObject[dataStr];
    NSInteger code = [responseObject[codeStr] integerValue];
    if (showIndicator) [FMNetworkingTools fm_hidenHudIndicator];
    
    !notNeedBlock? :notNeedBlock(jsonData,code,msgStr);

    if (code == FMNetworkingManager.sharedInstance.codeSuccess) {
        !successOkBlock? :successOkBlock(jsonData,code,msgStr);
        return;
    }
    if (((code <= FMNetworkingManager.sharedInstance.codeLogoutMax) && (code >= FMNetworkingManager.sharedInstance.codeLogoutMin)) ||
         code == FMNetworkingManager.sharedInstance.codeLogout) {
        if (FMNetworkingManager.sharedInstance.networkingHandler) {
            FMNetworkingManager.sharedInstance.networkingHandler(FMNetworkingHandlerTypeLogout, responseObject);
        }
        return ;
    }
    
    if (code == FMNetworkingManager.sharedInstance.codetokenError) {//token失效
        !tokenErrorBlock? :tokenErrorBlock(jsonData,code,msgStr);
        if (FMNetworkingManager.sharedInstance.networkingHandler) {
            FMNetworkingManager.sharedInstance.networkingHandler(FMNetworkingHandlerTypeTokenError, responseObject);
        }
        [FMNetworkingTools fm_showReloginAlert:msgStr]; /// 重新登录
        return;
    }
    if (showStatusTip) [FMNetworkingTools fm_showHudText:msgStr];
    
}

@end
