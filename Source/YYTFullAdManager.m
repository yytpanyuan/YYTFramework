//
//  YYTFullAdManager.m
//  2048
//
//  Created by yyt on 15/6/1.
//
//

#import "YYTFullAdManager.h"


@interface YYTFullAdManager() <GADInterstitialDelegate, BaiduMobAdInterstitialDelegate, GDTMobInterstitialDelegate>

@property (strong, nonatomic) GADInterstitial *googleFullAd;

@property (strong, nonatomic) BaiduMobAdInterstitial *baiduFullAd;

@property (strong, nonatomic) GDTMobInterstitial *tencentFullAd;


@end

@implementation YYTFullAdManager

+ (instancetype) sharedMe
{
    static YYTFullAdManager *_me;
    static dispatch_once_t once_t;
    dispatch_once(&once_t, ^{
        _me = [[YYTFullAdManager alloc] init];
        _me.currentNetWork = YES;
    });
    return _me;
}

- (void) createNewFullAd
{
    if (self.userISVIP) {
        return;
    }
    
    if (!self.currentFullAdType) {
        self.currentFullAdType = self.arrAdType.firstObject;
    }
    
    if (self.currentFullAdType.intValue == YYTAdTypeGoogle)
    {
        self.googleFullAd = [[GADInterstitial alloc] initWithAdUnitID:self.model.googleInsertPageID];
        self.googleFullAd.delegate = self;
        [self.googleFullAd loadRequest:[GADRequest request]];
        
    } else if (self.currentFullAdType.intValue == YYTAdTypeBaidu)
    {
        self.baiduFullAd = [[BaiduMobAdInterstitial alloc] init];
        self.baiduFullAd.delegate = self;
        self.baiduFullAd.AdUnitTag = self.model.baiduInsertPageID;
        self.baiduFullAd.interstitialType = BaiduMobAdViewTypeInterstitialOther;
        [self.baiduFullAd load];
    }  else if (self.currentFullAdType.intValue == YYTAdTypeTencent)
    {
        self.tencentFullAd = [[GDTMobInterstitial alloc] initWithAppId:self.model.tencentKey placementId:self.model.tencentInsertPageID];
        self.tencentFullAd.delegate = self;
        [self.tencentFullAd loadAd];
    }
    
}

- (void) insertFullAdNow
{
    if (self.userISVIP) {
        return;
    }
    if (self.currentFullAdType.intValue == YYTAdTypeGoogle)
    {
        if (self.googleFullAd.isReady && !self.googleFullAd.hasBeenUsed) {
            [self.googleFullAd presentFromRootViewController:self.model.appRootViewController];
        } else {
            [self changeFullAdType];
            [self createNewFullAd];
        }
    } else if (self.currentFullAdType.intValue == YYTAdTypeBaidu)
    {
        if (self.baiduFullAd.isReady){
            [self.baiduFullAd presentFromRootViewController:self.model.appRootViewController];
        } else {
            [self changeFullAdType];
            [self createNewFullAd];
        }
    } else if (self.currentFullAdType.intValue == YYTAdTypeTencent)
    {
        if (self.tencentFullAd.isReady){
            [self.tencentFullAd presentFromRootViewController:self.model.appRootViewController];
        } else {
            [self changeFullAdType];
            [self createNewFullAd];
        }
    }

}

- (void) networkStatusChanged:(NSNotification *) notification
{
    if ([self.reachability isReachable]) {
        if (!self.currentNetWork) {
            self.currentNetWork = YES;
            [self createNewFullAd];
        }
    } else {
        self.currentNetWork = NO;
    }
}

#pragma mark - Google GadInterstitialDelegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    
}
- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
    if (![self.reachability isReachable]) return;
    [self changeFullAdType];
    [self createNewFullAd];
}

- (void)interstitialWillPresentScreen:(GADInterstitial *)ad
{
    
}

- (void)interstitialWillDismissScreen:(GADInterstitial *)ad
{
    
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad
{
    [self createNewFullAd];
}

#pragma mark - baiduAD  delegate
- (NSString *)publisherId
{
    return  self.model.baiduKey;
}

/**
 *  广告预加载成功
 */
- (void)interstitialSuccessToLoadAd:(BaiduMobAdInterstitial *)interstitial
{
    
}

/**
 *  广告预加载失败
 */
- (void)interstitialFailToLoadAd:(BaiduMobAdInterstitial *)interstitial
{
    if (![self.reachability isReachable]) return;
    [self changeFullAdType];
    [self createNewFullAd];
}

/**
 *  广告展示成功
 */
- (void)interstitialSuccessPresentScreen:(BaiduMobAdInterstitial *)interstitial
{

}

/**
 *  广告展示失败
 */
- (void)interstitialFailPresentScreen:(BaiduMobAdInterstitial *)interstitial withError:(BaiduMobFailReason) reason
{
    if (![self.reachability isReachable]) return;
    [self changeFullAdType];
    [self createNewFullAd];
}

#pragma mark - TencentAD delegate

- (void)interstitialFailToLoadAd:(GDTMobInterstitial *)interstitial error:(NSError *)error
{
    [self changeFullAdType];
    [self createNewFullAd];
}

/**
 *  插屏广告点击回调
 */
- (void)interstitialClicked:(GDTMobInterstitial *)interstitial
{
    
}

@end
