//
//  YYTAdModel.h
//  YYTFramework
//
//  Created by yyt on 16/9/20.
//  Copyright © 2016年 yyt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YYTAdModel : NSObject

//google unit
@property (strong, nonatomic) NSString *googleBannerID;
@property (strong, nonatomic) NSString *googleInsertPageID;
@property (strong, nonatomic) NSString *googleLoadingPageID;
@property (strong, nonatomic) NSString *googleInfoFlowID;

//baidu unit
@property (strong, nonatomic) NSString *baiduKey;
@property (strong, nonatomic) NSString *baiduBannerID;
@property (strong, nonatomic) NSString *baiduInsertPageID;
@property (strong, nonatomic) NSString *baiduLoadingPageID;
@property (strong, nonatomic) NSString *baiduInfoFlowID;

//tencent unit
@property (strong, nonatomic) NSString *tencentKey;
@property (strong, nonatomic) NSString *tencentBannerID;
@property (strong, nonatomic) NSString *tencentInsertPageID;
@property (strong, nonatomic) NSString *tencentLoadingPageID;
@property (strong, nonatomic) NSString *tencentInfoFlowID;

//bytedance unit
@property (strong, nonatomic) NSString *bdKey;
@property (strong, nonatomic) NSString *bdBannerID;
@property (strong, nonatomic) NSString *bdtInsertPageID;
@property (strong, nonatomic) NSString *bdLoadingPageID;
@property (strong, nonatomic) NSString *bdInfoFlowID;


//other pro
@property (assign, nonatomic) CGFloat tabBarHeight;
@property (assign, nonatomic) CGFloat bannerHeight;
@property (assign, nonatomic) CGFloat bannerCurrentHeight;
@property (strong, nonatomic) UIViewController *appRootViewController;
/**
 * 可以提供一个和启动图一样的View，来达到无缝的效果
 */
@property (strong, nonatomic) UIView *loadingAdContainerView;

@end
