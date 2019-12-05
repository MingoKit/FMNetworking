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
    /*
    if (![url containsString:@"http"]) url = kFormatWithMainHostUrl(url);
    NSString *urlString = [NSURL URLWithString:url] ? url : [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];// 检查地址中是否有中文
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.securityPolicy.validatesDomainName = NO;
    //    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = FMNetworkingManager.sharedInstance.timeout;
    if (FMNetworkingManager.sharedInstance.timeout) {
        manager.requestSerializer.timeoutInterval = FMNetworkingManager.sharedInstance.timeout;
    }
    
    [FMNetworkingTools fm_forHTTPHeaderField:dicHeader manager:manager mutableURLRequest:nil];
    if (params == nil) {
        params = @{};
    }

    BOOL log = [NSString stringWithFormat:@"%@",(NSDictionary *)params[@"noLog"]].integerValue;
    [FMNetworkingTools fm_logRequestInfo:manager requestMethod:NO urlStr:url params:params noLog:log];
    if (isHanderClickRequst) [FMNetworkingTools fm_showHudLoadingIndicator];
    [manager POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (constructingBodyblock) constructingBodyblock(formData);
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        CGFloat progress = 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        !progressBlock? :progressBlock(uploadProgress,progress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self fm_isHandleClickRequst:isHanderClickRequst showStatusTips:showStatusTip noLog:log responseObject:responseObject successOkBlock:successOkBlock successTokenErrorBlock:tokenErrorBlock successNotNeedBlock:notNeedBlock];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (isHanderClickRequst) {
            [FMNetworkingTools fm_hidenHudIndicator];
        }
        if (showStatusTip) [FMNetworkingTools fm_showHudText:[NSString stringWithFormat:@"%@",error.localizedDescription]];
        [FMNetworkingTools fm_logRequestFailure:error];
        !failureBlock? :failureBlock(error,nil);
    }];*/
    
    [self fm_requestDodyRawUrl:url requestType:FMNetworkingRequestTypePOST bodyraw:params forHttpHeader:dicHeader showIndicatorHud:isHanderClickRequst showStatusTip:showStatusTip successOkBlock:successOkBlock successTokenErrorBlock:tokenErrorBlock successNotNeedBlock:notNeedBlock failureBlock:failureBlock];

    
}

+ (void)fm_getUrl:(NSString *)url params:(NSDictionary *)params forHTTPHeaderField:(NSDictionary *)dicHeader isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip  progress:(RequestProgressBlock)progressBlock successOkBlock:(RequestSuccessBlock)successOkBlock successTokenErrorBlock:(RequestSuccessBlock)tokenErrorBlock successNotNeedBlock:(RequestSuccessBlock)notNeedBlock failureBlock:(RequestFailureBlock)failureBlock {
    /*
    if (![url containsString:@"http"]) url = kFormatWithMainHostUrl(url);
    NSString *urlString = [NSURL URLWithString:url] ? url : [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];// 检查地址中是否有中文
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [FMNetworkingTools fm_forHTTPHeaderField:dicHeader manager:manager mutableURLRequest:nil];

    manager.requestSerializer.timeoutInterval = FMNetworkingManager.sharedInstance.timeout;
    BOOL log = [NSString stringWithFormat:@"%@",(NSDictionary *)params[@"noLog"]].integerValue;
    [FMNetworkingTools fm_logRequestInfo:manager requestMethod:YES urlStr:url params:params noLog:log];

    if (isHanderClickRequst) [FMNetworkingTools fm_showHudLoadingIndicator];
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        CGFloat progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        !progressBlock? :progressBlock(downloadProgress,progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [self fm_isHandleClickRequst:isHanderClickRequst showStatusTips:showStatusTip noLog:log  responseObject:responseObject successOkBlock:successOkBlock successTokenErrorBlock:tokenErrorBlock successNotNeedBlock:notNeedBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (isHanderClickRequst) [FMNetworkingTools fm_hidenHudIndicator];
        if (showStatusTip) [FMNetworkingTools fm_showHudText:[NSString stringWithFormat:@"%@",error.localizedDescription]];
        [FMNetworkingTools fm_logRequestFailure:error];
        !failureBlock? :failureBlock(error,nil);
    }];
    */
    [self fm_requestDodyRawUrl:url requestType:FMNetworkingRequestTypeGET bodyraw:params forHttpHeader:dicHeader showIndicatorHud:isHanderClickRequst showStatusTip:showStatusTip successOkBlock:successOkBlock successTokenErrorBlock:tokenErrorBlock successNotNeedBlock:notNeedBlock failureBlock:failureBlock];
}



+ (void)fm_postSetDodyRawUrl:(NSString *)url bodyraw:(id)bodyraw forHttpHeader:(NSDictionary *)dicHeader showIndicatorHud:(BOOL)showIndicatorHud showStatusTips:(BOOL)showStatusTips successOkBlock:(RequestSuccessBlock)successOkBlock successTokenErrorBlock:(RequestSuccessBlock)tokenErrorBlock successNotNeedBlock:(RequestSuccessBlock)notNeedBlock failureBlock:(RequestFailureBlock)failureBlock {
    [self fm_requestDodyRawUrl:url requestType:FMNetworkingRequestTypePOST bodyraw:bodyraw forHttpHeader:dicHeader showIndicatorHud:showIndicatorHud showStatusTip:showStatusTips successOkBlock:successOkBlock successTokenErrorBlock:tokenErrorBlock successNotNeedBlock:notNeedBlock failureBlock:failureBlock];
}

+ (void)fm_deleteDodyRawUrl:(NSString *)url bodyraw:(id)bodyraw forHttpHeader:(NSDictionary *)dicHeader showIndicatorHud:(BOOL)showIndicatorHud showStatusTips:(BOOL)showStatusTips successOkBlock:(RequestSuccessBlock)successOkBlock  failureBlock:(RequestFailureBlock)failureBlock {
    [self fm_requestDodyRawUrl:url requestType:FMNetworkingRequestTypeDELETE bodyraw:bodyraw forHttpHeader:dicHeader showIndicatorHud:showIndicatorHud showStatusTip:showStatusTips successOkBlock:successOkBlock successTokenErrorBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        
    } successNotNeedBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        
    } failureBlock:failureBlock];

}


+ (void)fm_requestDodyRawUrl:(NSString *)url requestType:(FMNetworkingRequestType)requestType bodyraw:(id)bodyraw forHttpHeader:(NSDictionary *)dicHeader showIndicatorHud:(BOOL)showIndicatorHud showStatusTip:(BOOL)showStatusTip successOkBlock:(RequestSuccessBlock)successOkBlock successTokenErrorBlock:(RequestSuccessBlock)tokenErrorBlock successNotNeedBlock:(RequestSuccessBlock)notNeedBlock failureBlock:(RequestFailureBlock)failureBlock {
    NSString *urlStr = url;
    if (!url.length) return;
    if (![url containsString:@"http"]) urlStr = kFormatWithMainHostUrl(url);
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
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
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:requestMethod URLString:urlStr parameters:nil error:nil];
    request.timeoutInterval = FMNetworkingManager.sharedInstance.timeout;
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",  @"text/json", @"text/javascript", @"text/plain", nil];
    manager.responseSerializer = responseSerializer;

    if (requestType != FMNetworkingRequestTypeGET) {
        // 设置body
        request.HTTPBody =  [FMNetworkingTools fm_setDodyRawForHttpBody:bodyraw];
    }
  

    [request setValue:FMNetworkingManager.sharedInstance.token forHTTPHeaderField:FMNetworkingManager.sharedInstance.tokenKeyName.length ? FMNetworkingManager.sharedInstance.tokenKeyName : @"token"];
    /// 这里要传 request 不能传manager，因为使用了 dataTaskWithRequest 请求
    [FMNetworkingTools fm_forHTTPHeaderField:dicHeader manager:manager mutableURLRequest:request];
    BOOL logFlag = NO;
    if ([bodyraw isKindOfClass:NSDictionary.class] || [bodyraw isKindOfClass:NSMutableDictionary.class] ) {
        logFlag = [NSString stringWithFormat:@"%@",(NSDictionary *)bodyraw[@"noLog"]].integerValue;
    }
    [FMNetworkingTools fm_logRequestInfo:manager requestMethod:requestMethod urlStr:urlStr params:bodyraw noLog:logFlag];
    
    if (showIndicatorHud) [FMNetworkingTools fm_showHudLoadingIndicator];
    [[manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (showIndicatorHud)  [FMNetworkingTools fm_hidenHudIndicator];
            if (showStatusTip && error.localizedDescription) {
                [FMNetworkingTools fm_showHudText:[NSString stringWithFormat:@"%@",error.localizedDescription]];
            }
            [FMNetworkingTools fm_logRequestFailure:error];
            !failureBlock? :failureBlock(error,nil);
        } else {
            if (showIndicatorHud) [FMNetworkingTools fm_hidenHudIndicator];
            
            NSDictionary * dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            [self fm_isHandleClickRequst:showIndicatorHud showStatusTips:showStatusTip noLog:logFlag responseObject:dicJson successOkBlock:successOkBlock successTokenErrorBlock:tokenErrorBlock successNotNeedBlock:notNeedBlock];
        }
    }] resume];;
}




#pragma mark -  私有方法


+ (void)fm_isHandleClickRequst:(BOOL)isHandleClickRequst showStatusTips:(BOOL)showStatusTip noLog:(BOOL)nolog responseObject:(id)responseObject successOkBlock:(RequestSuccessBlock)successOkBlock successTokenErrorBlock:(RequestSuccessBlock)tokenErrorBlock successNotNeedBlock:(RequestSuccessBlock)notNeedBlock {
    if (FMNetworkingManager.sharedInstance.mingok) {
        return;
    }
  
    [FMNetworkingTools fm_logRequestSuccess:responseObject noLog:nolog];
    id jsonData = responseObject[@"data"];
    NSInteger code = [responseObject[@"code"] integerValue];
    NSString *msgStr = @"";
    if (FMNetworkingManager.sharedInstance.messagekey.length) {
        msgStr = responseObject[FMNetworkingManager.sharedInstance.messagekey];
    }else{
        msgStr = responseObject[@"msg"];
        if (!msgStr.length) {
            msgStr = responseObject[@"message"];
        }
    }
    if (isHandleClickRequst) [FMNetworkingTools fm_hidenHudIndicator];
    
    !notNeedBlock? :notNeedBlock(jsonData,code,msgStr);

    if (code == FMNetworkingManager.sharedInstance.codeSuccess) {
        !successOkBlock? :successOkBlock(jsonData,code,msgStr);
        return;
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
