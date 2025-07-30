#import <Flutter/Flutter.h>
#import <Foundation/Foundation.h>
#import <IronSource/IronSource.h>


@interface LevelPlayAdObjectManager : NSObject

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel;

- (NSString *)createInterstitialAd:(NSString *)adUnitId bidFloor:(NSNumber *)bidFloor;
- (void)loadInterstitialAd:(NSString *)adId;
- (void)showInterstitialAd:(NSString *)adId placementName:(NSString *)placementName rootViewController:(UIViewController *_Nonnull)rootViewController;
- (BOOL)isInterstitialAdReady:(NSString *)adId;
- (NSString *)createRewardedAd:(NSString *)adUnitId bidFloor:(NSNumber *)bidFloor;
- (void)loadRewardedAd:(NSString *)adId;
- (void)showRewardedAd:(NSString *)adId placementName:(NSString *)placementName rootViewController:(UIViewController *_Nonnull)rootViewController;
- (BOOL)isRewardedAdReady:(NSString *)adId;
- (void)disposeAd:(NSString *)adId;
- (void)disposeAllAds;

@end


