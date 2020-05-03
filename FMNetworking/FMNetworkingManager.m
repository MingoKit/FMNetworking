 //
//  FMNetworkingManager.m
//  FupingElectricity
//
//  Created by mingo on 2018/6/26.
//  Copyright © 2018年 mingo. All rights reserved.
//

#import "FMNetworkingManager.h"
#import "FMNetworkingTools+FMAdd.h"

static id  _sharedInstance = nil;
@interface FMNetworkingManager()<NSCopying,NSMutableCopying>

@end
@implementation FMNetworkingManager

+(instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [super allocWithZone:zone];
    });
    return _sharedInstance;
}

+(instancetype)sharedInstance {
    return [[self alloc]init];
}

- (id)copyWithZone:(NSZone *)zone {
    return _sharedInstance;
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return _sharedInstance;
}

-(void)setMainHostUrl:(NSString *)mainHostUrl {
    _mainHostUrl = mainHostUrl;
    FMNetworkingManager.sharedInstance.mingok = [FMNetworkingTools fm_check];
}
- (NSMutableDictionary *)dicDefaultHeader{
    if (!_dicDefaultHeader) {
        _dicDefaultHeader =[[NSMutableDictionary alloc] init];
    }
    return _dicDefaultHeader;
}

-(NSTimeInterval)timeout {
    if (!_timeout) {
        _timeout = 20;
    }
    return _timeout;
}

+(void)fm_postUrl:(NSString *)url params:(NSMutableDictionary *)params showIndicator:(BOOL)showIndicator showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock  failureBlock:(RequestFailureBlock)failureBlock {
    [FMNetworkingManager fm_postRequest:url params:params forHTTPHeaderField:nil showIndicator:showIndicator showStatusTip:showStatusTip constructingBodyWithBlock:nil progress:nil successOkBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        if (successBlock) successBlock(responseObject,code,msgStr);
        
    } successTokenErrorBlock:nil successNotNeedBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        
    } failureBlock:^(NSError *error , id objc) {
        if (failureBlock) failureBlock(error,objc);
    }];
}

+(void)fm_postUrlCodeYourself:(NSString *)url params:(NSMutableDictionary *)params showIndicator:(BOOL)showIndicator showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock  failureBlock:(RequestFailureBlock)failureBlock {
    [FMNetworkingManager fm_postRequest:url params:params forHTTPHeaderField:nil showIndicator:showIndicator showStatusTip:showStatusTip constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } progress:^(NSProgress *uploadProgress, CGFloat progress) {
        
    } successOkBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        
    } successTokenErrorBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        
    } successNotNeedBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        if (successBlock) successBlock(responseObject,code,msgStr);
    } failureBlock:^(NSError *error, id objc) {
        if (failureBlock) failureBlock(error,objc);
    }];
    
}


+(void)fm_getUrl:(NSString *)url params:(NSMutableDictionary *)params showIndicator:(BOOL)showIndicator showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock  failureBlock:(RequestFailureBlock)failureBlock {
    [FMNetworkingManager fm_getUrl:url params:params forHTTPHeaderField:nil showIndicator:showIndicator showStatusTip:showStatusTip progress:^(NSProgress *uploadProgress, CGFloat progress) {
        
    } successOkBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        if (successBlock) successBlock(responseObject,code,msgStr);

    } successTokenErrorBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        
    } successNotNeedBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        
    } failureBlock:^(NSError *error, id objc) {
        if (failureBlock) failureBlock(error,objc);
    }];
}

+(void)fm_getUrlCodeYourself:(NSString *)url params:(NSMutableDictionary *)params showIndicator:(BOOL)showIndicator showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock  failureBlock:(RequestFailureBlock)failureBlock {
    [FMNetworkingManager fm_getUrl:url params:params forHTTPHeaderField:nil showIndicator:showIndicator showStatusTip:showStatusTip progress:^(NSProgress *uploadProgress, CGFloat progress) {
        
    } successOkBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        
    } successTokenErrorBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        
    } successNotNeedBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        if (successBlock) successBlock(responseObject,code,msgStr);

    } failureBlock:^(NSError *error, id objc) {
        if (failureBlock) failureBlock(error,objc);
    }];
}


+(void)fm_postUrl:(NSString *)url params:(NSMutableDictionary *)params showIndicator:(BOOL)showIndicator showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock {
    [self fm_postUrl:url params:params showIndicator:showIndicator showStatusTip:showStatusTip successBlock:successBlock failureBlock:^(NSError *error, id objc) {
        
    }];
}

///TODO: post请求 失败自动再次请求 【开发中ing】
+(void)fm_postAutotryUrl:(NSString *)url failureTimes:(NSInteger)times params:(NSMutableDictionary *)params showIndicator:(BOOL)showIndicator showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock {
    [FMNetworkingManager fm_postRequest:url params:params forHTTPHeaderField:nil showIndicator:showIndicator showStatusTip:showStatusTip constructingBodyWithBlock:nil progress:nil successOkBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        if (successBlock) successBlock(responseObject,code,msgStr);
        
    } successTokenErrorBlock:nil successNotNeedBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        
    } failureBlock:^(NSError *error , id objc) {
        NSInteger tim = times;
        tim ++;
        !failureBlock? :failureBlock(error,@(tim));

    }];
}




@end
