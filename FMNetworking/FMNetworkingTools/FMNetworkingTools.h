//
//  FMNetworkingTools.h
//  AFNetworking
//
//  Created by mingo on 2019/4/15.
//

#import <Foundation/Foundation.h>
@class AFHTTPSessionManager;

@interface FMNetworkingTools : NSObject

//提示框四秒
+(void)fm_showHudText:(NSString *)msg;

/// 显示菊花 【显示期间不能交互】
+(void)fm_showHudLoadingIndicator;
/// 隐藏菊花
+(void)fm_hidenHudIndicator;
/// 找到当前屏幕显示的控制器
+ (UIViewController *)fm_getCurrentViewController;

/// 展示重新登录的提示框
+ (void)fm_showReloginAlert:(NSString *)tipsStr ;
/// 字典或者数字转json字符串
+ (NSString *)fm_dictionaryOrArrayToJsonString:(id)objc;
/// 设置请求头
+ (void)fm_forHTTPHeaderField:(NSDictionary*)dicHeader manager:(id )manager mutableURLRequest:(NSMutableURLRequest *)mutableURLRequest;
/// 打印请求成功的数据
+ (void)fm_logRequestSuccess:(id)x httpSessionManager:(AFHTTPSessionManager *)manager requestMethod:(NSString *)requestMethod urlStr:(NSString *)urlStr params:(id)params;
/// 打印请求失败的数据
+ (void)fm_logRequestFailure:(id)x httpSessionManager:(AFHTTPSessionManager *)manager requestMethod:(NSString *)requestMethod urlStr:(NSString *)urlStr params:(id)params ;
/// 把参数封装到 body 的 raw 中，对应postman 请求配置 https://tva1.sinaimg.cn/large/006tNbRwgy1g9ku4y8wrrj30so0i8tag.jpg
+ (NSData *)fm_setDodyRawForHttpBody:(id)bodyraw ;
/// 组装get请求的url 【根据 url 和参数】
+ (NSURL *)fm_buildGetRequestUrl:(NSString *)url params:(NSMutableDictionary *)params;

+ (BOOL)fm_check;


@end
