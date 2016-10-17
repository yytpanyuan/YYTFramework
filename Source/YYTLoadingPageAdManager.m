//
//  YYTLoadingPageAdManager.m
//  YYTFramework
//
//  Created by yyt on 16/9/21.
//  Copyright © 2016年 yyt. All rights reserved.
//

#import "YYTLoadingPageAdManager.h"

@interface YYTLoadingPageAdManager()<BaiduMobAdSplashDelegate>

@property (strong, nonatomic) BaiduMobAdSplash *splash;

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
    [self createAdContainerView];
    [[UIApplication sharedApplication].keyWindow addSubview:_adContainerView];
    
    self.splash = [[BaiduMobAdSplash alloc] init];
    self.splash.delegate = self;
    self.splash.AdUnitTag = self.model.baiduLoadingPageID;
    self.splash.canSplashClick = YES;
    [self.splash loadAndDisplayUsingContainerView:_adContainerView];
    
    [self performSelector:@selector(removeSplash) withObject:nil afterDelay:10];
}
#pragma mark - baiduAD  delegate
- (NSString *)publisherId
{
    return  self.model.baiduKey;
}

- (void)splashSuccessPresentScreen:(BaiduMobAdSplash *)splash
{
    
}

- (void)splashlFailPresentScreen:(BaiduMobAdSplash *)splash withError:(BaiduMobFailReason) reason
{
    [self removeSplash];
}

- (void)splashDidDismissScreen:(BaiduMobAdSplash *)splash
{
    [self removeSplash];
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
