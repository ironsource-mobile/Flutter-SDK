#import <Foundation/Foundation.h>
#import <IronSource/IronSource.h>
#import <Flutter/Flutter.h>

@interface LevelPlayInterstitialAdDelegate : NSObject <LPMInterstitialAdDelegate>

- (instancetype)initWithAdObjectId:(int)adObjectId
                     channel:(FlutterMethodChannel *)channel;
@end
