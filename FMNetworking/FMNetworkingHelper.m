//
//  FMNetworking.m
//  FupingElectricity
//
//  Created by mingo on 2019/3/21.
//  Copyright © 2019年 mingo. All rights reserved.
//

#import "FMNetworkingHelper.h"
#import "FMNetworkingManager.h"
#import "FMNetworkingTools+FMAdd.h"
#import <AFNetworking.h>

@implementation FMNetworkingHelper

/// 上传图片 
+ (void)fm_uploadImagesUrl:(NSString *)url params:(id)params forHTTPHeaderField:(NSDictionary *)dicHeader arrImages:(NSMutableArray *)arrImages appointName:(NSString *)appointName progress:(RequestProgressBlock)progressBlock success:(RequestSuccessBlock)successBlock  {

    [FMNetworkingManager fm_postRequest:url params:params forHTTPHeaderField:dicHeader showIndicator:YES showStatusTip:YES constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (int i = 0; i < arrImages.count; i++) {
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", [FMNetworkingTools fm_nowtimeString]];
            NSData *imageData;
            if (![arrImages[i] isKindOfClass:[UIImage class]]) {continue;}/// 不是UIImage对象
            imageData = UIImageJPEGRepresentation(arrImages[i], 0.4);
            [formData appendPartWithFileData:imageData name:appointName.length ? appointName : @"image" fileName:fileName mimeType:@"image/jpg/png/jpeg"];
            
            /* //上传 此方法参数  1. 要上传的[二进制数据] 2. 对应上[upload.php中]处理文件的[字段"file"] 3. 要保存在服务器上的[文件名] 4. 上传文件的[mimeType]
             */
//               [formData appendPartWithFileData:imagesOrData name:@"image" fileName:fileName mimeType:@"image/jpg"];
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
+ (void)fm_uploadBase64ImageUrl:(NSString *)urlString image:(UIImage *)image showIndicator:(BOOL)showIndicator showStatusTip:(BOOL)showStatusTip progress:(RequestProgressBlock)progressBlock success:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock {
    
    NSData *data = UIImageJPEGRepresentation(image, 0.4f);
    NSString *base64Data = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *perstr = @"data:image/jpeg;base64";
    if (![base64Data hasPrefix:perstr]) {
        base64Data = [NSString stringWithFormat:@"%@,%@",perstr,base64Data];
    }
    NSDictionary *dic = @{
                          @"base64Data":base64Data
                          };
    [FMNetworkingManager fm_postRequest:urlString params:dic forHTTPHeaderField:nil showIndicator:showIndicator showStatusTip:showStatusTip constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    
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

+ (void)fm_postDodyrawUrl:(NSString *)url bodyraw:(id)bodyraw showIndicator:(BOOL)showIndicator showStatusTips:(BOOL)showStatusTips  successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock  {
    [self fm_postSetDodyRawUrl:url bodyraw:bodyraw forHttpHeader:nil showIndicator:showIndicator showStatusTips:showStatusTips successOkBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        if (successBlock) successBlock(responseObject,code,msgStr);
    } successTokenErrorBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        
    } successNotNeedBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        
    } failureBlock:^(NSError *error, id objc) {
        
    }];
}



@end
