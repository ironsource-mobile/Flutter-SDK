#import "LevelPlayAdObjectManager.h"
#import "./DelegateHandlers/LevelPlay/LevelPlayInterstitialAdDelegate.h"

@interface LevelPlayAdObjectManager ()

@property (nonatomic, strong) FlutterMethodChannel *channel;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, LPMInterstitialAd *> *interstitialAdsDict;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, LevelPlayInterstitialAdDelegate *> *interstitialDelegatesDict;

@end

@implementation LevelPlayAdObjectManager

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel {
    self = [super init];
    if (self) {
        _channel = channel;
        _interstitialAdsDict = [NSMutableDictionary dictionary];
        _interstitialDelegatesDict = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)loadInterstitialAd:(NSNumber *)adObjectId adUnitId:(NSString *)adUnitId {
    // Check if the interstitial ad already exists
    LPMInterstitialAd *existingAd = [self.interstitialAdsDict objectForKey:adObjectId];

    if (existingAd != nil) {
        // Ad exists, load the existing ad
        [existingAd loadAd];
        return;
    }

    // If the ad doesn't exist, create a new interstitial ad instance
    LPMInterstitialAd *interstitialAd = [[LPMInterstitialAd alloc] initWithAdUnitId:adUnitId];
    LevelPlayInterstitialAdDelegate *interstitialAdDelegate = [[LevelPlayInterstitialAdDelegate alloc] initWithAdObjectId:adObjectId.intValue
                                                                                              channel:self.channel];
    [interstitialAd setDelegate: interstitialAdDelegate];

    // Retain the delegate to ensure it remains in memory
    [self.interstitialDelegatesDict setObject:interstitialAdDelegate forKey:adObjectId];
    // Store the interstitial ad instance
    [self.interstitialAdsDict setObject:interstitialAd forKey:adObjectId];
    // Load the interstitial ad
    [interstitialAd loadAd];
}

- (void)showInterstitialAd:(NSNumber *)adObjectId placementName:(NSString *)placementName rootViewController:(UIViewController *_Nonnull)rootViewController {
    LPMInterstitialAd *interstitialAd = [self.interstitialAdsDict objectForKey:adObjectId];
    // Check if the interstitialAd exists before attempting to show it
    if (interstitialAd != nil) {
        [interstitialAd showAdWithViewController:rootViewController placementName:placementName];
    }
}


- (BOOL)isInterstitialAdReady:(NSNumber *)adObjectId {
    LPMInterstitialAd *interstitialAd = [self.interstitialAdsDict objectForKey:adObjectId];
    // Check if the ad exists and then return its ready state, otherwise return NO
    if (interstitialAd != nil) {
        return [interstitialAd isAdReady];
    }
    return NO;
}

- (void)disposeAd:(NSNumber *)adObjectId {
    if ([self.interstitialAdsDict objectForKey:adObjectId] != nil) {
        [self.interstitialAdsDict removeObjectForKey:adObjectId];
        [self.interstitialDelegatesDict removeObjectForKey:adObjectId];
    }
}

- (void)disposeAllAds {
    [self.interstitialAdsDict removeAllObjects];
    [self.interstitialDelegatesDict removeAllObjects];
}

@end
