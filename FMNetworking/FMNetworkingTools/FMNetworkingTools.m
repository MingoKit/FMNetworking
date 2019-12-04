//
//  FMNetworkingTools.m
//  AFNetworking
//
//  Created by mingo on 2019/4/15.
//

#import "FMNetworkingTools.h"
#import "FMEasyShowView.h"

@implementation FMNetworkingTools

+(void)fm_showHudText:(NSString *)msg{
    [FMEasyShowOptions sharedFMEasyShowOptions].textStatusType = ShowTextStatusTypeMidden;
    [FMEasyShowTextView showText:msg];
}

+(void)fm_showHudLoadingIndicator{
    [FMEasyShowOptions sharedFMEasyShowOptions].textStatusType = ShowTextStatusTypeMidden;
    [FMEasyShowOptions sharedFMEasyShowOptions].lodingSuperViewReceiveEvent = NO;
    [FMEasyShowOptions sharedFMEasyShowOptions].lodingShowOnWindow = YES;
    [FMEasyShowOptions sharedFMEasyShowOptions].lodingAnimationType = lodingAnimationTypeBounce;
    [FMEasyShowOptions sharedFMEasyShowOptions].lodingShowType = LodingShowTypeIndicator;
    [FMEasyShowLodingView showLodingText:@""];
}

+(void)fm_hidenHudIndicator {
    //    [MBProgressHUD st_hideHud];
    [FMEasyShowLodingView hidenLoding];
}


@end
