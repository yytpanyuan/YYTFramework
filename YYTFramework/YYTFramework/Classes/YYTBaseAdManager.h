//
//  YYTBaseAdManager.h
//  PopStar
//
//  Created by yyt on 16/8/18.
//
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

typedef enum{
    
    YYTAdTypeGoogle = 0,
    YYTAdTypeBaidu
    
} YYTAdType;

@interface YYTBaseAdManager : NSObject

@property (strong, nonatomic) Reachability *reachability;

@property (assign, nonatomic) YYTAdType AdType;

@property (assign, nonatomic) BOOL currentNetWork;

@end
