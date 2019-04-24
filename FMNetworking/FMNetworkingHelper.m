//
//  FMNetworking.m
//  FupingElectricity
//
//  Created by mingo on 2019/3/21.
//  Copyright © 2019年 mingo. All rights reserved.
//

#import "FMNetworkingHelper.h"
#import "FMNetworkingManager.h"
#import "FMNetworkingTools.h"

@implementation FMNetworking
+ (void)fm_isHandleClickRequst:(BOOL)isHandleClickRequst showStatusTips:(BOOL)showStatusTip responseObject:(id)responseObject successOkBlock:(RequestSuccessBlock)successOkBlock successTokenErrorBlock:(RequestSuccessBlock)tokenErrorBlock successNotNeedBlock:(RequestSuccessBlock)notNeedBlock {
    NSInteger code = [responseObject[@"code"] integerValue];
    if (code == 100) {
        [self fm_loginOut];
        return ;
    }
    [super fm_isHandleClickRequst:isHandleClickRequst showStatusTips:showStatusTip responseObject:responseObject successOkBlock:successOkBlock successTokenErrorBlock:tokenErrorBlock successNotNeedBlock:notNeedBlock];
}


/// 上传用户图片  头像
+ (void)fm_uploadImagesUrl:(NSString *)urlString params:(id)params arrImagesOrFileNsdata:(id)imagesOrData progress:(RequestProgressBlock)progressBlock success:(RequestSuccessBlock)successBlock  {
    [FMNetworkingManager fm_postRequest:urlString params:params forHTTPHeaderField:nil isHanderClickRequst:YES showStatusTip:YES constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if ([imagesOrData isKindOfClass:NSArray.class] || [imagesOrData isKindOfClass:NSMutableArray.class]) {
            //如果是传多张图片
            NSArray *images = [NSArray arrayWithArray:imagesOrData];
            for (int i = 0; i < images.count; i++) {
                if (![images[i] isKindOfClass:[UIImage class]]) {return;}/// 不是UIImage对象
            }
            for (int i = 0;i<images.count;i++) {
                NSData *imageData;
                imageData = UIImageJPEGRepresentation(images[i], 0.5);
                [formData appendPartWithFileData:imageData name:urlString fileName:@"image.jpeg" mimeType:@"image/jpg/png/jpeg"];
            }
            return;
        }
        if ([imagesOrData isKindOfClass:NSData.class]) { //按照表单格式把二进制文件写入formData表单
            [formData appendPartWithFileData:imagesOrData name:urlString fileName:@"image.jpeg" mimeType:@"application/octet-stream"];
            return;
        }
    } progress:^(NSProgress *uploadProgress, CGFloat progress) {
        if (progressBlock) progressBlock(uploadProgress,progress);
        
    } successOkBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        if (successBlock) successBlock(responseObject,code,msgStr);
        
    } successTokenErrorBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        
    } successNotNeedBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        
    } failureBlock:^(NSError *error , id objc) {
        
    }];
}


+ (void)fm_postSetDodyRawUrl:(NSString *)url bodyStr:(NSString *)bodyStr isHandleClickRequst:(BOOL)isHandleClickRequst showStatusTips:(BOOL)showStatusTips successOkBlock:(RequestSuccessBlock)successOkBlock successTokenErrorBlock:(RequestSuccessBlock)tokenErrorBlock successNotNeedBlock:(RequestSuccessBlock)notNeedBlock failureBlock:(RequestFailureBlock)failureBlock {
    
    NSString *urlStr = url;
    if (!url.length) return;
    if (![url containsString:@"http"]) urlStr = kFormatWithMainHostUrl(url);
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlStr parameters:nil error:nil];
    request.timeoutInterval= 20;
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // 设置body
    NSData *param_data = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPBody = param_data;
    
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",  @"text/json", @"text/javascript", @"text/plain", nil];
    
    manager.responseSerializer = responseSerializer;
    if (isHandleClickRequst) [FMNetworkingTools fm_showHudLoadingIndicator];
    
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if (!error) {
            if (isHandleClickRequst) [FMNetworkingTools fm_hidenHudIndicator];
            
            NSDictionary * dicJson = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            
            id jsonData = dicJson[@"data"];
            NSLog(@"responseObject-------%@",dicJson);
            
            NSInteger code = [dicJson[@"code"] integerValue];
            NSString *msgStr = dicJson[@"msg"];
            if (code == 1) {
                !successOkBlock? :successOkBlock(jsonData,code,msgStr);
                
            }else if (code == 401) {//token失效
                !tokenErrorBlock? :tokenErrorBlock(jsonData,code,msgStr);
                
            } else {
                !notNeedBlock? :notNeedBlock(jsonData,code,msgStr);
                if (showStatusTips) [FMNetworkingTools fm_showHudText:msgStr];
                
            }
        } else {
            if (isHandleClickRequst) {
                [FMNetworkingTools fm_hidenHudIndicator];
            }
            if (showStatusTips) {
                [FMNetworkingTools fm_showHudText:[NSString stringWithFormat:@"%@",error.localizedDescription]];
            }
            NSLog(@"error--------%@",error);
            !failureBlock? :failureBlock(error,nil);
        }
    }] resume];
}

+ (void)fm_postDodyrawUrl:(NSString *)url bodyStr:(NSString *)bodyStr isHandleClick:(BOOL)isHandleClick showStatusTips:(BOOL)showStatusTips  successBlock:(RequestSuccessBlock)successBlock {
    [self fm_postDodyrawUrl:url bodyStr:bodyStr isHandleClick:isHandleClick showStatusTips:showStatusTips successBlock:successBlock failureBlock:^(NSError *error, id objc) {
        
    }];
}

+ (void)fm_postDodyrawUrl:(NSString *)url bodyStr:(NSString *)bodyStr isHandleClick:(BOOL)isHandleClick showStatusTips:(BOOL)showStatusTips  successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock {
    [self fm_postSetDodyRawUrl:url bodyStr:bodyStr isHandleClickRequst:isHandleClick showStatusTips:showStatusTips successOkBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        !successBlock? :successBlock(responseObject,code,msgStr);
        
    } successTokenErrorBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        
    } successNotNeedBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        
    } failureBlock:^(NSError *error , id objc) {
        !failureBlock? :failureBlock(error,objc);
    }];
}

+ (void)fm_loginOut {
    
    if (FMNetworkingManager.sharedInstance.networkingHandler) {
        FMNetworkingManager.sharedInstance.networkingHandler(FMNetworkingHandlerTypeLogout);
    }
}


//#pragma mark - 获取当前屏幕显示的VC
//+ (UIViewController *)fm_getCurrentVC {
//    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
//    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
//    return currentVC;
//}
//
//+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC {
//    UIViewController *currentVC;
//    if([rootVC presentedViewController]) {
//        // 视图是被presented出来的
//        rootVC = [rootVC presentedViewController];
//    }
//    if([rootVC isKindOfClass:[UITabBarController class]]) {
//        // 根视图为UITabBarController
//        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
//    }else if([rootVC isKindOfClass:[UINavigationController class]]){
//        // 根视图为UINavigationController
//        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
//    }else{
//        // 根视图为非导航类
//        currentVC = rootVC;
//    }
//    return currentVC;
//}

///// 展示重新登录的提示框
//+ (void)fm_showReloginAlert:(NSString *)tipsStr {
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:tipsStr preferredStyle:UIAlertControllerStyleAlert];
//    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {}]];
//    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
//        UIViewController *currentVC = [self fm_getCurrentVC];
//
//        if(currentVC.presentingViewController) {
//            // 视图是被presented出来的
//            [currentVC dismissViewControllerAnimated:NO completion:nil];
//        }else {
//            // 根视图为UINavigationController
//            [currentVC.navigationController popViewControllerAnimated:NO];
//        }
//        [[self fm_getCurrentVC] presentViewController:[[NSClassFromString(@"LoginViewController") alloc] init] animated:YES completion:^{
//        }];
//    }]];
//    [[self fm_getCurrentVC] presentViewController:alert animated:YES completion:nil];
//}
@end
