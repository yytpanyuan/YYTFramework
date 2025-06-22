//
//  YYTInfoFlowAdManager.m
//  YYTFramework
//
//  Created by yyt on 2022/4/3.
//  Copyright © 2022 yyt. All rights reserved.
//

#import "YYTInfoFlowAdManager.h"
#import "GDTMobSDK/GDTNativeExpressAd.h"
#import "GDTMobSDK/GDTNativeExpressAdView.h"
#import "GADTMediumTemplateView.h"
#import <Masonry.h>

#define kGoogleSmallAdViewRatio  (375/104.0f)
#define kGoogleMediumAdViewRatio  (355/351.0f)

@interface YYTInfoFlowAdManager () <BUNativeExpressAdViewDelegate, GDTNativeExpressAdDelegete, GADAdLoaderDelegate, GADNativeAdLoaderDelegate>


@property(nonatomic, strong) YYTInfoFlowAdView *adView;
// douyin ad
@property(nonatomic, strong) BUNativeExpressAdView *douYinAdView;
@property(nonatomic, strong) BUNativeExpressAdManager *douYinAdManager;
// tencent ad
@property (nonatomic, strong) GDTNativeExpressAd *tencentAd;
@property (nonatomic, strong) GDTNativeExpressAdView *tencentAdView;
// google ad
@property (nonatomic, strong) GADAdLoader *googleAdLoader;
@property (nonatomic, strong) GADTMediumTemplateView *googleAdView;

@end

@implementation YYTInfoFlowAdManager

+ (instancetype) sharedMe
{
    static YYTInfoFlowAdManager *_me;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        _me = [self new];
        _me.currentNetWork = YES;
        _me.isRandomShowAd = YES;
    });
    return _me;
}


- (YYTInfoFlowAdView *)fetchInfoFlowAdViewWithDelegate:(id<YYTInfoFlowAdViewDelegate>)delegate {
    YYTInfoFlowAdView *adView = [self createAdView];
    adView.delegate = delegate;
    self.adView = adView;
    
    [self createNewAd];
    
    return adView;
}

- (void) createNewAd
{
    [self removeAllAd];
    
    if (self.userISVIP) {
        return;
    }
    
    if (!self.currentInfoFlowAdType) {
        self.currentInfoFlowAdType = self.arrAdType.firstObject;
    } else {
        if (self.isRandomShowAd) {
            [self changeInfoFlowAdType];
        }
    }
    
    CGFloat adWidth = [self.adView.delegate adViewWidth];
    if (self.currentInfoFlowAdType.intValue == YYTAdTypeGoogle)
    {
        UIViewController *rootVC = [self.adView.delegate rootViewControllerForAdView:self.adView];
        GADMultipleAdsAdLoaderOptions *multipleAdsOptions = [[GADMultipleAdsAdLoaderOptions alloc] init];
        multipleAdsOptions.numberOfAds = 1;
        self.googleAdLoader = [[GADAdLoader alloc]
              initWithAdUnitID:self.model.googleInfoFlowID
            rootViewController:rootVC
                       adTypes:@[ GADAdLoaderAdTypeNative ]
                       options:@[multipleAdsOptions]];
        self.googleAdLoader.delegate = self;
        [self.googleAdLoader loadRequest:[GADRequest request]];

        YYTLog(@"信息流-当前加载的是：谷歌广告", nil);
    } else if (self.currentInfoFlowAdType.intValue == YYTAdTypeTencent)
    {
        self.tencentAd = [[GDTNativeExpressAd alloc] initWithPlacementId:self.model.tencentInfoFlowID adSize:CGSizeMake(adWidth, 0)];
           self.tencentAd.delegate = self;
           // 配置视频播放属性
           self.tencentAd.videoAutoPlayOnWWAN = YES;
           self.tencentAd.videoMuted = YES;
           [self.tencentAd loadAd:1];
        
        YYTLog(@"信息流-当前加载的是：腾讯广告", nil);
    } else
    {
        CGFloat width = [self.adView.delegate adViewWidth];
        self.douYinAdManager.adSize = CGSizeMake(width > 0 ? width : UIScreen.mainScreen.bounds.size.width, 0);
        [self.douYinAdManager loadAdDataWithCount:1];
        YYTLog(@"信息流-当前加载的是：穿山甲广告", nil);
    }
    
}

#pragma mark - BUNativeExpressAdViewDelegate
- (void)nativeExpressAdSuccessToLoad:(BUNativeExpressAdManager *)nativeExpressAdManager views:(NSArray<__kindof BUNativeExpressAdView *> *)views {
    // fix 穿山甲和腾讯广告回调相同的case
    if (views.count == 0) {
        [self changeAndLoadNewAd];
        return;
    }
    
    if ([nativeExpressAdManager isKindOfClass:BUNativeExpressAdManager.class]) {
        if (views.count) {
            UIViewController *rootVC = [self.adView.delegate rootViewControllerForAdView:self.adView];
            [views enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                BUNativeExpressAdView *expressView = (BUNativeExpressAdView *)obj;
                expressView.rootViewController = rootVC;
                // important: 此处会进行WKWebview的渲染，建议一次最多预加载三个广告，如果超过3个会很大概率导致WKWebview渲染失败。
                [expressView render];
                self.douYinAdView = expressView;
                *stop = YES;
            }];
            
            for (UIView * v  in self.adView.subviews) {
                [v removeFromSuperview];
            }
//            self.douYinAdView.backgroundColor = [UIColor clearColor];
            [self.adView addSubview:self.douYinAdView];
        }
    } else if ([nativeExpressAdManager isKindOfClass:GDTNativeExpressAd.class]) {
        [self fixTencentNativeExpressAdSuccessToLoad:(GDTNativeExpressAd*)nativeExpressAdManager views:(NSArray<__kindof
                                                                                                        GDTNativeExpressAdView *> *)views];
    }
}

- (void)nativeExpressAdViewRenderSuccess:(BUNativeExpressAdView *)nativeExpressAdView {
    
    if ([nativeExpressAdView isKindOfClass:BUNativeExpressAdView.class]) {
        [self.douYinAdView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        YYTLog(@"信息流-穿山甲-Frame：%@", NSStringFromCGRect(nativeExpressAdView.frame));
        
        if (self.adView.delegate && [self.adView.delegate respondsToSelector:@selector(adView:updateFrame:)]) {
            [self.adView.delegate adView:self.adView updateFrame:nativeExpressAdView.frame];
        }
    } else if ([nativeExpressAdView isKindOfClass:GDTNativeExpressAdView.class]) {
        [self fixTencentNativeExpressAdViewRenderSuccess:(GDTNativeExpressAdView *)nativeExpressAdView];
    }
}

- (void)nativeExpressAdFailToLoad:(BUNativeExpressAdManager *)nativeExpressAdManager error:(NSError *_Nullable)error {
    
    if ([nativeExpressAdManager isKindOfClass:BUNativeExpressAdManager.class]) {
        YYTLog(@"%@", @"信息流-穿山甲广告加载出错..");
        
        [self changeAndLoadNewAd];
    } else if ([nativeExpressAdManager isKindOfClass:GDTNativeExpressAd.class]) {
        [self fixTencentNativeExpressAdFailToLoad:(GDTNativeExpressAd *)nativeExpressAdManager error:error];
    }
}

- (void)nativeExpressAdViewRenderFail:(BUNativeExpressAdView *)nativeExpressAdView error:(NSError *_Nullable)error {
    YYTLog(@"%@", @"信息流-穿山甲广告渲染出错..");
    [self changeAndLoadNewAd];
}

#pragma mark - GDTNativeExpressAdDelegete
- (void)fixTencentNativeExpressAdSuccessToLoad:(GDTNativeExpressAd *)nativeExpressAd views:(NSArray<__kindof
GDTNativeExpressAdView *> *)views
{
    UIViewController *vc = [self.adView.delegate rootViewControllerForAdView:self.adView];
    [views enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GDTNativeExpressAdView *expressView = (GDTNativeExpressAdView *)obj;
        expressView.controller = vc;
        if ([expressView isAdValid]) {
            [expressView render];
            self.tencentAdView = expressView;
            *stop = YES;
        } else {
            [self changeAndLoadNewAd];
            *stop = YES;
        }
    }];
    
    for (UIView * v  in self.adView.subviews) {
        [v removeFromSuperview];
    }
//    self.tencentAdView.backgroundColor = [UIColor clearColor];
    [self.adView addSubview:self.tencentAdView];
}

- (void)fixTencentNativeExpressAdViewRenderSuccess:(GDTNativeExpressAdView *)nativeExpressAdView {
    YYTLog(@"信息流-腾讯-Frame：%@", NSStringFromCGRect(nativeExpressAdView.frame));
    
    if (self.adView.delegate && [self.adView.delegate respondsToSelector:@selector(adView:updateFrame:)]) {
        [self.adView.delegate adView:self.adView updateFrame:nativeExpressAdView.frame];
    }
}

- (void)fixTencentNativeExpressAdFailToLoad:(GDTNativeExpressAd *)nativeExpressAd error:(NSError *)error {
    YYTLog(@"%@", @"信息流-腾讯广告加载出错..");
    
    [self changeAndLoadNewAd];
}

- (void)nativeExpressAdViewRenderFail:(GDTNativeExpressAdView *)nativeExpressAdView {
    YYTLog(@"%@", @"信息流-腾讯广告渲染出错..");
    
    [self changeAndLoadNewAd];
}

#pragma mark - GADAdLoaderDelegate
- (void)adLoader:(nonnull GADAdLoader *)adLoader didFailToReceiveAdWithError:(nonnull NSError *)error {
    YYTLog(@"%@", @"信息流-谷歌广告加载出错..");
}

- (void)adLoader:(GADAdLoader *)adLoader didReceiveNativeAd:(GADNativeAd *)nativeAd {
    
    self.googleAdView = [NSBundle.mainBundle loadNibNamed:self.googleIsSmallAd ? @"GADTSmallTemplateView" : @"GADTMediumTemplateView" owner:self options:nil].firstObject;
    [self.adView addSubview:self.googleAdView];
    self.googleAdView.nativeAd = nativeAd;
    
    [self.googleAdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    YYTLog(@"信息流-谷歌-Frame：%@", NSStringFromCGRect(self.googleAdView.frame));
    
//    [self.googleAdView addHorizontalConstraintsToSuperviewWidth];
    
    if (self.adView.delegate && [self.adView.delegate respondsToSelector:@selector(adView:updateFrame:)]) {
        CGFloat  width = self.adView.frame.size.width;
        CGFloat height = self.googleIsSmallAd ? width/kGoogleSmallAdViewRatio : width/kGoogleMediumAdViewRatio;
        [self.adView.delegate adView:self.adView updateFrame:CGRectMake(0, 0, width, height)];
    }
}

- (void)adLoaderDidFinishLoading:(nonnull GADAdLoader *)adLoader {
    YYTLog(@"%@", @"信息流-谷歌广告加载完成..");
}

- (void) changeAndLoadNewAd
{
    [self changeInfoFlowAdType];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self createNewAd];
    });
}

- (YYTInfoFlowAdView *)createAdView {
    YYTInfoFlowAdView *view = [YYTInfoFlowAdView new];
    return view;
}

- (void)removeAllAd {
    
    if (_douYinAdView) {
        [_douYinAdView removeFromSuperview];
        _douYinAdView = nil;
    }
    
    if (_tencentAd) {
        _tencentAd.delegate = nil;
        _tencentAd = nil;
    }
    if (_tencentAdView) {
        [_tencentAdView removeFromSuperview];
        _tencentAdView = nil;
    }
    
    if (_googleAdLoader) {
//        _googleAdLoader.delegate = nil;
//        _googleAdLoader = nil;
    }
    if (_googleAdView) {
        [_googleAdView removeFromSuperview];
        _googleAdView = nil;
    }
}

- (BUNativeExpressAdManager *)douYinAdManager {
    if (!_douYinAdManager) {
        CGFloat width = [self.adView.delegate adViewWidth];
        BUAdSlot *slot = [[BUAdSlot alloc] init];
        slot.ID = self.model.bdInfoFlowID;
        slot.AdType = BUAdSlotAdTypeFeed;
        BUSize *imgSize = [BUSize sizeBy:BUProposalSize_Feed690_388];
        slot.imgSize = imgSize;
        slot.position = BUAdSlotPositionFeed;
        _douYinAdManager = [[BUNativeExpressAdManager alloc] initWithSlot:slot adSize:CGSizeMake(width > 0 ? width : UIScreen.mainScreen.bounds.size.width, 0)];
        _douYinAdManager.delegate = self;
    }
    return _douYinAdManager;
}

@end
