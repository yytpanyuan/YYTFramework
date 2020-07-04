//
//  YYTAdDefine.h
//  YYTFramework
//
//  Created by yyt on 2020/4/30.
//  Copyright © 2020 yyt. All rights reserved.
//

#ifndef YYTAdDefine_h
#define YYTAdDefine_h


typedef enum{
    
    YYTAdTypeGoogle = 0,
    YYTAdTypeBaidu,
    YYTAdTypeTencent,
    YYTAdTypeMintegral
    
} YYTAdType;


#ifdef DEBUG
#define YYTFormat(format)  [NSString stringWithFormat:@"YYTAD: %@", format]
#define YYTLog(format, ...) NSLog(YYTFormat(format), ##__VA_ARGS__)
#else
#define YYTLog(format, ...)
#endif

#define isIphoneX_ ({\
int tmp = 0;\
if (@available(iOS 11.0, *)) {\
if ([UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom>1) {\
tmp = 1;\
}else{\
tmp = 0;\
}\
}else{\
tmp = 0;\
}\
tmp;\
})

//Notification
#define kADBannerHeightChangedNotification        @"kADBannerHeightChangedNotification"
#define kLoadingPageAdWillFinishNotification      @"kLoadingPageAdWillFinishNotification"
#define kLoadingPageAdDidFinishNotification       @"kLoadingPageAdDidFinishNotification"


#endif /* YYTAdDefine_h */
