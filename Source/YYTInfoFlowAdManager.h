//
//  YYTInfoFlowAdManager.h
//  YYTFramework
//
//  Created by yyt on 2022/4/3.
//  Copyright © 2022 yyt. All rights reserved.
//

#import "YYTBaseAdManager.h"

NS_ASSUME_NONNULL_BEGIN

@protocol YYTInfoFlowAdManagerDelegate <NSObject>

@required

/// 获取rootControlleer
/// @param adView
- (UIViewController*)rootViewControllerForAdView:(UIView *)adView;

/// 更新adView的高度
/// @param adView
/// @param height
- (void)adView:(UIView *)adView updateFrame:(CGRect)frame;

/// adView 宽度
- (CGFloat)adViewWidth;

@end

@interface YYTInfoFlowAdManager : YYTBaseAdManager

@property (weak, nonatomic) id<YYTInfoFlowAdManagerDelegate> delegate;
@property (assign, nonatomic) BOOL googleIsSmallAd;

+ (instancetype) sharedMe;

- (UIView *)fetchInfoFlowAdView;

@end

NS_ASSUME_NONNULL_END
