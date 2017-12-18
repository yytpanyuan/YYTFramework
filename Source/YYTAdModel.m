//
//  YYTAdModel.m
//  YYTFramework
//
//  Created by yyt on 16/9/20.
//  Copyright © 2016年 yyt. All rights reserved.
//

#import "YYTAdModel.h"

@implementation YYTAdModel

- (instancetype) init
{
    if (self = [super init]) {
        
        self.googleBannerID = @"ca-app-pub-3296373452957435/7895583704";
        self.googleInsertPageID = @"ca-app-pub-3296373452957435/3328828901";
        
        self.baiduKey = @"cb08345f";
        self.baiduBannerID = @"2911701";
        self.baiduLoadingPageID = @"2911690";
        self.baiduInsertPageID = @"2911696";
        
        self.tencentKey  = @"1105598677";
        self.tencentBannerID = @"2080218976212836";
        self.tencentInsertPageID = @"5060815926912897";
        self.tencentLoadingPageID = @"3070913748270340";
        
        self.tabBarHeight = 49;
        self.bannerHeight = 50;
        
        self.appRootViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    }
    
    return self;
}

@end
