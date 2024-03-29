//
//  ViewController.m
//  YYTFramework
//
//  Created by yyt on 16/9/19.
//  Copyright © 2016年 yyt. All rights reserved.
//

#import "ViewController.h"
#import "YYTAdHeader.h"


@interface ViewController () <YYTInfoFlowAdViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect rect = [UIScreen mainScreen].bounds;
    button.frame = CGRectMake((rect.size.width-150)/2, 100, 150, 35);
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitle:@"Banner Ad" forState:UIControlStateNormal];
    [button setTitle:@"remove Banner Ad" forState:UIControlStateSelected];
    [button addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 0;
    [self.view addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake((rect.size.width-150)/2, 150, 150, 35);
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitle:@"Insert Page Ad" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 1;
    [self.view addSubview:button];
    
    button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake((rect.size.width-150)/2, 200, 150, 35);
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    [button setTitle:@"信息流广告" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 2;
    [self.view addSubview:button];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(adBannerHeightChanged:) name:kADBannerHeightChangedNotification object:nil];
    
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(loadingPageAdFinish:) name:kLoadingPageAdDidFinishNotification object:nil];
}

- (void) adBannerHeightChanged: (NSNotification *) notification
{
    YYTLog(@"当前Ad Banner高度：%@", notification.object);
}

- (void) loadingPageAdFinish: (NSNotification *) notification
{
    YYTLog(@"启动广告展示完成。", nil);
}

- (void) buttonEvent:(UIButton *) button
{
    if (button.tag == 0) {
        button.selected = !button.selected;
        if (button.selected) {
            [[YYTAdManager sharedMe] startBannerAd];
        } else {
            [[YYTAdManager sharedMe] stopBannerAd];
        }
    } else if (button.tag == 1)
    {
        [[YYTFullAdManager sharedMe] insertFullAdNow];
    } else if (button.tag == 2)
    {
        UIView *view = [YYTInfoFlowAdManager.sharedMe fetchInfoFlowAdViewWithDelegate:self];
        view.frame = CGRectMake(0, 300, self.view.frame.size.width, 200);
        [self.view addSubview:view];
    }
}

- (UIViewController *)rootViewControllerForAdView:(UIView *)adView
{
    return self;
}

- (void)adView:(UIView *)adView updateFrame:(CGRect)frame {
    adView.frame = CGRectMake(adView.frame.origin.x, adView.frame.origin.y, adView
                              .frame.size.width, adView.frame.size.width * frame.size.height / frame.size.width);
}

- (CGFloat)adViewWidth {
    return UIScreen.mainScreen.bounds.size.width;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
