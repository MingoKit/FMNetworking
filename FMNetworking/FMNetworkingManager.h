
//  FMNetworkingManager.h
//  FupingElectricity
//
//  Created by mingo on 2018/6/26.
//  Copyright © 2018年 mingo. All rights reserved.
//

#import "FMNetworkingHelper.h"

#define kFormatWithMainHostUrl(parameter) [NSString stringWithFormat:@"%@/%@",FMNetworkingManager.sharedInstance.mainHostUrl,parameter]

typedef NS_ENUM(NSInteger, FMNetworkingHandlerType) {
    FMNetworkingHandlerTypeLogout = 1,
};

typedef void (^FMNetworkingHandler)(FMNetworkingHandlerType type);

@interface FMNetworkingManager : FMNetworkingHelper
@property (nonatomic, assign) NSInteger codetokenError;
@property (nonatomic, assign) NSInteger codeSuccess;
@property (nonatomic, assign) NSInteger codeLogout;

@property (nonatomic, copy) NSString *mainHostUrl;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) FMNetworkingHandler networkingHandler;
/// 初始化全局管家
+ (instancetype)sharedInstance;

+(void)fm_postUrl:(NSString *)url params:(NSDictionary *)params isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock;
+(void)fm_postUrl:(NSString *)url params:(NSDictionary *)params isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock;

+(void)fm_postRepeatedlyUrl:(NSString *)url failureTimes:(NSInteger)times params:(NSDictionary *)params isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock ;


@end
