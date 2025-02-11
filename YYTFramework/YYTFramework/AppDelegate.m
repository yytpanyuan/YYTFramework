//
//  AppDelegate.m
//  YYTFramework
//
//  Created by yyt on 16/9/19.
//  Copyright © 2016年 yyt. All rights reserved.
//

#import "AppDelegate.h"
#import "YYTAdHeader.h"
#import "AdKeyHeader.h"

/******** 头文件引入 *********/
#ifdef DEBUG1
#import <BUAdTestMeasurement/BUAdTestMeasurement.h>
#endif


@import GoogleMobileAds;


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [FIRApp configure];
    
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.rootViewController = [[ViewController alloc] init];
    
    self.window.rootViewController = _rootViewController;
    
    [self.window makeKeyAndVisible];
    
    /******** 开启测试 *********/
    #ifdef DEBUG1
    [BUAdTestMeasurementConfiguration configuration].debugMode = YES;
    [BUAdTestMeasurementManager showTestMeasurementWithController:viewController];
    #endif
    
    // init ad model
    [self initAdModel];
    //指定默认请求广告商
    NSArray *adList = @[@(YYTAdTypeByteDance)];
//    NSArray *adList = @[@(YYTAdTypeByteDance), @(YYTAdTypeGoogle), @(YYTAdTypeTencent)];
    [YYTLoadingPageAdManager sharedMe].arrAdType =  adList;
    [YYTAdManager sharedMe].arrAdType = adList;
    [YYTFullAdManager sharedMe].arrAdType = adList;
    [YYTInfoFlowAdManager sharedMe].arrAdType = adList;
//    [YYTInfoFlowAdManager sharedMe].arrAdType =  @[@(YYTAdTypeGoogle)];
//    YYTInfoFlowAdManager.sharedMe.googleIsSmallAd = YES;
    
//    [YYTAdManager sharedMe].arrAdType = @[ @(YYTAdTypeGoogle)];
    //插屏广告需要预加载
    [[YYTFullAdManager sharedMe] createNewFullAd];
    
    //插入启动广告
//    [[YYTLoadingPageAdManager sharedMe] loadingPageAd];

    return YES;
}

- (void) initAdModel
{
    YYTAdModel *model = [[YYTAdModel alloc] init];
    model.isGroMoreMode = YES;
    
    model.googleBannerID = kGoogleBannerID;
    model.googleInsertPageID = kGoogleInsertID;
    model.googleLoadingPageID = kGoogleSplashID;
    model.googleInfoFlowID = kGoogleInfoFlowID;
    
    model.baiduKey = kBaiduAppKey;
    model.baiduBannerID = kBaiduBannerID;
    model.baiduLoadingPageID = kBaiduLoadingID;
    model.baiduInsertPageID = kBaiduPageID;
    
    model.tencentKey = kTencentAppKey;
    model.tencentBannerID = kTencentBannerID;
    model.tencentInsertPageID = kTencentPageID;
    model.tencentLoadingPageID = kTencentSplashID;
    model.tencentInfoFlowID = kTencentInfoFlowID;
    
    model.bdKey = kbdAppID;
    model.bdLoadingPageID = kbdSplashID;
    model.bdBannerID = kbdBannerID;
    model.bdtInsertPageID = kbdPageID;
    model.bdInfoFlowID = kbdInfoFlowID;
    
    model.moreID = kMoreAppID;
    model.moreLoadingPageID = kMoreSplashID;
    model.moreBannerID = kMoreBannerID;
    model.moretInsertPageID = kMorePageID;
    model.moreInfoFlowID = kMoreInfoFlowID;
    model.moreRewardVedioID = kMoreForwardVedioID;
    
    YYTAdManager.sharedMe.isRandomShowAd = YES;
    
    [[YYTAdManager sharedMe] setModel:model];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
