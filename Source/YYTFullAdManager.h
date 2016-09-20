//
//  YYTFullAdManager.h
//  2048
//
//  Created by yyt on 15/6/1.
//
//

#import <Foundation/Foundation.h>
#import "YYTBaseAdManager.h"


@interface YYTFullAdManager : YYTBaseAdManager

+ (instancetype) sharedMe;

- (void) createNewFullAd;

- (void) insertFullAdNow;

@end
