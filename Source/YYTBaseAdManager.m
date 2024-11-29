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
