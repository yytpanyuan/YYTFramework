//
//  YYTLoadingPageAdManager.m
//  YYTFramework
//
//  Created by yyt on 16/9/21.
//  Copyright © 2016年 yyt. All rights reserved.
//

#import "YYTLoadingPageAdManager.h"

@interface YYTLoadingPageAdManager()<GDTSplashAdDelegate>

@property (strong, nonatomic) GDTSplashAd *splash;

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
    
    self.splash = [[GDTSplashAd alloc] initWithAppkey:self.model.tencentKey placementId:self.model.tencentLoadingPageID];
    self.splash.delegate = self;
    [self.splash loadAdAndShowInWindow:[UIApplication sharedApplication].keyWindow];
    
    [self performSelector:@selector(removeSplash) withObject:nil afterDelay:10];
}
#pragma mark - tencent  delegate

/**
 *  开屏广告成功展示
 */
-(void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd
{
    
}

/**
 *  开屏广告展示失败
 */
-(void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error
{
    [self removeSplash];
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
    
}

/**
 *  开屏广告关闭回调
 */
- (void)splashAdClosed:(GDTSplashAd *)splashAd
{
    [self removeSplash];
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

/**
 *  展示结束or展示失败后, 手动移除splash和delegate
 */
- (void) removeSplash
{
    if (self.splash) {
        self.splash.delegate = nil;
        self.splash = nil;
        [self.adContainerView removeFromSuperview];
        self.adContainerView = nil;
    }
}


@end
