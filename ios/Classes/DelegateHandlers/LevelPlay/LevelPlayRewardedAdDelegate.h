#import <Foundation/Foundation.h>
#import <IronSource/IronSource.h>
#import <Flutter/Flutter.h>

@interface LevelPlayRewardedAdDelegate : NSObject <LPMRewardedAdDelegate>

- (instancetype)initWithAdObjectId:(int)adObjectId
        channel:(FlutterMethodChannel *)channel;
@end
