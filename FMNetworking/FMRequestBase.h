//
//  FMRequestBase.h
//  FupingElectricity
//
//  Created by mingo on 2019/3/21.
//  Copyright © 2019年 mingo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
typedef NS_ENUM(NSInteger, FMNetworkingRequestType) {
    FMNetworkingRequestTypeGET = 1,
    FMNetworkingRequestTypePOST,
    FMNetworkingRequestTypeDELETE,
    FMNetworkingRequestTypePUT,
};

typedef void(^RequestSuccessBlock)(id responseObject,NSInteger code,NSString *msgStr);
typedef void(^RequestFailureBlock)(NSError *error , id objc);
typedef void(^RequestProgressBlock)(NSProgress *uploadProgress, CGFloat progress);//进入条需要

@interface FMRequestBase : NSObject

@property (nonatomic, assign) BOOL mingok;

+ (void)fm_postRequest:(NSString *)url params:(NSDictionary *)params forHTTPHeaderField:(NSDictionary *)dicHeader showIndicator:(BOOL)showIndicator showStatusTip:(BOOL)showStatusTip constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))constructingBodyblock progress:(RequestProgressBlock)progressBlock successOkBlock:(RequestSuccessBlock)successOkBlock successTokenErrorBlock:(RequestSuccessBlock)tokenErrorBlock successNotNeedBlock:(RequestSuccessBlock)notNeedBlock failureBlock:(RequestFailureBlock)failureBlock;

+ (void)fm_getUrl:(NSString *)url params:(NSDictionary *)params forHTTPHeaderField:(NSDictionary *)dicHeader showIndicator:(BOOL)showIndicator showStatusTip:(BOOL)showStatusTip  progress:(RequestProgressBlock)progressBlock successOkBlock:(RequestSuccessBlock)successOkBlock successTokenErrorBlock:(RequestSuccessBlock)tokenErrorBlock successNotNeedBlock:(RequestSuccessBlock)notNeedBlock failureBlock:(RequestFailureBlock)failureBlock;


+ (void)fm_postSetDodyRawUrl:(NSString *)url bodyraw:(id)bodyraw forHttpHeader:(NSDictionary *)dicHeader showIndicator:(BOOL)showIndicator showStatusTips:(BOOL)showStatusTips successOkBlock:(RequestSuccessBlock)successOkBlock successTokenErrorBlock:(RequestSuccessBlock)tokenErrorBlock successNotNeedBlock:(RequestSuccessBlock)notNeedBlock failureBlock:(RequestFailureBlock)failureBlock;

+ (void)fm_deleteDodyRawUrl:(NSString *)url bodyraw:(id)bodyraw forHttpHeader:(NSDictionary *)dicHeader showIndicator:(BOOL)showIndicator showStatusTips:(BOOL)showStatusTips successOkBlock:(RequestSuccessBlock)successOkBlock  failureBlock:(RequestFailureBlock)failureBlock;

+ (void)fm_requestDodyRawUrl:(NSString *)url requestType:(FMNetworkingRequestType)requestType bodyraw:(id)bodyraw forHttpHeader:(NSDictionary *)dicHeader showIndicator:(BOOL)showIndicator showStatusTip:(BOOL)showStatusTip successOkBlock:(RequestSuccessBlock)successOkBlock successTokenErrorBlock:(RequestSuccessBlock)tokenErrorBlock successNotNeedBlock:(RequestSuccessBlock)notNeedBlock failureBlock:(RequestFailureBlock)failureBlock;
@end
