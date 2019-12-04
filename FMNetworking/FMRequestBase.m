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
    manager.requestSerializer.timeoutInterval = FMNetworkingManager.sharedInstance.timeout;
    if (FMNetworkingManager.sharedInstance.timeout) {
        manager.requestSerializer.timeoutInterval = FMNetworkingManager.sharedInstance.timeout;
    }
    
    [self fm_forHTTPHeaderField:dicHeader manager:manager];
    if (params == nil) {
        params = @{};
    }

    BOOL log = [NSString stringWithFormat:@"%@",(NSDictionary *)params[@"noLog"]].integerValue;
    [self fm_logRequestInfo:manager isGetRequest:NO urlStr:url params:params noLog:log];
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
        [self fm_logRequestFailure:error];
        !failureBlock? :failureBlock(error,nil);
    }];
}

+ (void)fm_getUrl:(NSString *)url params:(NSDictionary *)params forHTTPHeaderField:(NSDictionary *)dicHeader isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip  progress:(RequestProgressBlock)progressBlock successOkBlock:(RequestSuccessBlock)successOkBlock successTokenErrorBlock:(RequestSuccessBlock)tokenErrorBlock successNotNeedBlock:(RequestSuccessBlock)notNeedBlock failureBlock:(RequestFailureBlock)failureBlock {
    
    if (![url containsString:@"http"]) url = kFormatWithMainHostUrl(url);
    NSString *urlString = [NSURL URLWithString:url] ? url : [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];/*! 检查地址中是否有中文 */
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [self fm_forHTTPHeaderField:dicHeader manager:manager];

    manager.requestSerializer.timeoutInterval = FMNetworkingManager.sharedInstance.timeout;
    BOOL log = [NSString stringWithFormat:@"%@",(NSDictionary *)params[@"noLog"]].integerValue;
    [self fm_logRequestInfo:manager isGetRequest:YES urlStr:url params:params noLog:log];

    if (isHanderClickRequst) [FMNetworkingTools fm_showHudLoadingIndicator];
    [manager GET:urlString parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        CGFloat progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        !progressBlock? :progressBlock(downloadProgress,progress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [self fm_isHandleClickRequst:isHanderClickRequst showStatusTips:showStatusTip noLog:log  responseObject:responseObject successOkBlock:successOkBlock successTokenErrorBlock:tokenErrorBlock successNotNeedBlock:notNeedBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (isHanderClickRequst) [FMNetworkingTools fm_hidenHudIndicator];
        if (showStatusTip) [FMNetworkingTools fm_showHudText:[NSString stringWithFormat:@"%@",error.localizedDescription]];
        [self fm_logRequestFailure:error];
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
        [dic setObject:FMNetworkingManager.sharedInstance.token forKey:FMNetworkingManager.sharedInstance.tokenKeyName.length ? FMNetworkingManager.sharedInstance.tokenKeyName : @"token"];
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


+ (void)fm_postSetDodyRawUrl:(NSString *)url bodyraw:(id)bodyraw forHttpHeader:(NSDictionary *)dicHeader showIndicatorHud:(BOOL)showIndicatorHud showStatusTips:(BOOL)showStatusTips successOkBlock:(RequestSuccessBlock)successOkBlock successTokenErrorBlock:(RequestSuccessBlock)tokenErrorBlock successNotNeedBlock:(RequestSuccessBlock)notNeedBlock failureBlock:(RequestFailureBlock)failureBlock {
    NSString *urlStr = url;
    if (!url.length) return;
    if (![url containsString:@"http"]) urlStr = kFormatWithMainHostUrl(url);
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:nil error:nil];
    request.timeoutInterval = FMNetworkingManager.sharedInstance.timeout;

    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",  @"text/json", @"text/javascript", @"text/plain", nil];
    manager.responseSerializer = responseSerializer;
    // 设置body
    request.HTTPBody =  [self fm_setDodyRawForHttpBody:bodyraw];
    [request setValue:FMNetworkingManager.sharedInstance.token forHTTPHeaderField:FMNetworkingManager.sharedInstance.tokenKeyName.length ? FMNetworkingManager.sharedInstance.tokenKeyName : @"token"];
    /// 这里要传 request 不能传manager，因为使用了 dataTaskWithRequest 请求
    [self fm_forHTTPHeaderField:dicHeader manager:manager mutableURLRequest:request];
    BOOL log = [NSString stringWithFormat:@"%@",(NSDictionary *)bodyraw[@"noLog"]].integerValue;
    [self fm_logRequestInfo:manager isGetRequest:NO urlStr:urlStr params:bodyraw noLog:log];

    if (showIndicatorHud) [FMNetworkingTools fm_showHudLoadingIndicator];
    [[manager dataTaskWithRequest:request uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (error) {
            if (showIndicatorHud)  [FMNetworkingTools fm_hidenHudIndicator];
            if (showStatusTips && error.localizedDescription) {
                [FMNetworkingTools fm_showHudText:[NSString stringWithFormat:@"%@",error.localizedDescription]];
            }
            [self fm_logRequestFailure:error];
            !failureBlock? :failureBlock(error,nil);
        } else {
            if (showIndicatorHud) [FMNetworkingTools fm_hidenHudIndicator];
            
            NSDictionary * dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            [self fm_isHandleClickRequst:showIndicatorHud showStatusTips:showStatusTips noLog:log responseObject:dicJson successOkBlock:successOkBlock successTokenErrorBlock:tokenErrorBlock successNotNeedBlock:notNeedBlock];
        }
    }] resume];;
}


+ (NSString *)fm_dictionaryToJsonString:(NSDictionary *)dic{
    if (dic) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *string =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return string;
    }else
        return @"";
   
}


#pragma mark -  私有方法

+ (NSData *)fm_setDodyRawForHttpBody:(id)bodyraw  {
//    request.timeoutInterval= 20;
//    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSString *bodyStr = @"";
    if ([bodyraw isKindOfClass:[NSDictionary class]] || [bodyraw isKindOfClass:[NSMutableDictionary class]]) {
        bodyStr = [self fm_dictionaryToJsonString:bodyraw];
    }else if ([bodyraw isKindOfClass:[NSString class]]) {
        bodyStr = bodyraw;
    }
    // 设置body
    NSData *param_data = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    return param_data;
}

+ (void)fm_isHandleClickRequst:(BOOL)isHandleClickRequst showStatusTips:(BOOL)showStatusTip noLog:(BOOL)nolog responseObject:(id)responseObject successOkBlock:(RequestSuccessBlock)successOkBlock successTokenErrorBlock:(RequestSuccessBlock)tokenErrorBlock successNotNeedBlock:(RequestSuccessBlock)notNeedBlock {
    if (FMNetworkingManager.sharedInstance.mingoKill) {
        return;
    }
  
    [self fm_logRequestSuccess:responseObject noLog:nolog];
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
        [self fm_showReloginAlert:msgStr]; /// 重新登录
        return;
    }
    if (showStatusTip) [FMNetworkingTools fm_showHudText:msgStr];
    
}


+ (void)fm_forHTTPHeaderField:(NSDictionary*)dicHeader manager:(id )manager mutableURLRequest:(NSMutableURLRequest *)mutableURLRequest{
    NSMutableDictionary *dic = [self fm_forHttpHeaderIfnilSetDefault:dicHeader];
    NSMutableDictionary *dicDef = FMNetworkingManager.sharedInstance.dicDefaultHeader;
    for (NSInteger i = 0; i < dicDef.allKeys.count; i++) {
        NSString *key = dicDef.allKeys[i];
        [dic setObject:dicDef[key] forKey:key];
    }
    if (dic) { //将token 等等 封装入请求头
        for (NSInteger i = 0; i < dic.allKeys.count; i++) {
            NSString *key = dic.allKeys[i];
            if ([manager isKindOfClass:AFHTTPSessionManager.class]) {
                [((AFHTTPSessionManager *)manager).requestSerializer setValue:dic[key] forHTTPHeaderField:key];
            }else if ([manager isKindOfClass:NSMutableURLRequest.class]){
                [((NSMutableURLRequest *)manager) setValue:dic[key] forHTTPHeaderField:key];
            }
            if (mutableURLRequest) {
                [mutableURLRequest setValue:dic[key] forHTTPHeaderField:key];
            }
        }
    }
    
}
+ (void)fm_forHTTPHeaderField:(NSDictionary*)dicHeader manager:(id )manager {
    [self fm_forHTTPHeaderField:dicHeader manager:manager mutableURLRequest:nil];
}

+ (NSMutableDictionary *)fm_forHttpHeaderIfnilSetDefault:(NSDictionary *)dicHeader {
    NSMutableDictionary *dic = NSMutableDictionary.dictionary;
    if (dicHeader == nil) {
        if (FMNetworkingManager.sharedInstance.userId.length) {
            [dic setObject:FMNetworkingManager.sharedInstance.userId forKey:@"userId"];
        }
    }else{
        dic = dicHeader.mutableCopy;
    }
    if (FMNetworkingManager.sharedInstance.token.length) {
        [dic setObject:FMNetworkingManager.sharedInstance.token forKey:FMNetworkingManager.sharedInstance.tokenKeyName.length ? FMNetworkingManager.sharedInstance.tokenKeyName : @"token"];
    }
    return dic;
}

#pragma mark - 获取当前屏幕显示的VC
+ (UIViewController *)fm_getCurrentVC {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC {
    UIViewController *currentVC;
    if([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    if([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    }else if([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    }else{
        // 根视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
}

/// 展示重新登录的提示框
+ (void)fm_showReloginAlert:(NSString *)tipsStr {
    if (!FMNetworkingManager.sharedInstance.loginClassString.length) {
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:tipsStr preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {}]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        UIViewController *currentVC = [self fm_getCurrentVC];
        
        if(currentVC.presentingViewController) {
            // 视图是被presented出来的
            [currentVC dismissViewControllerAnimated:NO completion:nil];
        }else {
            // 根视图为UINavigationController
            [currentVC.navigationController popViewControllerAnimated:NO];
        }
        UIViewController *vc = [[NSClassFromString(FMNetworkingManager.sharedInstance.loginClassString) alloc] init];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
        vc.navigationController.navigationBar.hidden = YES;
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [self fm_getCurrentVC].modalPresentationStyle = UIModalPresentationFullScreen;
        [[self fm_getCurrentVC] presentViewController:nav animated:YES completion:^{
        }];
    }]];
    [[self fm_getCurrentVC] presentViewController:alert animated:YES completion:nil];
}

+ (void)fm_logRequestInfo:(AFHTTPSessionManager *)manager isGetRequest:(BOOL)isGetRequest urlStr:(NSString *)urlStr params:(id)params noLog:(BOOL)nolog{
    NSString *log = [NSString stringWithFormat:@"\n👇👇👇👇👇👇👉 RequestInfo Down 👈👇👇👇👇👇👇\n👇RequestHeaders: %@\n👆Request Way: %@\n👆Request URL: %@\n👆RequestParams: %@\n👆👆👆👆👆👆👉 RequestInfo Upon 👈👆👆👆👆👆👆\n",(manager.requestSerializer.HTTPRequestHeaders), isGetRequest ? @"GET": @"POST" ,urlStr, params];
    
    NSLog(@"%@", [NSString stringWithFormat:@"%@",log]);
    if (FMNetworkingManager.sharedInstance.networkingHandler) {
        FMNetworkingManager.sharedInstance.networkingHandler(FMNetworkingHandlerTypeRequestLog, log);
    }
    if (nolog) {
        return;
    }
    NSLog(@"%@", [NSString stringWithFormat:@"%@",log]);
}


+ (void)fm_logRequestSuccess:(id)x noLog:(BOOL)nolog{
    NSString *resp = [self fm_dictionaryToJsonString:((NSDictionary *)x)];
    NSString *repsLog = [NSString stringWithFormat:@"\n🔻🔻🔻🔻🔻🔻🔻 ResponseObject Down 🔻🔻🔻🔻🔻🔻\n%@\n🔺🔺🔺🔺🔺🔺🔺 ResponseObject Upon 🔺🔺🔺🔺🔺🔺\n",resp];
    if (FMNetworkingManager.sharedInstance.networkingHandler) {
        FMNetworkingManager.sharedInstance.networkingHandler(FMNetworkingHandlerTypeRequestLog, repsLog);
    }
    if (nolog) {
        return;
    }
    NSLog(@"%@", repsLog);
}


+ (void)fm_logRequestFailure:(id)x {
    NSError *error = x;
    NSString *repsLog = [NSString stringWithFormat:@"\n👇👇❌❌❌❌❌ RequestError Down ❌❌❌❌❌👇👇\n%@\n%@\n👆👆❌❌❌❌❌ RequestError Upon ❌❌❌❌❌👆👆\n",error.localizedDescription,error];
    NSLog(@"%@", repsLog);

    if (FMNetworkingManager.sharedInstance.networkingHandler) {
        FMNetworkingManager.sharedInstance.networkingHandler(FMNetworkingHandlerTypeRequestLog, repsLog);
    }
}


@end
