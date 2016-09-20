//
//  YYTBaseAdManager.m
//  PopStar
//
//  Created by yyt on 16/8/18.
//
//

#import "YYTBaseAdManager.h"

@implementation YYTBaseAdManager

- (instancetype) init
{
    if ([super init]) {
        [self startNetworkReachaby];
    }
    return self;
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

@end
