#import <Flutter/Flutter.h>
#import <Foundation/Foundation.h>
#import <IronSource/IronSource.h>

@interface LevelPlayAdObjectManager : NSObject

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel;

- (void)loadInterstitialAd:(NSNumber *)adObjectId adUnitId:(NSString *)adUnitId;
- (void)showInterstitialAd:(NSNumber *)adObjectId placementName:(NSString *)placementName rootViewController:(UIViewController *_Nonnull)rootViewController;
- (BOOL)isInterstitialAdReady:(NSNumber *)adObjectId;
- (void)loadRewardedAd:(NSNumber *)adObjectId adUnitId:(NSString *)adUnitId;
- (void)showRewardedAd:(NSNumber *)adObjectId placementName:(NSString *)placementName rootViewController:(UIViewController *_Nonnull)rootViewController;
- (BOOL)isRewardedAdReady:(NSNumber *)adObjectId;
- (void)disposeAd:(NSNumber *)adObjectId;
- (void)disposeAllAds;

@end
