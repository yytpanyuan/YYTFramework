//
//  AppDelegate.m
//  YYTFramework
//
//  Created by yyt on 16/9/19.
//  Copyright © 2016年 yyt. All rights reserved.
//

#import "AppDelegate.h"
#import "YYTAdHeader.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.rootViewController = [[ViewController alloc] init];
    
    self.window.rootViewController = _rootViewController;
    
    [self.window makeKeyAndVisible];
    
    // init ad model
    [self initAdModel];
    //指定默认请求广告商
    [YYTAdManager sharedMe].arrAdType = @[@(YYTAdTypeMintegral), @(YYTAdTypeTencent)];
    [YYTFullAdManager sharedMe].arrAdType =  @[@(YYTAdTypeMintegral), @(YYTAdTypeTencent)];;
    //插屏广告需要预加载
    [[YYTFullAdManager sharedMe] createNewFullAd];
    
    //插入启动广告
    [[YYTLoadingPageAdManager sharedMe] loadingPageAd];

    return YES;
}

- (void) initAdModel
{
    YYTAdModel *model = [YYTAdModel new];
    
    model.mtgAppKey = @"7c22942b749fe6a6e361b675e96b3ee9";
    model.mtgAppID = @"118692";
    
    model.mtgLoadingPagePlacementID = @"177221";
    model.mtgLoadingPageUnitID = @"215246";
    
    model.mtgBannerPlacementID = @"138804";
    model.mtgBannerUnitID = @"146898";
    
    model.mtgInsertPagePlacementID = @"138800";
    model.mtgInsertPageUnitID = @"146894";
    
    [YYTAdManager sharedMe].model = model;
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
