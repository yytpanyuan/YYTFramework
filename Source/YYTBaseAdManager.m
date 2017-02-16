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
        NSLog(@"not set ad source!");
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
        NSLog(@"not set ad source!");
        return;
    }
    NSInteger index = [self.arrAdType indexOfObject:self.currentFullAdType];
    index++;
    if (index>=self.arrAdType.count) {
        index = 0;
    }
    self.currentFullAdType = [self.arrAdType objectAtIndex:index];
}

@end
