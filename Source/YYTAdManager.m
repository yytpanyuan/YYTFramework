//
//  YYTAdManager.m
//  PopStar
//
//  Created by yyt on 16/8/15.
//
//

#import "YYTAdManager.h"


@interface YYTAdManager ()<GADBannerViewDelegate, BaiduMobAdViewDelegate, GDTUnifiedBannerViewDelegate, BUNativeExpressBannerViewDelegate>

@property (strong, nonatomic) GADBannerView *googleBannerView;

@property (strong, nonatomic) BaiduMobAdView *baiduBannerView;

@property (strong, nonatomic) GDTUnifiedBannerView *tencentBannerView;

@property (strong, nonatomic) BUNativeExpressBannerView *bdBannerView;

@end

@implementation YYTAdManager

+ (instancetype) sharedMe
{
    static YYTAdManager *_me;
    
    static dispatch_once_t once_t;
    
    dispatch_once(&once_t, ^{
        _me = [YYTAdManager new];
        _me.currentNetWork = YES;
    });
    return _me;
}

- (void)setUserISVIP:(BOOL)userISVIP
{
    [super setUserISVIP:userISVIP];
    [self removeAllAds];
}

- (void) startBannerAd
{
    if (self.userISVIP) {
        return;
    }
    [self createNewBannerAd];
}

- (void) stopBannerAd
{
    [self removeAllAds];
}

- (void) createNewBannerAd
{
    if (!self.currentAdType) {
        
        self.currentAdType = self.arrAdType.firstObject;
    }
    if (self.currentAdType.intValue == YYTAdTypeGoogle)
    {
        [self startGoogleBannerAd];
        
        YYTLog(@"Banner当前展示的是：谷歌广告", nil);
        
    } else if (self.currentAdType.intValue == YYTAdTypeBaidu)
    {
        [self startBaiduBannerAd];
        
        YYTLog(@"Banner当前展示的是：百度广告", nil);
    } else if (self.currentAdType.intValue == YYTAdTypeTencent)
    {
        [self startTencentBannerAd];
        
        YYTLog(@"Banner当前展示的是：腾讯广告", nil);
    } else if (self.currentAdType.intValue == YYTAdTypeByteDance)
    {
        [self startBDBannerAd];
        
        YYTLog(@"Banner当前展示的是：抖音广告", nil);
    }
}

- (void) startGoogleBannerAd
{
    [self removeAllAds];
    
    CGRect frame = UIScreen.mainScreen.bounds;
    CGFloat viewWidth = frame.size.width;
    GADAdSize adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth);
    self.model.bannerCurrentHeight = adSize.size.height;
    
    self.googleBannerView = [[GADBannerView alloc] initWithAdSize:adSize];
    _googleBannerView.delegate = self;
    _googleBannerView.adUnitID = self.model.googleBannerID;
    _googleBannerView.backgroundColor = [UIColor clearColor];
    _googleBannerView.rootViewController = self.model.appRootViewController;
    CGRect rect = [UIScreen mainScreen].bounds;
    CGFloat offset = 0;
    if (isIphoneX_) {
        offset = -34;
    }
    _googleBannerView.frame = CGRectMake(0, rect.size.height-self.model.bannerCurrentHeight-self.model.tabBarHeight+offset, rect.size.width, self.model.bannerCurrentHeight);
    _googleBannerView.hidden = NO;
    GADRequest *reuest = [GADRequest request];
    //    reuest.testDevices = @[ @"02f1340bbcbae2a11d87d89b92524829" ];
    [_googleBannerView loadRequest:reuest];
    [self.model.appRootViewController.view addSubview:_googleBannerView];
    
    [NSNotificationCenter.defaultCenter postNotificationName:kADBannerHeightChangedNotification object:@(self.model.bannerCurrentHeight)];
}

- (void) startBaiduBannerAd
{
    [self removeAllAds];
    
    self.baiduBannerView = [[BaiduMobAdView alloc] init];
    _baiduBannerView.backgroundColor = [UIColor clearColor];
    _baiduBannerView.AdUnitTag = self.model.baiduBannerID;
    _baiduBannerView.AdType = BaiduMobAdViewTypeBanner;
    CGRect rect = [UIScreen mainScreen].bounds;
    CGFloat offset = 0;
    if (isIphoneX_) {
        offset = -34;
    }
    
    self.model.bannerCurrentHeight = self.model.bannerHeight;
    _baiduBannerView.frame = CGRectMake(0, rect.size.height-self.model.bannerCurrentHeight-self.model.tabBarHeight+offset, rect.size.width, self.model.bannerCurrentHeight);
    [self.model.appRootViewController.view addSubview:_baiduBannerView];
    _baiduBannerView.delegate = self;
    [_baiduBannerView start];
    
    [NSNotificationCenter.defaultCenter postNotificationName:kADBannerHeightChangedNotification object:@(self.model.bannerCurrentHeight)];
}

- (void) startTencentBannerAd
{
    [self removeAllAds];
    
    CGRect rect = [UIScreen mainScreen].bounds;
    CGFloat offset = 0;
    if (isIphoneX_) {
        offset = -34;
    }
    self.model.bannerCurrentHeight = (int)(rect.size.width / 6.4f);
    CGRect frame = CGRectMake(0, rect.size.height-self.model.bannerCurrentHeight-self.model.tabBarHeight+offset, rect.size.width, self.model.bannerCurrentHeight);
    _tencentBannerView = [[GDTUnifiedBannerView alloc] initWithFrame:frame placementId:self.model.tencentBannerID viewController:self.model.appRootViewController];
    _tencentBannerView.delegate = self;
    [self.model.appRootViewController.view addSubview:_tencentBannerView];
    [_tencentBannerView loadAdAndShow];
    
    [NSNotificationCenter.defaultCenter postNotificationName:kADBannerHeightChangedNotification object:@(self.model.bannerCurrentHeight)];
}

- (void) startBDBannerAd
{
    [self removeAllAds];
    
    CGRect rect = [UIScreen mainScreen].bounds;
    CGFloat offset = 0;
    if (isIphoneX_) {
        offset = -34;
    }
    CGFloat bannerHeight = (int)(rect.size.width*90 / 600);
    self.model.bannerCurrentHeight = bannerHeight;
    
    CGSize size = CGSizeMake(rect.size.width, self.model.bannerCurrentHeight);
    
    _bdBannerView = [[BUNativeExpressBannerView alloc] initWithSlotID:self.model.bdBannerID rootViewController:self.model.appRootViewController adSize:size interval:45];
    CGRect frame = CGRectMake(0, rect.size.height-self.model.bannerCurrentHeight-self.model.tabBarHeight+offset, rect.size.width, self.model.bannerCurrentHeight);
    _bdBannerView.frame = frame;
    _bdBannerView.delegate = self;
    [self.model.appRootViewController.view addSubview:_bdBannerView];
    [_bdBannerView loadAdData];
    
    [NSNotificationCenter.defaultCenter postNotificationName:kADBannerHeightChangedNotification object:@(self.model.bannerCurrentHeight)];
}

- (void) networkStatusChanged:(NSNotification *) notification
{
    if ([self.reachability isReachable]) {
        if (!self.currentNetWork) {
            self.currentNetWork = YES;
            [self createNewBannerAd];
        }
    } else {
        self.currentNetWork = NO;
    }
}

#pragma mark - googleAD  delegate
- (void)bannerViewDidReceiveAd:(nonnull GADBannerView *)bannerView {
    
}

- (void)bannerView:(nonnull GADBannerView *)bannerView didFailToReceiveAdWithError:(nonnull NSError *)error {
    [self changeAndLoadNewAd];
}

- (void)bannerViewDidDismissScreen:(nonnull GADBannerView *)bannerView {
    
}

#pragma mark - baiduAD  delegate
- (NSString *)publisherId
{
    return  self.model.baiduKey;
}

- (void)failedDisplayAd:(BaiduMobFailReason)reason
{
    [self changeAndLoadNewAd];
}

#pragma mark - tencentAD delegate
- (void)unifiedBannerViewFailedToLoad:(GDTUnifiedBannerView *)unifiedBannerView error:(NSError *)error
 {
     [self changeAndLoadNewAd];
 }

#pragma mark - BUNativeExpressBannerViewDelegate
- (void)nativeExpressBannerAdViewDidLoad:(BUNativeExpressBannerView *)bannerAdView
{
    
}

- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView didLoadFailWithError:(NSError *_Nullable)error
{
    [self changeAndLoadNewAd];
}


- (void)nativeExpressBannerAdViewRenderSuccess:(BUNativeExpressBannerView *)bannerAdView
{
    
}

- (void)nativeExpressBannerAdViewRenderFail:(BUNativeExpressBannerView *)bannerAdView error:(NSError * __nullable)error
{
    
}

- (void)nativeExpressBannerAdViewDidClick:(BUNativeExpressBannerView *)bannerAdView
{
    
}


- (void)nativeExpressBannerAdView:(BUNativeExpressBannerView *)bannerAdView dislikeWithReason:(NSArray<BUDislikeWords *> *_Nullable)filterwords
{
    
}

- (void)nativeExpressBannerAdViewDidCloseOtherController:(BUNativeExpressBannerView *)bannerAdView interactionType:(BUInteractionType)interactionType
{
    
}


- (void) changeAndLoadNewAd
{
    [self changeBannerAdType];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self createNewBannerAd];
    });
}

- (void) removeAllAds
{
    _googleBannerView.delegate = nil;
    [self.googleBannerView removeFromSuperview];
    self.googleBannerView = nil;
    
    _baiduBannerView.delegate = nil;
    [self.baiduBannerView removeFromSuperview];
    self.baiduBannerView = nil;
    
    _tencentBannerView.delegate = nil;
    [self.tencentBannerView removeFromSuperview];
    self.tencentBannerView = nil;
    
    _bdBannerView.delegate = nil;
    [self.bdBannerView removeFromSuperview];
    self.bdBannerView = nil;
}


@end

