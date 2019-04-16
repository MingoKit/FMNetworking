//
//  FMEasyShowOptions.m
//  FMEasyShowViewDemo
//
//  Created by Mr_Chen on 2017/11/24.
//  Copyright © 2017年 chenliangloveyou. All rights reserved.
//

#import "FMEasyShowOptions.h"

const CGFloat FMEasyDrawImageWH  = 30 ;   //显示图片的宽高
const CGFloat FMEasyDrawImageEdge = 15 ;  //显示图片的边距
const CGFloat FMEasyTextShowEdge = 40 ;   //显示纯文字时，当设置top和bottom的时候，距离屏幕上下的距离
const CGFloat FMEasyShowViewMinWidth = 50 ;//视图最小的宽度

const CGFloat FMTextShowMaxTime = 8.0f;//最大的显示时长。显示的时长为字符串长度成比例。但是不会超过设置的此时间长度(默认为6秒)
const CGFloat FMTextShowMaxWidth = 300;//文字显示的最大宽度


const CGFloat FMEasyShowLodingMaxWidth = 200 ;    //显示文字的最大宽度（高度已限制死）
const CGFloat FMEasyShowLodingImageEdge = 10 ;    //加载框图片的边距
const CGFloat FMEasyShowLodingImageWH = 30 ;      //加载框图片的大小
const CGFloat FMEasyShowLodingImageMaxWH = 60 ;   //加载框图片的最大宽度


const CGFloat FMEasyShowAnimationTime = 0.3f ;    //动画时间


NSString *const FMEasyShowViewDidlDismissNotification = @"FMEasyShowViewDidlDismissNotification" ; //当FMEasyShowView消失的时候会发送此通知。


@interface FMEasyShowOptions()
@end

@implementation FMEasyShowOptions

@synthesize lodingPlayImagesArray = _lodingPlayImagesArray ;

static FMEasyShowOptions *_showInstance;
+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _showInstance = [super allocWithZone:zone];
    });
    return _showInstance;
}
+ (instancetype)sharedFMEasyShowOptions{
    if (nil == _showInstance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _showInstance = [[[self class] alloc] init];
        });
    }
    return _showInstance;
}
- (id)copyWithZone:(NSZone *)zone{
    return _showInstance;
}
- (id)mutableCopyWithZone:(NSZone *)zone
{
    return _showInstance;
}


- (instancetype)init
{
    if (self = [super init]) {
       
        _textAnimationType = TextAnimationTypeBounce ;
        _textStatusType = ShowTextStatusTypeMidden  ;
        
        _textTitleFount = [UIFont systemFontOfSize:17];
        _textTitleColor = [[UIColor whiteColor]colorWithAlphaComponent:1.7];
        _textBackGroundColor = [UIColor blackColor];
        _textShadowColor = [UIColor blueColor];
        
        _textSuperViewReceiveEvent = YES ;
        
        
        _lodingShowType = LodingShowTypeTurnAround ;
        _lodingAnimationType = lodingAnimationTypeBounce ;
        _lodingTextFount = [UIFont systemFontOfSize:17];
        _lodingTintColor = [UIColor blackColor];
        _lodingBackgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.05];
        _lodingSuperViewReceiveEvent = YES ;
        _lodingShowOnWindow = NO ;
        _lodingCycleCornerWidth = 5 ;
        
        
        // [UIColor colorWithRed:82/255.0 green:90/255.0 blue:251.0/255.0 alpha:1] ;
        _alertTitleColor = [UIColor blackColor];
        _alertMessageColor = [UIColor darkGrayColor];
        _alertTintColor = [UIColor clearColor];
        _alertTowItemHorizontal = YES ;
        _alertBgViewTapRemove = YES ;
    }
    return self ;
}
- (void)setlodingPlayImagesArray:(NSArray *)lodingPlayImagesArray
{
    _lodingPlayImagesArray = lodingPlayImagesArray ;
}
- (NSArray *)lodingPlayImagesArray
{
    NSAssert(_lodingPlayImagesArray, @"you should set image array use to animation!");
    return _lodingPlayImagesArray  ;
}

@end
