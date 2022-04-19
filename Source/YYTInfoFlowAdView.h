//
//  YYTInfoFlowAdView.h
//  YYTFramework
//
//  Created by yyt on 2022/4/19.
//  Copyright © 2022 yyt. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol YYTInfoFlowAdViewDelegate <NSObject>

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

@interface YYTInfoFlowAdView : UIView

@property (nonatomic, weak) id<YYTInfoFlowAdViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
