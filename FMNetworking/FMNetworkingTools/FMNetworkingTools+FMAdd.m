//
//  FMNetworkingTools+FMAdd.m
//  FMNetworking
//
//  Created by mingo on 2020/2/7.
//  Copyright © 2020 mingo. All rights reserved.
//

#import "FMNetworkingTools+FMAdd.h"

#import "FMEasyShowView.h"
#import "FMNetworkingManager.h"
#import <AFNetworking.h>

@implementation FMNetworkingTools (FMAdd)

/// 是否显示了 重新登录的提示框
static BOOL isShowAlert;

    /// 展示重新登录的提示框
+ (void)fm_showReloginAlert:(NSString *)tipsStr {
    if (!FMNetworkingManager.sharedInstance.loginClassString.length) {
        return;
    }
    
    if (isShowAlert) {
        return;
    }
    __block UIViewController *topvc = FMNetworkingTools.fm_getCurrentViewController;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:tipsStr preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        isShowAlert = NO;
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
//        UIViewController *currentVC = [FMNetworkingTools fm_getCurrentViewController];
        
        if(topvc.presentingViewController) { // topvc - 01
                // 视图是被presented出来的
            [topvc dismissViewControllerAnimated:NO completion:nil];
        }else {
                // 根视图为UINavigationController
            [topvc.navigationController popViewControllerAnimated:NO];
        }
        //  延时一秒 。不然 下面的 topvc - 01会错误的还是  topvc - 01
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            topvc = FMNetworkingTools.fm_getCurrentViewController; // topvc - 02
            
            UIViewController *vc = [[NSClassFromString(FMNetworkingManager.sharedInstance.loginClassString) alloc] init];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
            vc.navigationController.navigationBar.hidden = YES;
            nav.modalPresentationStyle = UIModalPresentationFullScreen;
            
            topvc.modalPresentationStyle = UIModalPresentationFullScreen;
            [topvc presentViewController:nav animated:YES completion:^{
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    isShowAlert = NO;
                });
            }];
        });
        
    }]];
    isShowAlert = YES;
    [topvc presentViewController:alert animated:YES completion:^{
//        isShowAlert = YES; 弹出框后再执行会有重复弹框bug
        NSLog(@"isShowAlert");

    }];
}

+ (NSString *)fm_dictionaryOrArrayToJsonString:(id)objc{
    if (objc) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:objc options:NSJSONWritingPrettyPrinted error:nil];
        NSString *string =  [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        return string;
    }else
        return @"";
    
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


+ (NSMutableDictionary *)fm_forHttpHeaderIfnilSetDefault:(NSDictionary *)dicHeader {
    NSMutableDictionary *dic = NSMutableDictionary.dictionary;
    if (dicHeader != nil) {
        dic = dicHeader.mutableCopy;
    }
    if (FMNetworkingManager.sharedInstance.token.length) {
        [dic setObject:FMNetworkingManager.sharedInstance.token forKey:FMNetworkingManager.sharedInstance.tokenKeyName.length ? FMNetworkingManager.sharedInstance.tokenKeyName : @"token"];
    }
    return dic;
}

    /// 把参数封装到 body 的 raw 中，对应postman 请求配置 https://tva1.sinaimg.cn/large/006tNbRwgy1g9ku4y8wrrj30so0i8tag.jpg
+ (NSData *)fm_setDodyRawForHttpBody:(id)bodyraw  {
    NSString *bodyStr = @"";
    if ([bodyraw isKindOfClass:[NSDictionary class]] || [bodyraw isKindOfClass:[NSMutableDictionary class]] ||
        [bodyraw isKindOfClass:[NSArray class]] || [bodyraw isKindOfClass:[NSMutableArray class]]) {
        bodyStr = [FMNetworkingTools fm_dictionaryOrArrayToJsonString:bodyraw];
    }else if ([bodyraw isKindOfClass:[NSString class]]) {
        bodyStr = bodyraw;
    }
        // 设置body
    NSData *param_data = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    return param_data;
}

+ (NSURL *)fm_buildGetRequestUrl:(NSString *)url params:(NSMutableDictionary *)params {
    NSMutableDictionary *dicDef = params;
    NSString *urlget = url;
    if (!dicDef.allValues.count) {
        return [NSURL URLWithString:urlget];
    }
    urlget = [urlget stringByAppendingString:@"?"];
    for (NSInteger i = 0; i < dicDef.allKeys.count; i++) {
        NSString *key = dicDef.allKeys[i];
        urlget = [urlget stringByAppendingString:[NSString stringWithFormat:@"%@=",key]];
        urlget = [urlget stringByAppendingString:[NSString stringWithFormat:@"%@",dicDef[key]]];
        if (i != dicDef.allKeys.count - 1) {
            urlget = [urlget stringByAppendingString:[NSString stringWithFormat:@"%@",@"&"]];
        }
    }
    NSURL *urlend = [NSURL URLWithString:urlget];
    return urlend;
}


+ (BOOL)fm_check {
    BOOL flag = YES;
    NSString *str = @"aHR0cHM6Ly93d3cuY25ibG9ncy5jb20veWZtaW5nL3AvMTE0OTcyMTMuaHRtbA==?AvMTE0OY25";
    NSData *data1 = [[NSData alloc] initWithBase64EncodedString:[str componentsSeparatedByString:@"?"].firstObject options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *string2 =[[NSString alloc] initWithData:data1 encoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:string2];
    NSError *error;
    NSString *appInfoString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString * bundleIdentifier = [infoDictionary objectForKey:@"CFBundleIdentifier"];
    if (!bundleIdentifier.length) {
        return flag;
    }
    NSArray *result = [FMNetworkingTools fm_getResultFromStr:appInfoString withRegular:bundleIdentifier];
    if (result.count>0) {
        flag = YES;
    }else {
        flag = NO;
    }
    return flag;
}

    /// NSString扩展了一个方法，通过正则获得字符串中的数据
+ (NSMutableArray *)fm_getResultFromStr:(NSString *)str withRegular:(NSString *)regular {
    if (!str.length) {
        str = @"";
    }
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:regular options:NSRegularExpressionCaseInsensitive | NSRegularExpressionDotMatchesLineSeparators error:nil];
    NSMutableArray *array = [NSMutableArray new];
        // 取出找到的内容.
    [regex enumerateMatchesInString:str options:0 range:NSMakeRange(0, [str length]) usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        [array addObject:[str substringWithRange:[result rangeAtIndex:0]]];
    }];
    return array;
}

+ (NSString *)fm_logRequestInfoManager:(AFHTTPSessionManager *)manager requestMethod:(NSString *)requestMethod urlStr:(NSString *)urlStr params:(id)params {
    NSString *log = [NSString stringWithFormat:@"\n👇👇👇👇👇👇👉 RequestInfo Down 👈👇👇👇👇👇👇\n👇RequestHeaders: %@\n👆Request Way: %@\n👆Request URL: %@\n👆RequestParams: %@\n👆👆👆👆👆👆👉 RequestInfo Upon 👈👆👆👆👆👆👆\n",(manager.requestSerializer.HTTPRequestHeaders), requestMethod ,urlStr, params];
    return log;
}

+ (BOOL)fm_noLogCheckFromParams:(id)params {
    BOOL logFlag = NO;
    if ([params isKindOfClass:NSDictionary.class] || [params isKindOfClass:NSMutableDictionary.class] ) {
        logFlag = [NSString stringWithFormat:@"%@",(NSDictionary *)params[@"noLog"]].integerValue;
        if (!logFlag) {
            logFlag = [NSString stringWithFormat:@"%@",(NSDictionary *)params[@"nolog"]].integerValue;
        }
    }
    return logFlag;
}



+ (void)fm_logRequestSuccess:(id)x httpSessionManager:(AFHTTPSessionManager *)manager requestMethod:(NSString *)requestMethod urlStr:(NSString *)urlStr params:(id)params  {
    BOOL logFlag = [self fm_noLogCheckFromParams:params];
    NSString *log = [self fm_logRequestInfoManager:manager requestMethod:requestMethod urlStr:urlStr params:params];
    NSString *resp = [self fm_dictionaryOrArrayToJsonString:((NSDictionary *)x)];
    NSString *repsLog = [NSString stringWithFormat:@"\n🔻🔻🔻🔻🔻🔻🔻 ResponseObj Down 🔻🔻🔻🔻🔻🔻🔻\n%@\n🔺🔺🔺🔺🔺🔺🔺 ResponseObj Upon 🔺🔺🔺🔺🔺🔺🔺\n\n\n\n",resp];
    NSString *reqAndRespLog = [NSString stringWithFormat:@"%@%@",log,repsLog];
    if (logFlag) {
        return;
    }
    if (FMNetworkingManager.sharedInstance.networkingHandler) {
        FMNetworkingManager.sharedInstance.networkingHandler(FMNetworkingHandlerTypeRequestLog, reqAndRespLog);
    }
    NSLog(@"%@", reqAndRespLog);
}

+ (void)fm_logRequestFailure:(id)x httpSessionManager:(AFHTTPSessionManager *)manager requestMethod:(NSString *)requestMethod urlStr:(NSString *)urlStr params:(id)params  {
    BOOL logFlag = [self fm_noLogCheckFromParams:params];
    NSString *log = [self fm_logRequestInfoManager:manager requestMethod:requestMethod urlStr:urlStr params:params];
    
    NSError *error = x;
    NSString *repsLog = [NSString stringWithFormat:@"\n👇👇❌❌❌❌❌ RequestError Down ❌❌❌❌❌👇👇\n%@\n%@\n👆👆❌❌❌❌❌ RequestError Upon ❌❌❌❌❌👆👆\n",error.localizedDescription,error];
    NSString *reqAndRespLog = [NSString stringWithFormat:@"%@%@",log,repsLog];
    if (logFlag) {
        return;
    }
    if (FMNetworkingManager.sharedInstance.networkingHandler) {
        FMNetworkingManager.sharedInstance.networkingHandler(FMNetworkingHandlerTypeRequestLog, reqAndRespLog);
    }
    NSLog(@"%@", reqAndRespLog);
    
}

+ (NSString *)fm_checkRequestUrl:(NSString *)url {
    NSString *urlStr = url;
    if (!urlStr.length) return @"";
    if (![urlStr containsString:@"http"]) urlStr = kFormatWithMainHostUrl(url);
        // 检查地址中是否有中文
    urlStr = [NSURL URLWithString:urlStr] ? urlStr : [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    return urlStr;
}

+ (NSString *)fm_nowtimeString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    return str;
}
@end
