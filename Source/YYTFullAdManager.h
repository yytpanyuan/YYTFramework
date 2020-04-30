//
//  YYTFullAdManager.h
//  2048
//
//  Created by yyt on 15/6/1.
//
//

#import <Foundation/Foundation.h>
#import "YYTBaseAdManager.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <BaiduMobAdSDK/BaiduMobAdInterstitial.h>
#import <BaiduMobAdSDK/BaiduMobAdInterstitialDelegate.h>
#import <GDTUnifiedInterstitialAd.h>


@interface YYTFullAdManager : YYTBaseAdManager

+ (instancetype) sharedMe;

- (void) createNewFullAd;

- (void) insertFullAdNow;

@end
