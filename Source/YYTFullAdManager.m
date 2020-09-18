//
//  YYTFullAdManager.m
//  2048
//
//  Created by yyt on 15/6/1.
//
//

#import "YYTFullAdManager.h"


@interface YYTFullAdManager() <GADInterstitialDelegate, BaiduMobAdInterstitialDelegate, GDTUnifiedInterstitialAdDelegate, BUNativeExpresInterstitialAdDelegate>

@property (strong, nonatomic) GADInterstitial *googleFullAd;

@property (strong, nonatomic) BaiduMobAdInterstitial *baiduFullAd;

@property (strong, nonatomic) GDTUnifiedInterstitialAd *tencentFullAd;

@property (strong, nonatomic) BUNativeExpressInterstitialAd *bdFullAd;


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
        
        YYTLog(@"插屏-当前预加载的是：谷歌广告", nil);
        
    } else if (self.currentFullAdType.intValue == YYTAdTypeBaidu)
    {
        self.baiduFullAd = [[BaiduMobAdInterstitial alloc] init];
        self.baiduFullAd.delegate = self;
        self.baiduFullAd.AdUnitTag = self.model.baiduInsertPageID;
        self.baiduFullAd.interstitialType = BaiduMobAdViewTypeInterstitialOther;
        [self.baiduFullAd load];
        
        YYTLog(@"插屏-当前预加载的是：百度广告", nil);
    }  else if (self.currentFullAdType.intValue == YYTAdTypeTencent)
    {
        self.tencentFullAd = [[GDTUnifiedInterstitialAd alloc] initWithPlacementId:self.model.tencentInsertPageID];
        self.tencentFullAd.delegate = self;
        // 设置视频是否在非 WiFi 网络自动播放
        self.tencentFullAd.videoAutoPlayOnWWAN = YES;
        [self.tencentFullAd loadAd];
        
        YYTLog(@"插屏-当前预加载的是：腾讯广告", nil);
    } else if (self.currentFullAdType.intValue == YYTAdTypeByteDance)
    {
        CGSize screenSize = UIScreen.mainScreen.bounds.size;
        CGSize adSize = CGSizeMake(screenSize.width*0.8, screenSize.width*0.8*1.5);
        self.bdFullAd = [[BUNativeExpressInterstitialAd alloc] initWithSlotID:self.model.bdtInsertPageID adSize:adSize];
        self.bdFullAd.delegate = self;
        [self.bdFullAd loadAdData];
        YYTLog(@"插屏-当前预加载的是：穿山甲广告", nil);
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
            YYTLog(@"插屏-当前展示的是：谷歌广告", nil);
        } else {
            [self changeAndLoadNewAd];
        }
    } else if (self.currentFullAdType.intValue == YYTAdTypeBaidu)
    {
        if (self.baiduFullAd.isReady){
            
            [self.baiduFullAd presentFromRootViewController:self.model.appRootViewController];
            YYTLog(@"插屏-当前展示的是：百度广告", nil);
        } else {
            [self changeAndLoadNewAd];
        }
    } else if (self.currentFullAdType.intValue == YYTAdTypeTencent)
    {
        if (self.tencentFullAd.isAdValid){
            
            [self.tencentFullAd presentAdFromRootViewController:self.model.appRootViewController];
            YYTLog(@"插屏-当前展示的是：腾讯广告", nil);
        } else {
            [self changeAndLoadNewAd];
        }
    } else if (self.currentFullAdType.intValue == YYTAdTypeByteDance)
    {
        if (self.bdFullAd.isAdValid){
            [self.bdFullAd showAdFromRootViewController:self.model.appRootViewController];
            YYTLog(@"插屏-当前展示的是：穿山甲广告", nil);
        } else {
            [self changeAndLoadNewAd];
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

- (void) changeAndLoadNewAd
{
    [self changeFullAdType];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self createNewFullAd];
    });
}

#pragma mark - Google GadInterstitialDelegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad
{
    
}
- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
    [self changeAndLoadNewAd];
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
    [self changeAndLoadNewAd];
}

/**
 *  广告展示成功
 */
- (void)interstitialSuccessPresentScreen:(BaiduMobAdInterstitial *)interstitial
{
    [self createNewFullAd];
}

/**
 *  广告展示失败
 */
- (void)interstitialFailPresentScreen:(BaiduMobAdInterstitial *)interstitial withError:(BaiduMobFailReason) reason
{
    [self changeAndLoadNewAd];
}

#pragma mark - TencentAD delegate
- (void)unifiedInterstitialFailToLoadAd:(GDTUnifiedInterstitialAd *)unifiedInterstitial error:(NSError *)error
{
    [self changeAndLoadNewAd];
}

/**
 *  插屏广告点击回调
 */
- (void)unifiedInterstitialClicked:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    
}
/**
*  插屏2.0广告展示结束回调该函数
*/
- (void)unifiedInterstitialDidDismissScreen:(GDTUnifiedInterstitialAd *)unifiedInterstitial
{
    [self createNewFullAd];
}

#pragma mark - TencentAD BUNativeExpresInterstitialAdDelegate
- (void)nativeExpresInterstitialAd:(BUNativeExpressInterstitialAd *)interstitialAd didFailWithError:(NSError * __nullable)error
{
    [self changeAndLoadNewAd];
}

- (void)nativeExpresInterstitialAdRenderFail:(BUNativeExpressInterstitialAd *)interstitialAd error:(NSError * __nullable)error
{
    [self changeAndLoadNewAd];
}

- (void)nativeExpresInterstitialAdDidClose:(BUNativeExpressInterstitialAd *)interstitialAd
{
    [self createNewFullAd];
}

@end
