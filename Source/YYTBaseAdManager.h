//
//  YYTBaseAdManager.h
//  PopStar
//
//  Created by yyt on 16/8/18.
//
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "YYTAdModel.h"
#import "YYTAdDefine.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/AdSupport.h>
#import "BaiduMobAdSDK/BaiduMobAdView.h"
#import "BaiduMobAdSDK/BaiduMobAdDelegateProtocol.h"
#import <GDTUnifiedBannerView.h>
#import <GDTSDKConfig.h>
#import <BUAdSDK/BUAdSDK.h>

@import GoogleMobileAds;

@interface YYTBaseAdManager : NSObject

@property (strong, nonatomic) Reachability *reachability;

@property (assign, nonatomic) NSNumber *currentAdType;

@property (assign, nonatomic) NSNumber *currentFullAdType;

@property (assign, nonatomic) NSNumber *currentSplashAdType;

@property (assign, nonatomic) NSNumber *currentInfoFlowAdType;

@property (strong, nonatomic) NSArray *arrAdType;

@property (assign, nonatomic) BOOL currentNetWork;

@property (assign, nonatomic) BOOL userISVIP;

- (YYTAdModel *) model;

- (void)setModel:(YYTAdModel *)model;

- (void) changeBannerAdType;

- (void) changeFullAdType;

- (BOOL) changeSplashAdType;

- (void) changeInfoFlowAdType;

- (void) requestIDFAForIOS14WithBlock:(void (^)(void))completeBlock;

@end
