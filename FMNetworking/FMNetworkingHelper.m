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

@implementation FMNetworkingHelper
+ (void)fm_isHandleClickRequst:(BOOL)isHandleClickRequst showStatusTips:(BOOL)showStatusTip noLog:(BOOL)nolog responseObject:(id)responseObject successOkBlock:(RequestSuccessBlock)successOkBlock successTokenErrorBlock:(RequestSuccessBlock)tokenErrorBlock successNotNeedBlock:(RequestSuccessBlock)notNeedBlock {
    
    NSInteger code = [responseObject[@"code"] integerValue];
    if (code == FMNetworkingManager.sharedInstance.codeLogout) {
        NSLog(@"responseObject-------%@",responseObject);
        [self fm_loginOut];
        return ;
    }
    [super fm_isHandleClickRequst:isHandleClickRequst showStatusTips:showStatusTip noLog:nolog responseObject:responseObject successOkBlock:successOkBlock successTokenErrorBlock:tokenErrorBlock successNotNeedBlock:notNeedBlock];
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

/// 上传 base64 图片 
+ (void)fm_uploadBase64ImageUrl:(NSString *)urlString image:(UIImage *)image isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip progress:(RequestProgressBlock)progressBlock success:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock {
    
    NSData *data = UIImageJPEGRepresentation(image, 0.4f);
    NSString *base64Data = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *perstr = @"data:image/jpeg;base64";
    if (![base64Data hasPrefix:perstr]) {
        base64Data = [NSString stringWithFormat:@"%@,%@",perstr,base64Data];
    }
    NSDictionary *dic = @{
                          @"base64Data":base64Data
                          };
    [FMNetworkingManager fm_postRequest:urlString params:dic forHTTPHeaderField:nil isHanderClickRequst:isHanderClickRequst showStatusTip:showStatusTip constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    
    } progress:^(NSProgress *uploadProgress, CGFloat progress) {
        if (progressBlock) progressBlock(uploadProgress,progress);
        
    } successOkBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        if (successBlock) successBlock(responseObject,code,msgStr);
        
    } successTokenErrorBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        
    } successNotNeedBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        
    } failureBlock:^(NSError *error , id objc) {
        !failureBlock? :failureBlock(error,objc);
    }];
}

+ (void)fm_postDodyrawUrl:(NSString *)url bodyraw:(id)bodyraw isHandleClick:(BOOL)isHandleClick showStatusTips:(BOOL)showStatusTips  successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock  {
    [self fm_postSetDodyRawUrl:url bodyraw:bodyraw forHttpHeader:nil showIndicatorHud:isHandleClick showStatusTips:showStatusTips successOkBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        if (successBlock) successBlock(responseObject,code,msgStr);
    } successTokenErrorBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        
    } successNotNeedBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        
    } failureBlock:^(NSError *error, id objc) {
        
    }];
}

+ (void)fm_loginOut {
    
    if (FMNetworkingManager.sharedInstance.networkingHandler) {
        FMNetworkingManager.sharedInstance.networkingHandler(FMNetworkingHandlerTypeLogout, nil);
    }
}


@end
