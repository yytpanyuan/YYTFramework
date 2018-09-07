//
//  YYTAdManager.m
//  PopStar
//
//  Created by yyt on 16/8/15.
//
//

#import "YYTAdManager.h"

#define isIphoneX_ (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(375, 812)))

@interface YYTAdManager ()<GADBannerViewDelegate, BaiduMobAdViewDelegate, GDTMobBannerViewDelegate>

@property (strong, nonatomic) GADBannerView *googleBannerView;
@property (strong, nonatomic) BaiduMobAdView *baiduBannerView;
@property (strong, nonatomic) GDTMobBannerView *tencentBannerView;

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
        
    } else if (self.currentAdType.intValue == YYTAdTypeBaidu)
    {
        [self startBaiduBannerAd];
    } else if (self.currentAdType.intValue == YYTAdTypeTencent)
    {
        [self startTencentBannerAd];
    }
}

- (void) startGoogleBannerAd
{
    [self removeAllAds];
    
    self.googleBannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    _googleBannerView.delegate = self;
    _googleBannerView.adUnitID = self.model.googleBannerID;
    _googleBannerView.backgroundColor = [UIColor clearColor];
    _googleBannerView.rootViewController = self.model.appRootViewController;
    CGRect rect = [UIScreen mainScreen].bounds;
    CGFloat offset = 0;
    if (isIphoneX_) {
        offset = -34;
    }
    _googleBannerView.frame = CGRectMake(0, rect.size.height-self.model.bannerHeight-self.model.tabBarHeight+offset, rect.size.width, self.model.bannerHeight);
    _googleBannerView.hidden = NO;
    GADRequest *reuest = [GADRequest request];
    //    reuest.testDevices = @[ @"02f1340bbcbae2a11d87d89b92524829" ];
    [_googleBannerView loadRequest:reuest];
    [self.model.appRootViewController.view addSubview:_googleBannerView];
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
    _baiduBannerView.frame = CGRectMake(0, rect.size.height-self.model.bannerHeight-self.model.tabBarHeight+offset, rect.size.width, self.model.bannerHeight);
    [self.model.appRootViewController.view addSubview:_baiduBannerView];
    _baiduBannerView.delegate = self;
    [_baiduBannerView start];
}

- (void) startTencentBannerAd
{
    [self removeAllAds];
    CGRect rect = [UIScreen mainScreen].bounds;
    CGFloat offset = 0;
    if (isIphoneX_) {
        offset = -34;
    }
    self.tencentBannerView = [[GDTMobBannerView alloc] initWithFrame:CGRectMake(0, rect.size.height-self.model.bannerHeight-self.model.tabBarHeight+offset, rect.size.width, self.model.bannerHeight) appId:self.model.tencentKey placementId:self.model.tencentBannerID];
    _tencentBannerView.delegate = self;
    _tencentBannerView.currentViewController = self.model.appRootViewController;
    _tencentBannerView.interval = 30;
    [self.model.appRootViewController.view addSubview:_tencentBannerView];
    [_tencentBannerView loadAdAndShow];
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
- (void) adViewDidReceiveAd:(GADBannerView *)view
{
    
}

- (void) adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error
{
    if (self.arrAdType.count == 0) {
        NSLog(@"not set ad source!");
        return;
    }
    NSInteger index = [self.arrAdType indexOfObject:self.currentAdType];
    index++;
    if (index>=self.arrAdType.count) {
        index = 0;
    }
    self.currentAdType = [self.arrAdType objectAtIndex:index];
    [self createNewBannerAd];
}

- (void) adViewWillLeaveApplication:(GADBannerView *)adView
{
    
}

#pragma mark - baiduAD  delegate
- (NSString *)publisherId
{
    return  self.model.baiduKey;
}

- (void)failedDisplayAd:(BaiduMobFailReason)reason
{
    [self changeBannerAdType];
    
    [self createNewBannerAd];
}

#pragma mark - tencentAD delegate
- (void)bannerViewFailToReceived:(NSError *)error
{
    [self changeBannerAdType];
    
    [self createNewBannerAd];
}

- (void) removeAllAds
{
    _googleBannerView.delegate = nil;
    [self.googleBannerView removeFromSuperview];
    self.googleBannerView = nil;
    
    _baiduBannerView.delegate = nil;
    [self.baiduBannerView removeFromSuperview];
    self.baiduBannerView = nil;
}


@end

