//
//  YYTLoadingPageAdManager.m
//  YYTFramework
//
//  Created by yyt on 16/9/21.
//  Copyright © 2016年 yyt. All rights reserved.
//

#import "YYTLoadingPageAdManager.h"

@interface YYTLoadingPageAdManager()<GDTSplashAdDelegate, BUSplashAdDelegate, GADFullScreenContentDelegate>

@property (strong, nonatomic) GDTSplashAd *gdtSplash;

@property (strong, nonatomic) BUSplashAdView *buSplash;

@property(strong, nonatomic) GADAppOpenAd *googleSplash;

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
        
    }
    else if(self.currentSplashAdType.intValue == YYTAdTypeGoogle)
    {
        [GADAppOpenAd loadWithAdUnitID:self.model.googleLoadingPageID
                                 request:[GADRequest request]
                             orientation:UIInterfaceOrientationPortrait
                       completionHandler:^(GADAppOpenAd *_Nullable appOpenAd, NSError *_Nullable error) {
                            if (error) {
                                YYTLog(@"开屏-加载出错：谷歌广告", nil);
                                if (![self changeSplashAdType]) {
                                    [self removeAllSplash];
                                    [NSNotificationCenter.defaultCenter postNotificationName:kLoadingPageAdWillFinishNotification object:nil userInfo:nil];
                                    [NSNotificationCenter.defaultCenter postNotificationName:kLoadingPageAdDidFinishNotification object:nil userInfo:nil];
                                } else {
                                    [self loadingPageAd];
                                }
                                return;
                            }
                            self.googleSplash = appOpenAd;
                            self.googleSplash.fullScreenContentDelegate = self;
                            [self.googleSplash presentFromRootViewController:self.model.appRootViewController];
                       }];
        
        YYTLog(@"开屏-当前预加载的是：谷歌广告", nil);
    }
    else
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
    YYTLog(@"开屏-加载出错：腾讯广告", nil);
    
    if (![self changeSplashAdType]) {
        [self removeAllSplash];
        [NSNotificationCenter.defaultCenter postNotificationName:kLoadingPageAdWillFinishNotification object:nil userInfo:nil];
        [NSNotificationCenter.defaultCenter postNotificationName:kLoadingPageAdDidFinishNotification object:nil userInfo:nil];
    } else {
        [self loadingPageAd];
    }
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
    YYTLog(@"开屏-展示完成：腾讯广告", nil);
    [self removeAllSplash];
    [NSNotificationCenter.defaultCenter postNotificationName:kLoadingPageAdDidFinishNotification object:nil userInfo:nil];
}

#pragma mark - BUSplashAdDelegate
/**
 This method is called when splash ad material failed to load.
 @param error : the reason of error
 
 */
- (void)splashAd:(BUSplashAdView *)splashAd didFailWithError:(NSError * _Nullable)error
{
    YYTLog(@"开屏-加载出错：穿山甲广告", nil);
    if (![self changeSplashAdType]) {
        [self removeAllSplash];
        [NSNotificationCenter.defaultCenter postNotificationName:kLoadingPageAdWillFinishNotification object:nil userInfo:nil];
        [NSNotificationCenter.defaultCenter postNotificationName:kLoadingPageAdDidFinishNotification object:nil userInfo:nil];
    } else {
        [self loadingPageAd];
    }
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
    YYTLog(@"开屏-展示完成：穿山甲广告", nil);
    [self removeAllSplash];
    [NSNotificationCenter.defaultCenter postNotificationName:kLoadingPageAdDidFinishNotification object:nil userInfo:nil];
}

#pragma mark - GADFullScreenContentDelegate
- (void)ad:(nonnull id<GADFullScreenPresentingAd>)ad didFailToPresentFullScreenContentWithError:(nonnull NSError *)error {
    YYTLog(@"开屏-加载出错：谷歌广告", nil);
    if (![self changeSplashAdType]) {
        [self removeAllSplash];
        [NSNotificationCenter.defaultCenter postNotificationName:kLoadingPageAdWillFinishNotification object:nil userInfo:nil];
        [NSNotificationCenter.defaultCenter postNotificationName:kLoadingPageAdDidFinishNotification object:nil userInfo:nil];
    } else {
        [self loadingPageAd];
    }

}

- (void)adDidPresentFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    YYTLog(@"开屏-当前展示的是：谷歌广告", nil);
}

- (void)adWillDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    [NSNotificationCenter.defaultCenter postNotificationName:kLoadingPageAdWillFinishNotification object:nil userInfo:nil];
}

- (void)adDidDismissFullScreenContent:(nonnull id<GADFullScreenPresentingAd>)ad {
    YYTLog(@"开屏-展示完成：谷歌广告", nil);
    [self removeAllSplash];
    [NSNotificationCenter.defaultCenter postNotificationName:kLoadingPageAdDidFinishNotification object:nil userInfo:nil];
}

- (void)loadAdTimeout
{
    YYTLog(@"开屏-超时关闭", nil);
    if (!self.googleSplash) {
        [self removeAllSplash];
        [NSNotificationCenter.defaultCenter postNotificationName:kLoadingPageAdWillFinishNotification object:nil userInfo:nil];
        [NSNotificationCenter.defaultCenter postNotificationName:kLoadingPageAdDidFinishNotification object:nil userInfo:nil];
    }
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
    
    if (self.googleSplash) {
        self.googleSplash.fullScreenContentDelegate = nil;
        self.googleSplash = nil;
        [self.adContainerView removeFromSuperview];
        self.adContainerView = nil;
    }
}


@end
