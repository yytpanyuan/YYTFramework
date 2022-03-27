//
//  YYTLoadingPageAdManager.m
//  YYTFramework
//
//  Created by yyt on 16/9/21.
//  Copyright © 2016年 yyt. All rights reserved.
//

#import "YYTLoadingPageAdManager.h"

@interface YYTLoadingPageAdManager()<GDTSplashAdDelegate, BUSplashAdDelegate>

@property (strong, nonatomic) GDTSplashAd *gdtSplash;

@property (strong, nonatomic) BUSplashAdView *buSplash;

@property (strong, nonatomic) UIView *adContainerView;

@end

@implementation YYTLoadingPageAdManager

+ (instancetype) sharedMe
{
    static YYTLoadingPageAdManager *_me;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        _me = [YYTLoadingPageAdManager new];
        _me.currentNetWork = YES;
    });
    return _me;
}

- (void) createAdContainerView
{
    if (!self.model.loadingAdContainerView) {
        self.adContainerView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        self.adContainerView.backgroundColor = [UIColor blackColor];
    } else {
        self.adContainerView = self.model.loadingAdContainerView;
    }
}


- (void) loadingPageAd
{
    if (self.userISVIP) {
        return;
    }
    
    //    [self createAdContainerView];
    //    [[UIApplication sharedApplication].keyWindow addSubview:_adContainerView];
    
    if (!self.currentSplashAdType) {
        self.currentSplashAdType = self.arrAdType.firstObject;
    }
    
    if (self.currentSplashAdType.intValue == YYTAdTypeTencent)
    {
        self.gdtSplash = [[GDTSplashAd alloc] initWithPlacementId:self.model.tencentLoadingPageID];
        self.gdtSplash.delegate = self;
        [self.gdtSplash loadAd];
        
        YYTLog(@"开屏-当前预加载的是：腾讯广告", nil);
        
    } else
    {
        CGRect frame = [UIScreen mainScreen].bounds;
        BUSplashAdView *splashView = [[BUSplashAdView alloc] initWithSlotID:self.model.bdLoadingPageID frame:frame];
        splashView.delegate = self;
        UIWindow *keyWindow = [UIApplication sharedApplication].windows.firstObject;
        [splashView loadAdData];
        [keyWindow.rootViewController.view addSubview:splashView];
        splashView.rootViewController = keyWindow.rootViewController;
        self.buSplash = splashView;
        
        YYTLog(@"开屏-当前预加载的是：穿山甲广告", nil);
    }
    
    [self performSelector:@selector(loadAdTimeout) withObject:nil afterDelay:10];
}
#pragma mark - tencent  delegate
/**
*  开屏广告素材加载成功
*/
- (void)splashAdDidLoad:(GDTSplashAd *)splashAd
{
    [self.gdtSplash showAdInWindow:[[[UIApplication sharedApplication] delegate] window] withBottomView:nil skipView:nil];
}

/**
 *  开屏广告成功展示
 */
-(void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd
{
    YYTLog(@"开屏-当前展示的是：腾讯广告", nil);
}

/**
 *  开屏广告展示失败
 */
-(void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error
{
    [self removeAllSplash];

    [NSNotificationCenter.defaultCenter postNotificationName:kLoadingPageAdWillFinishNotification object:nil userInfo:nil];

    [NSNotificationCenter.defaultCenter postNotificationName:kLoadingPageAdDidFinishNotification object:nil userInfo:nil];
}

/**
 *  应用进入后台时回调
 *  详解: 当点击下载应用时会调用系统程序打开，应用切换到后台
 */
- (void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd
{

}

/**
 *  开屏广告点击回调
 */
- (void)splashAdClicked:(GDTSplashAd *)splashAd
{

}

/**
 *  开屏广告将要关闭回调
 */
- (void)splashAdWillClosed:(GDTSplashAd *)splashAd
{
    [NSNotificationCenter.defaultCenter postNotificationName:kLoadingPageAdWillFinishNotification object:nil userInfo:nil];
}

/**
 *  开屏广告关闭回调
 */
- (void)splashAdClosed:(GDTSplashAd *)splashAd
{
    [self removeAllSplash];

    [NSNotificationCenter.defaultCenter postNotificationName:kLoadingPageAdDidFinishNotification object:nil userInfo:nil];
}

/**
 *  开屏广告点击以后即将弹出全屏广告页
 */
- (void)splashAdWillPresentFullScreenModal:(GDTSplashAd *)splashAd
{

}

/**
 *  开屏广告点击以后弹出全屏广告页
 */
- (void)splashAdDidPresentFullScreenModal:(GDTSplashAd *)splashAd
{

}

/**
 *  点击以后全屏广告页将要关闭
 */
- (void)splashAdWillDismissFullScreenModal:(GDTSplashAd *)splashAd
{

}

/**
 *  点击以后全屏广告页已经关闭
 */
- (void)splashAdDidDismissFullScreenModal:(GDTSplashAd *)splashAd
{

}

#pragma mark - BUSplashAdDelegate
/**
 This method is called when splash ad material failed to load.
 @param error : the reason of error
 
 */
- (void)splashAd:(BUSplashAdView *)splashAd didFailWithError:(NSError * _Nullable)error
{
    [self removeAllSplash];
    
    [NSNotificationCenter.defaultCenter postNotificationName:kLoadingPageAdWillFinishNotification object:nil userInfo:nil];
    
    [NSNotificationCenter.defaultCenter postNotificationName:kLoadingPageAdDidFinishNotification object:nil userInfo:nil];
}

- (void)splashAdWillVisible:(BUSplashAdView *)splashAd {
    YYTLog(@"开屏-当前展示的是：穿山甲广告", nil);
}

- (void)splashAdWillClose:(BUSplashAdView *)splashAd
{
    [NSNotificationCenter.defaultCenter postNotificationName:kLoadingPageAdWillFinishNotification object:nil userInfo:nil];
}

/**
 This method is called when splash ad is closed.
 */
- (void)splashAdDidClose:(BUSplashAdView *)splashAd
{
    [self removeAllSplash];
    
    [NSNotificationCenter.defaultCenter postNotificationName:kLoadingPageAdDidFinishNotification object:nil userInfo:nil];
}


- (void)loadAdTimeout
{
    [self removeAllSplash];
    
    [NSNotificationCenter.defaultCenter postNotificationName:kLoadingPageAdWillFinishNotification object:nil userInfo:nil];
    
    [NSNotificationCenter.defaultCenter postNotificationName:kLoadingPageAdDidFinishNotification object:nil userInfo:nil];
}

/**
 *  展示结束or展示失败后, 手动移除splash和delegate
 */
- (void) removeAllSplash
{
    if (self.gdtSplash) {
        self.gdtSplash.delegate = nil;
        self.gdtSplash = nil;
        [self.adContainerView removeFromSuperview];
        self.adContainerView = nil;
    }
    
    if (self.buSplash) {
        self.buSplash.delegate = nil;
        [self.buSplash removeFromSuperview];
        self.buSplash = nil;
        [self.adContainerView removeFromSuperview];
        self.adContainerView = nil;
    }
}


@end
