#import "LevelPlayInterstitialAdDelegate.h"
#import "../../LevelPlayUtils.h"

@interface LevelPlayInterstitialAdDelegate ()

@property (nonatomic, assign) int adObjectId DEPRECATED_MSG_ATTRIBUTE(
                                                                     "This parameter will be removed in version 9.0.0. Please use adId parameter instead.");;
@property (nonatomic, strong) NSString* adId;
@property (nonatomic, strong) FlutterMethodChannel *channel;

@end

@implementation LevelPlayInterstitialAdDelegate

- (instancetype)initWithAdId:(NSString *)adId
                     channel:(FlutterMethodChannel *)channel {
    self = [super init];
    if (self) {
        _adId = adId;
        _channel = channel;
    }
    return self;
}

- (void)didLoadAdWithAdInfo:(LPMAdInfo *)adInfo {
    NSDictionary *args = @{
            @"adId": self.adId,
            @"adInfo": [LevelPlayUtils dictionaryForLevelPlayAdInfo:adInfo]
    };
    [LevelPlayUtils invokeMethodOnUiThreadWithChannel: self.channel methodName: @"onInterstitialAdLoaded" args: args];
}

- (void)didFailToLoadAdWithAdUnitId:(NSString *)adUnitId error:(NSError *)error {
    NSDictionary *args = @{
            @"adId": self.adId,
            @"error": [LevelPlayUtils dictionaryForLevelPlayAdError:error adUnitId:adUnitId]
    };
    [LevelPlayUtils invokeMethodOnUiThreadWithChannel: self.channel methodName: @"onInterstitialAdLoadFailed" args: args];
}

- (void)didChangeAdInfo:(LPMAdInfo *)adInfo {
    NSDictionary *args = @{
            @"adId": self.adId,
            @"adInfo": [LevelPlayUtils dictionaryForLevelPlayAdInfo:adInfo]
    };
    [LevelPlayUtils invokeMethodOnUiThreadWithChannel: self.channel methodName: @"onInterstitialAdInfoChanged" args: args];
}

- (void)didDisplayAdWithAdInfo:(LPMAdInfo *)adInfo {
    NSDictionary *args = @{
            @"adId": self.adId,
            @"adInfo": [LevelPlayUtils dictionaryForLevelPlayAdInfo:adInfo]
    };
    [LevelPlayUtils invokeMethodOnUiThreadWithChannel: self.channel methodName: @"onInterstitialAdDisplayed" args: args];
}

- (void)didFailToDisplayAdWithAdInfo:(LPMAdInfo *)adInfo error:(NSError *)error {
    NSDictionary *args = @{
            @"adId": self.adId,
            @"adInfo": [LevelPlayUtils dictionaryForLevelPlayAdInfo:adInfo],
            @"error": [LevelPlayUtils dictionaryForLevelPlayAdError:error adUnitId:adInfo.adUnitId]
    };
    [LevelPlayUtils invokeMethodOnUiThreadWithChannel: self.channel methodName: @"onInterstitialAdDisplayFailed" args: args];
}

- (void)didClickAdWithAdInfo:(LPMAdInfo *)adInfo {
    NSDictionary *args = @{
            @"adId": self.adId,
            @"adInfo": [LevelPlayUtils dictionaryForLevelPlayAdInfo:adInfo]
    };
    [LevelPlayUtils invokeMethodOnUiThreadWithChannel: self.channel methodName: @"onInterstitialAdClicked" args: args];
}

- (void)didCloseAdWithAdInfo:(LPMAdInfo *)adInfo {
    NSDictionary *args = @{
            @"adId": self.adId,
            @"adInfo": [LevelPlayUtils dictionaryForLevelPlayAdInfo:adInfo]
    };
    [LevelPlayUtils invokeMethodOnUiThreadWithChannel: self.channel methodName: @"onInterstitialAdClosed" args: args];
}

@end
