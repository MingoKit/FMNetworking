//
//  FMNetworkingTools.h
//  AFNetworking
//
//  Created by mingo on 2019/4/15.
//

#import <Foundation/Foundation.h>

@interface FMNetworkingTools : NSObject

//提示框四秒
+(void)fm_showHudText:(NSString *)msg;

/// 显示菊花 【显示期间不能交互】
+(void)fm_showHudLoadingIndicator;
/// 隐藏菊花
+(void)fm_hidenHudIndicator;

@end
