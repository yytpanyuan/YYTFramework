//
//  YYTAdManager.m
//  PopStar
//
//  Created by yyt on 16/8/15.
//
//

#import "YYTAdManager.h"

@interface YYTAdManager ()<GADBannerViewDelegate, BaiduMobAdViewDelegate>

@property (strong, nonatomic) GADBannerView *googleBannerView;
@property (strong, nonatomic) BaiduMobAdView *baiduBannerView;

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

- (void) startBannerAd
{
    [self createNewBannerAd];
}

- (void) stopBannerAd
{
    [self removeAllAds];
}

- (void) createNewBannerAd
{
    if (self.AdType == YYTAdTypeGoogle)
    {
        [self startGoogleBannerAd];
        
    } else if (self.AdType == YYTAdTypeBaidu)
    {
        [self startBaiduBannerAd];
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
    _googleBannerView.frame = CGRectMake(0, rect.size.height-self.model.bannerHeight-self.model.tabBarHeight, rect.size.width, self.model.bannerHeight);
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
    _baiduBannerView.frame = CGRectMake(0, rect.size.height-self.model.bannerHeight-self.model.tabBarHeight, rect.size.width, self.model.bannerHeight);
    [self.model.appRootViewController.view addSubview:_baiduBannerView];
    _baiduBannerView.delegate = self;
    [_baiduBannerView start];
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
    self.AdType = YYTAdTypeBaidu;
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
    self.AdType = YYTAdTypeGoogle;
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
