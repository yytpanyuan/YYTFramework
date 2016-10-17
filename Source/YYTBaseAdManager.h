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

typedef enum{
    
    YYTAdTypeGoogle = 0,
    YYTAdTypeBaidu
    
} YYTAdType;

@interface YYTBaseAdManager : NSObject

@property (strong, nonatomic) Reachability *reachability;

@property (assign, nonatomic) YYTAdType AdType;

@property (assign, nonatomic) BOOL currentNetWork;

@property (assign, nonatomic) BOOL userISVIP;

- (YYTAdModel *) model;

- (void)setModel:(YYTAdModel *)model;

@end
