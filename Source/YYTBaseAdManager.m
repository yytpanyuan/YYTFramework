//
//  YYTBaseAdManager.m
//  PopStar
//
//  Created by yyt on 16/8/18.
//
//

#import "YYTBaseAdManager.h"


static YYTAdModel *staticModel;

@implementation YYTBaseAdManager

- (instancetype) init
{
    if ([super init]) {
        [self startNetworkReachaby];
        
        [GDTSDKConfig setChannel:14];
    }
    return self;
}

- (YYTAdModel *) model
{
    if (!staticModel) {
        staticModel = [YYTAdModel new];
    }
    return staticModel;
}

- (void)setModel:(YYTAdModel *)model
{
    staticModel = model;
    
    if (model.isGroMoreMode) {
        /******************** 初始化 ********************/
        BUAdSDKConfiguration *configuration = [BUAdSDKConfiguration configuration];
        // 设置APPID
        configuration.appID = model.moreID;
        // 设置日志输出
        configuration.debugLog = @(1);
        // 是否使用聚合
        configuration.useMediation = YES;
        // 隐私合规配置
        // 是否禁止CAID
        configuration.mediation.forbiddenCAID = @(0);
        // 不限制个性化广告
        configuration.mediation.limitPersonalAds = @(0);
        // 不限制程序化广告
        configuration.mediation.limitProgrammaticAds = @(0);
        // 初始化
        [BUAdSDKManager startWithAsyncCompletionHandler:^(BOOL success, NSError *error) {
            if (success) {
                NSLog(@"穿山甲初始化成功！");
            } else {
                NSLog(@"穿山甲初始化失败！");
            }
        }];
    } else {
        [GDTSDKConfig initWithAppId:model.tencentKey];
        [GDTSDKConfig startWithCompletionHandler:^(BOOL success, NSError *error) {
            NSLog(@"广点通初始化成功！");
        }];
        // Initialize the Google Mobile Ads SDK.
        [[GADMobileAds sharedInstance] startWithCompletionHandler:^(GADInitializationStatus * _Nonnull status) {
            NSLog(@"谷歌广告初始化成功！");
        }];
        
        BUAdSDKConfiguration *configuration = [BUAdSDKConfiguration configuration];
        configuration.appID = model.bdKey;
        [BUAdSDKManager startWithSyncCompletionHandler:^(BOOL success, NSError * _Nullable error) {
            NSLog(@"穿山甲初始化成功！");
        }];
    }
}

- (void) requestIDFAForIOS14WithBlock:(void (^)(void))completeBlock {
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"requestIDFAForIOS14: %d", (int)status);
                !completeBlock ?:completeBlock();
            });
        }];
    } else {
        !completeBlock ?:completeBlock();
    }
}

- (void)setUserISVIP:(BOOL)userISVIP
{
    _userISVIP = userISVIP;
    self.model.bannerHeight = 0;
}

- (void) startNetworkReachaby
{
    self.reachability = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChanged:) name:kReachabilityChangedNotification object:nil];
    [_reachability startNotifier];
}

- (void) networkStatusChanged:(NSNotification *) notification
{

}

- (void) changeBannerAdType
{
    if (self.model.isGroMoreMode) {
        return;
    }
    if (self.arrAdType.count == 0) {
        YYTLog(@"not set ad source!", nil);
        return;
    }
    NSInteger index = [self.arrAdType indexOfObject:self.currentAdType];
    index++;
    if (index>=self.arrAdType.count) {
        index = 0;
    }
    self.currentAdType = [self.arrAdType objectAtIndex:index];
}

- (void) changeFullAdType
{
    if (self.model.isGroMoreMode) {
        return;
    }
    if (self.arrAdType.count == 0) {
        YYTLog(@"not set ad source!", nil);
        return;
    }
    NSInteger index = [self.arrAdType indexOfObject:self.currentFullAdType];
    index++;
    if (index>=self.arrAdType.count) {
        index = 0;
    }
    self.currentFullAdType = [self.arrAdType objectAtIndex:index];
}

- (BOOL) changeSplashAdType
{
    if (self.model.isGroMoreMode) {
        return NO;
    }
    if (self.arrAdType.count == 0) {
        YYTLog(@"not set ad source!", nil);
        return NO;
    }
    NSInteger index = [self.arrAdType indexOfObject:self.currentSplashAdType];
    index++;
    if (index < self.arrAdType.count) {
        self.currentSplashAdType = [self.arrAdType objectAtIndex:index];
        return YES;
    }
    return  NO;
}

- (void) changeInfoFlowAdType
{
    if (self.model.isGroMoreMode) {
        return;
    }
    if (self.arrAdType.count == 0) {
        YYTLog(@"not set ad source!", nil);
        return;
    }
    if (self.isRandomShowAd) {
        int index = arc4random_uniform((int)self.arrAdType.count);
        self.currentInfoFlowAdType = self.arrAdType[index];
    } else {
        NSInteger index = [self.arrAdType indexOfObject:self.currentInfoFlowAdType];
        index++;
        if (index>=self.arrAdType.count) {
            index = 0;
        }
        self.currentInfoFlowAdType = self.arrAdType[index];
    }
}

@end
