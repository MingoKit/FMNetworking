//
//  FMNetworking.h
//  FupingElectricity
//
//  Created by mingo on 2019/3/21.
//  Copyright © 2019年 mingo. All rights reserved.
//

#import "FMRequestBase.h"

@interface FMNetworking : FMRequestBase

+ (void)fm_isHandleClickRequst:(BOOL)isHandleClickRequst showStatusTips:(BOOL)showStatusTip responseObject:(id)responseObject successOkBlock:(RequestSuccessBlock)successOkBlock successTokenErrorBlock:(RequestSuccessBlock)tokenErrorBlock successNotNeedBlock:(RequestSuccessBlock)notNeedBlock;

/// 上传用户图片  头像
+ (void)fm_uploadImagesUrl:(NSString *)urlString params:(id)params arrImagesOrFileNsdata:(id)imagesOrData progress:(RequestProgressBlock)progressBlock success:(RequestSuccessBlock)successBlock;

/// 上传 base64 图片
+ (void)fm_uploadBase64ImageUrl:(NSString *)urlString image:(UIImage *)image isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip progress:(RequestProgressBlock)progressBlock success:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock;

+ (void)fm_postDodyrawUrl:(NSString *)url bodyStr:(NSString *)bodyStr isHandleClick:(BOOL)isHandleClick showStatusTips:(BOOL)showStatusTips  successBlock:(RequestSuccessBlock)successBlock;
+ (void)fm_postDodyrawUrl:(NSString *)url bodyStr:(NSString *)bodyStr isHandleClick:(BOOL)isHandleClick showStatusTips:(BOOL)showStatusTips  successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock;

@end
