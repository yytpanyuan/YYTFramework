//
//  YYTBaseAdManager.h
//  PopStar
//
//  Created by yyt on 16/8/18.
//
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "YYTAdModel.h"
#import "YYTAdDefine.h"


@interface YYTBaseAdManager : NSObject

@property (strong, nonatomic) Reachability *reachability;

@property (assign, nonatomic) NSNumber *currentAdType;

@property (assign, nonatomic) NSNumber *currentFullAdType;

@property (strong, nonatomic) NSArray *arrAdType;

@property (assign, nonatomic) BOOL currentNetWork;

@property (assign, nonatomic) BOOL userISVIP;

- (YYTAdModel *) model;

- (void)setModel:(YYTAdModel *)model;

- (void) changeBannerAdType;

- (void) changeFullAdType;

@end
