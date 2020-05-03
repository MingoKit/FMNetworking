//
//  FMNetworkingTools.m
//  AFNetworking
//
//  Created by mingo on 2019/4/15.
//

#import "FMNetworkingTools.h"
#import "FMEasyShowView.h"
#import "FMNetworkingManager.h"
#import <AFNetworking.h>

//#define kFMNetBid [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"]

@implementation FMNetworkingTools

+ (BOOL)fm_notEmptyInputObjcView:(id)objcView  tip:(NSString *)tip{
    BOOL isEmpty = NO;
    
    if ([objcView isKindOfClass:NSString.class] && ((NSString *)(objcView)).length <= 0) {
        isEmpty = YES;
    }
    if ([objcView isKindOfClass:UITextField.class] && ((UITextField *)(objcView)).text.length <= 0) {
        isEmpty = YES;
    }
    if ([objcView isKindOfClass:UITextView.class] && ((UITextView *)(objcView)).text.length <= 0) {
        isEmpty = YES;
    }
    if (isEmpty) {
        [FMNetworkingTools fm_showHudText:tip];
    }
    return isEmpty;
}


+(void)fm_showHudText:(NSString *)msg{
    [FMEasyShowOptions sharedFMEasyShowOptions].textStatusType = ShowTextStatusTypeMidden;
    [FMEasyShowTextView showText:msg];
}

+(void)fm_showHudLoadingIndicator{
    [FMEasyShowOptions sharedFMEasyShowOptions].textStatusType = ShowTextStatusTypeMidden;
    [FMEasyShowOptions sharedFMEasyShowOptions].lodingSuperViewReceiveEvent = NO;
    [FMEasyShowOptions sharedFMEasyShowOptions].lodingShowOnWindow = YES;
    [FMEasyShowOptions sharedFMEasyShowOptions].lodingBackgroundColor = UIColor.clearColor;
    [FMEasyShowOptions sharedFMEasyShowOptions].lodingAnimationType = lodingAnimationTypeNone;
    [FMEasyShowOptions sharedFMEasyShowOptions].lodingShowType = LodingShowTypeIndicator;
    [FMEasyShowLodingView showLodingText:@""];
}

+(void)fm_hidenHudIndicator {
    [FMEasyShowLodingView hidenLoding];
}

#pragma mark - 获取当前屏幕显示的VC
+ (UIViewController *)fm_getCurrentViewController {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    return currentVC;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC {
    UIViewController *currentVC;
    if([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    if([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
    }else if([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
    }else{
        // 根视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
}

@end
