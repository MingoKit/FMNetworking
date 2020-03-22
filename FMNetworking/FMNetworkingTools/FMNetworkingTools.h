//
//  FMNetworkingTools.h
//  AFNetworking
//
//  Created by mingo on 2019/4/15.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define kshowHudText(_string_) [FMNetworkingTools fm_showHudText:((__bridge NSString *)CFSTR(#_string_))];
#define kshowHudTextFormat(_string_) [FMNetworkingTools fm_showHudText:_string_];

@class AFHTTPSessionManager;

@interface FMNetworkingTools : NSObject
/// 检查输入控件是否为空 支持 NSString UITextField UITextView
+ (BOOL)fm_notEmptyInputObjcView:(id)objcView  tip:(NSString *)tip;
//提示框四秒
+(void)fm_showHudText:(NSString *)msg;
/// 显示菊花 【显示期间不能交互】
+(void)fm_showHudLoadingIndicator;
/// 隐藏菊花
+(void)fm_hidenHudIndicator;
/// 找到当前屏幕显示的控制器
+ (UIViewController *)fm_getCurrentViewController;

@end
