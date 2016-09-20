//
//  YYTAdManager.h
//  PopStar
//
//  Created by yyt on 16/8/15.
//
//

#import <Foundation/Foundation.h>
#import "YYTAdSetting.h"
#import "YYTBaseAdManager.h"

@interface YYTAdManager : YYTBaseAdManager

+ (instancetype) sharedMe;

- (void) createNewBannerAd;

@end
