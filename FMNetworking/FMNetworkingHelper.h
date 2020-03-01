//
//  FMNetworking.h
//  FupingElectricity
//
//  Created by mingo on 2019/3/21.
//  Copyright © 2019年 mingo. All rights reserved.
//

#import "FMRequestBase.h"

@interface FMNetworkingHelper : FMRequestBase

/// 上传用户图片  头像
+ (void)fm_uploadImagesUrl:(NSString *)urlString params:(id)params arrImagesOrFileNsdata:(id)imagesOrData progress:(RequestProgressBlock)progressBlock success:(RequestSuccessBlock)successBlock;

/// 上传 base64 图片
+ (void)fm_uploadBase64ImageUrl:(NSString *)urlString image:(UIImage *)image showIndicator:(BOOL)showIndicator showStatusTip:(BOOL)showStatusTip progress:(RequestProgressBlock)progressBlock success:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock;

//+ (void)fm_postDodyrawUrl:(NSString *)url bodyraw:(id)bodyraw showIndicator:(BOOL)showIndicator showStatusTips:(BOOL)showStatusTips  successBlock:(RequestSuccessBlock)successBlock;
/// post 请求 参数 写在  Dodyraw 中
+ (void)fm_postDodyrawUrl:(NSString *)url bodyraw:(id)bodyraw showIndicator:(BOOL)showIndicator showStatusTips:(BOOL)showStatusTips  successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock;
@end
