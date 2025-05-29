#import <Foundation/Foundation.h>
#import <IronSource/IronSource.h>
#import <Flutter/Flutter.h>

@interface LevelPlayInterstitialAdDelegate : NSObject <LPMInterstitialAdDelegate>

- (instancetype)initWithAdId:(NSString *)adId
                     channel:(FlutterMethodChannel *)channel;
@end
