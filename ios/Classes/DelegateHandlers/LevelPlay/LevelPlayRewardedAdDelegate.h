#import <Foundation/Foundation.h>
#import <IronSource/IronSource.h>
#import <Flutter/Flutter.h>

@interface LevelPlayRewardedAdDelegate : NSObject <LPMRewardedAdDelegate>

- (instancetype)initWithAdId:(NSString *)adId
        channel:(FlutterMethodChannel *)channel;
@end
