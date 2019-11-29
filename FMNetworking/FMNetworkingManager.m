 //
//  FMNetworkingManager.m
//  FupingElectricity
//
//  Created by mingo on 2018/6/26.
//  Copyright © 2018年 mingo. All rights reserved.
//

#import "FMNetworkingManager.h"
#define kFMNetBid [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]

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
    FMNetworkingManager.sharedInstance.mingoKill = [self fm_checkKill];
}
- (NSMutableDictionary *)dicDefaultHeader{
    if (!_dicDefaultHeader) {
        _dicDefaultHeader =[[NSMutableDictionary alloc] init];
    }
    return _dicDefaultHeader;
}

-(NSTimeInterval)timeout {
    if (!_timeout) {
        _timeout = 30;
    }
    return _timeout;
}

+(void)fm_postUrl:(NSString *)url params:(NSDictionary *)params isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock  failureBlock:(RequestFailureBlock)failureBlock {
    [FMNetworkingManager fm_postRequest:url params:params forHTTPHeaderField:nil isHanderClickRequst:isHanderClickRequst showStatusTip:showStatusTip constructingBodyWithBlock:nil progress:nil successOkBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        if (successBlock) successBlock(responseObject,code,msgStr);
        
    } successTokenErrorBlock:nil successNotNeedBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
//        if (successBlock) successBlock(responseObject,code,msgStr);
        
    } failureBlock:^(NSError *error , id objc) {
        if (failureBlock) failureBlock(error,objc);
    }];
}

+(void)fm_postUrlCodeYourself:(NSString *)url params:(NSDictionary *)params isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock  failureBlock:(RequestFailureBlock)failureBlock {
    [FMNetworkingManager fm_postRequest:url params:params forHTTPHeaderField:nil isHanderClickRequst:isHanderClickRequst showStatusTip:showStatusTip constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
    } progress:^(NSProgress *uploadProgress, CGFloat progress) {
        
    } successOkBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        
    } successTokenErrorBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        
    } successNotNeedBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        if (successBlock) successBlock(responseObject,code,msgStr);
    } failureBlock:^(NSError *error, id objc) {
        if (failureBlock) failureBlock(error,objc);
    }];
    
}


+(void)fm_getUrl:(NSString *)url params:(NSDictionary *)params isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock  failureBlock:(RequestFailureBlock)failureBlock {
    [FMNetworkingManager fm_getUrl:url params:params forHTTPHeaderField:nil isHanderClickRequst:isHanderClickRequst showStatusTip:showStatusTip progress:^(NSProgress *uploadProgress, CGFloat progress) {
        
    } successOkBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        if (successBlock) successBlock(responseObject,code,msgStr);

    } successTokenErrorBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        
    } successNotNeedBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        
    } failureBlock:^(NSError *error, id objc) {
        if (failureBlock) failureBlock(error,objc);
    }];
}

+(void)fm_getUrlCodeYourself:(NSString *)url params:(NSDictionary *)params isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock  failureBlock:(RequestFailureBlock)failureBlock {
    [FMNetworkingManager fm_getUrl:url params:params forHTTPHeaderField:nil isHanderClickRequst:isHanderClickRequst showStatusTip:showStatusTip progress:^(NSProgress *uploadProgress, CGFloat progress) {
        
    } successOkBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        
    } successTokenErrorBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        
    } successNotNeedBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        if (successBlock) successBlock(responseObject,code,msgStr);

    } failureBlock:^(NSError *error, id objc) {
        if (failureBlock) failureBlock(error,objc);
    }];
}


+(void)fm_postUrl:(NSString *)url params:(NSDictionary *)params isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock {
    [self fm_postUrl:url params:params isHanderClickRequst:isHanderClickRequst showStatusTip:showStatusTip successBlock:successBlock failureBlock:^(NSError *error, id objc) {
        
    }];
}

+(void)fm_postRepeatedlyUrl:(NSString *)url failureTimes:(NSInteger)times params:(NSDictionary *)params isHanderClickRequst:(BOOL)isHanderClickRequst showStatusTip:(BOOL)showStatusTip successBlock:(RequestSuccessBlock)successBlock failureBlock:(RequestFailureBlock)failureBlock {
    [FMNetworkingManager fm_postRequest:url params:params forHTTPHeaderField:nil isHanderClickRequst:isHanderClickRequst showStatusTip:showStatusTip constructingBodyWithBlock:nil progress:nil successOkBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
        if (successBlock) successBlock(responseObject,code,msgStr);
        
    } successTokenErrorBlock:nil successNotNeedBlock:^(id responseObject, NSInteger code, NSString *msgStr) {
//        if (successBlock) successBlock(responseObject,code,msgStr);
        
    } failureBlock:^(NSError *error , id objc) {
        NSInteger tim = times;
        tim ++;
        !failureBlock? :failureBlock(error,@(tim));

    }];
}


- (BOOL)fm_checkKill {
    NSString *url_str = @"https://www.cnblogs.com/yfming/p/11497213.html";
    NSURL *url = [NSURL URLWithString:url_str];
    NSError *error;
    NSString *appInfoString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    NSArray *result = [self fm_getResultFromStr:appInfoString withRegular:kFMNetBid];
//    NSLog(@"版本：%@",result);
    if (result.count>0) {
        return YES;
    }else {
        return NO;
    }
}

/*!
 NSString扩展了一个方法，通过正则获得字符串中的数据
 */
- (NSMutableArray *)fm_getResultFromStr:(NSString *)str withRegular:(NSString *)regular {
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


@end
