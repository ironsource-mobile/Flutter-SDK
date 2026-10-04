#import <Foundation/Foundation.h>
#import <IronSource/IronSource.h>
#import <Flutter/Flutter.h>

@interface LevelPlayRewardedAdDelegate : NSObject <LPMRewardedAdDelegate, LPMImpressionDataDelegate>

- (instancetype)initWithAdId:(NSString *)adId
        channel:(FlutterMethodChannel *)channel;
@end
