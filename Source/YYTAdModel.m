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

        self.googleBannerID = @"ca-app-pub-3296373452957435/2005341700";
        self.googleInsertPageID = @"ca-app-pub-3296373452957435/6027420107";
        
        self.baiduKey = @"cb08345f";
        self.baiduBannerID = @"2911701";
        self.baiduLoadingPageID = @"2911690";
        self.baiduInsertPageID = @"2911696";
        
        self.tencentKey  = @"1105671178";
        self.tencentBannerID = @"6081319038952074";
        self.tencentInsertPageID = @"1081415088877960";
        self.tencentLoadingPageID = @"3020510806597568";
        
        self.tabBarHeight = 0;
        self.bannerHeight = 50;
        self.bannerCurrentHeight = self.bannerHeight;
        
        self.appRootViewController = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    }
    
    return self;
}

@end
