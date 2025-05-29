#import "LevelPlayAdObjectManager.h"
#import "./DelegateHandlers/LevelPlay/LevelPlayInterstitialAdDelegate.h"
#import "./DelegateHandlers/LevelPlay/LevelPlayRewardedAdDelegate.h"

@interface LevelPlayAdObjectManager ()

@property (nonatomic, strong) FlutterMethodChannel *channel;
@property (nonatomic, strong) NSMutableDictionary<NSString *, LPMInterstitialAd *> *interstitialAdsDict;
@property (nonatomic, strong) NSMutableDictionary<NSString *, LevelPlayInterstitialAdDelegate *> *interstitialDelegatesDict;
@property (nonatomic, strong) NSMutableDictionary<NSString *, LPMRewardedAd *> *rewardedAdsDict;
@property (nonatomic, strong) NSMutableDictionary<NSString *, LevelPlayRewardedAdDelegate *> *rewardedDelegatesDict;


@end

@implementation LevelPlayAdObjectManager

- (instancetype)initWithChannel:(FlutterMethodChannel *)channel {
    self = [super init];
    if (self) {
        _channel = channel;
        _interstitialAdsDict = [NSMutableDictionary dictionary];
        _interstitialDelegatesDict = [NSMutableDictionary dictionary];
        _rewardedAdsDict = [NSMutableDictionary dictionary];
        _rewardedDelegatesDict = [NSMutableDictionary dictionary];
    }
    return self;
}

// Interstitial Ad Methods
- (NSString *)createInterstitialAd:(NSString *)adUnitId {
        // Create the interstitial ad
        LPMInterstitialAd *interstitialAd = [[LPMInterstitialAd alloc] initWithAdUnitId:adUnitId];
        if (!interstitialAd) {
            NSLog(@"Failed to create interstitial ad with adUnitId: %@", adUnitId);
            return nil;
        }
        
        if (!interstitialAd.adId) {
            NSLog(@"Generated adId is nil for adUnitId: %@", adUnitId);
            return nil;
        }
        
        // Set the listener
        LevelPlayInterstitialAdDelegate *interstitialAdDelegate = [[LevelPlayInterstitialAdDelegate alloc]
                                                                   initWithAdId:interstitialAd.adId
                                                                   channel:self.channel];
        
        [interstitialAd setDelegate:interstitialAdDelegate];
        
    // Store references
        self.interstitialDelegatesDict[interstitialAd.adId] = interstitialAdDelegate;
        self.interstitialAdsDict[interstitialAd.adId] = interstitialAd;
        
        // Return the adId
        return interstitialAd.adId;
}

- (void)loadInterstitialAd:(NSString *)adId {
    //Retrieve the interstitial ad object from dictionary using the adId
    LPMInterstitialAd *interstitialAd = [self.interstitialAdsDict objectForKey:adId];
    // Only attempt to load the ad if an ad object was retrived successfully
    if (interstitialAd) {
        [interstitialAd loadAd];
    }
}

- (void)showInterstitialAd:(NSString *)adId placementName:(NSString *)placementName rootViewController:(UIViewController *_Nonnull)rootViewController {
    //Retrieve the interstitial ad object from dictionary using the adId
    LPMInterstitialAd *interstitialAd = [self.interstitialAdsDict objectForKey:adId];
    // Check if the interstitialAd exists and ready before attempting to show it
    if (interstitialAd) {
        [interstitialAd showAdWithViewController:rootViewController placementName:placementName];
    }
}

- (BOOL)isInterstitialAdReady:(NSString *)adId {
    //Retrieve the interstitial ad object from dictionary using the adId
    LPMInterstitialAd *interstitialAd = [self.interstitialAdsDict objectForKey:adId];
    // Check if the ad exists and then return its ready state, otherwise return NO
    if (interstitialAd) {
        return [interstitialAd isAdReady];
    }
    return NO;
}

// Rewarded Ad Methods
- (NSString *)createRewardedAd:(NSString *)adUnitId {
    // Create the rewarded ad
    LPMRewardedAd *rewardedAd = [[LPMRewardedAd alloc] initWithAdUnitId:adUnitId];
    if (!rewardedAd) {
            NSLog(@"Failed to create rewarded ad with adUnitId: %@", adUnitId);
            return nil;
        }
    
    if (!rewardedAd.adId) {
        NSLog(@"Generated adId is nil for adUnitId: %@", adUnitId);
        return nil;
    }

    // Set the listener
    LevelPlayRewardedAdDelegate *rewardedAdDelegate = [[LevelPlayRewardedAdDelegate alloc]
                                                       initWithAdId:rewardedAd.adId
                                                       channel:self.channel];
    [rewardedAd setDelegate: rewardedAdDelegate];
    
    // Store references
    self.rewardedDelegatesDict[rewardedAd.adId] = rewardedAdDelegate;
    self.rewardedAdsDict[rewardedAd.adId] = rewardedAd;

    // Return the ad ID
    return rewardedAd.adId;
}

- (void)loadRewardedAd:(NSString *)adId {
    //Retrieve the rewarded ad object from dictionary using the adId
    LPMRewardedAd *rewardedAd = [self.rewardedAdsDict objectForKey:adId];
    //Only attempt to load the ad if an ad object was retrived successfully
    if (rewardedAd) {
        [rewardedAd loadAd];
    }
    }

- (void)showRewardedAd:(NSString *)adId placementName:(NSString *)placementName rootViewController:(UIViewController *_Nonnull)rootViewController {
    //Retrieve the rewarded ad object from dictionary using the adId
    LPMRewardedAd *rewardedAd = [self.rewardedAdsDict objectForKey:adId];
    // Check if the rewardedAd exists and ready before attempting to show it
    if (rewardedAd) {
        [rewardedAd showAdWithViewController:rootViewController placementName:placementName];
    }
}


- (BOOL)isRewardedAdReady:(NSString *)adId {
    //Retrieve the rewarded ad object from dictionary using the adId
    LPMRewardedAd *rewardedAd = [self.rewardedAdsDict objectForKey:adId];
    // Check if the ad exists and then return its ready state, otherwise return NO
    if (rewardedAd) {
        return [rewardedAd isAdReady];
    }
    return NO;
}

// Shared Methods
- (void)disposeAd:(NSString *)adId {
    
    if (!adId || [adId length] == 0) {
        NSLog(@"Warning: Attempted to dispose ad with nil or empty adId");
        return;
    }
    
    // Handle interstitial ads
    if ([self.interstitialAdsDict objectForKey:adId] != nil) {
        [self.interstitialAdsDict removeObjectForKey:adId];
        [self.interstitialDelegatesDict removeObjectForKey:adId];
    }
    
    // Handle rewarded ads
    if ([self.rewardedAdsDict objectForKey:adId] != nil) {
        [self.rewardedAdsDict removeObjectForKey:adId];
        [self.rewardedDelegatesDict removeObjectForKey:adId];
    }
}

- (void)disposeAllAds {
    [self.interstitialAdsDict removeAllObjects];
    [self.interstitialDelegatesDict removeAllObjects];
    [self.rewardedAdsDict removeAllObjects];
    [self.rewardedDelegatesDict removeAllObjects];
}



@end
