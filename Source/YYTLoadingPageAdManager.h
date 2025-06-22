//
//  YYTLoadingPageAdManager.h
//  YYTFramework
//
//  Created by yyt on 16/9/21.
//  Copyright © 2016年 yyt. All rights reserved.
//

#import "YYTBaseAdManager.h"
#import "GDTMobSDK/GDTSplashAd.h"
#import <BUAdSDK/BUSplashAd.h>

@interface YYTLoadingPageAdManager : YYTBaseAdManager

+ (instancetype) sharedMe;

- (void) loadingPageAd;

@end
