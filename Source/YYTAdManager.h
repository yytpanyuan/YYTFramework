//
//  YYTAdManager.h
//  PopStar
//
//  Created by yyt on 16/8/15.
//
//

#import <Foundation/Foundation.h>
#import "YYTBaseAdManager.h"
#import "BaiduMobAdSDK/BaiduMobAdView.h"
#import "BaiduMobAdSDK/BaiduMobAdDelegateProtocol.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <GDTUnifiedBannerView.h>
#import <GDTSDKConfig.h>
#import <MTGSDK/MTGSDK.h>
#import <MTGSDKBanner/MTGBannerAdView.h>
#import <MTGSDKBanner/MTGBannerAdViewDelegate.h>

@interface YYTAdManager : YYTBaseAdManager

+ (instancetype) sharedMe;

- (void) startBannerAd;

- (void) stopBannerAd;

@end
