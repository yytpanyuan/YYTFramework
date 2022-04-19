//
//  YYTInfoFlowAdManager.h
//  YYTFramework
//
//  Created by yyt on 2022/4/3.
//  Copyright © 2022 yyt. All rights reserved.
//

#import "YYTBaseAdManager.h"
#import "YYTInfoFlowAdView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YYTInfoFlowAdManager : YYTBaseAdManager

@property (assign, nonatomic) BOOL googleIsSmallAd;

+ (instancetype) sharedMe;

- (YYTInfoFlowAdView *)fetchInfoFlowAdViewWithDelegate:(id<YYTInfoFlowAdViewDelegate>)delegate;

@end

NS_ASSUME_NONNULL_END
