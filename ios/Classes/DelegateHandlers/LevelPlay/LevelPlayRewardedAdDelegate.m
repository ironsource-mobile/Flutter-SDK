#import "LevelPlayRewardedAdDelegate.h"
#import "../../LevelPlayUtils.h"

@interface LevelPlayRewardedAdDelegate ()

@property (nonatomic, assign) int adObjectId;
@property (nonatomic, strong) FlutterMethodChannel *channel;

@end

@implementation LevelPlayRewardedAdDelegate

- (instancetype)initWithAdObjectId:(int)adObjectId
                           channel:(FlutterMethodChannel *)channel {
    self = [super init];
    if (self) {
        _adObjectId = adObjectId;
        _channel = channel;
    }
    return self;
}

- (void)didLoadAdWithAdInfo:(LPMAdInfo *)adInfo {
    NSDictionary *args = @{
            @"adObjectId": @(self.adObjectId),
            @"adInfo": [LevelPlayUtils dictionaryForLevelPlayAdInfo:adInfo]
    };
    [LevelPlayUtils invokeMethodOnUiThreadWithChannel: self.channel methodName: @"onRewardedAdLoaded" args: args];
}

- (void)didFailToLoadAdWithAdUnitId:(NSString *)adUnitId error:(NSError *)error {
    NSDictionary *args = @{
            @"adObjectId": @(self.adObjectId),
            @"error": [LevelPlayUtils dictionaryForLevelPlayAdError:error adUnitId:adUnitId]
    };
    [LevelPlayUtils invokeMethodOnUiThreadWithChannel: self.channel methodName: @"onRewardedAdLoadFailed" args: args];
}

- (void)didChangeAdInfo:(LPMAdInfo *)adInfo {
    NSDictionary *args = @{
            @"adObjectId": @(self.adObjectId),
            @"adInfo": [LevelPlayUtils dictionaryForLevelPlayAdInfo:adInfo]
    };
    [LevelPlayUtils invokeMethodOnUiThreadWithChannel: self.channel methodName: @"onRewardedAdInfoChanged" args: args];
}

- (void)didDisplayAdWithAdInfo:(LPMAdInfo *)adInfo {
    NSDictionary *args = @{
            @"adObjectId": @(self.adObjectId),
            @"adInfo": [LevelPlayUtils dictionaryForLevelPlayAdInfo:adInfo]
    };
    [LevelPlayUtils invokeMethodOnUiThreadWithChannel: self.channel methodName: @"onRewardedAdDisplayed" args: args];
}

- (void)didFailToDisplayAdWithAdInfo:(LPMAdInfo *)adInfo error:(NSError *)error {
    NSDictionary *args = @{
            @"adObjectId": @(self.adObjectId),
            @"adInfo": [LevelPlayUtils dictionaryForLevelPlayAdInfo:adInfo],
            @"error": [LevelPlayUtils dictionaryForLevelPlayAdError:error adUnitId:adInfo.adUnitId]
    };
    [LevelPlayUtils invokeMethodOnUiThreadWithChannel: self.channel methodName: @"onRewardedAdDisplayFailed" args: args];
}

- (void)didClickAdWithAdInfo:(LPMAdInfo *)adInfo {
    NSDictionary *args = @{
            @"adObjectId": @(self.adObjectId),
            @"adInfo": [LevelPlayUtils dictionaryForLevelPlayAdInfo:adInfo]
    };
    [LevelPlayUtils invokeMethodOnUiThreadWithChannel: self.channel methodName: @"onRewardedAdClicked" args: args];
}

- (void)didCloseAdWithAdInfo:(LPMAdInfo *)adInfo {
    NSDictionary *args = @{
            @"adObjectId": @(self.adObjectId),
            @"adInfo": [LevelPlayUtils dictionaryForLevelPlayAdInfo:adInfo]
    };
    [LevelPlayUtils invokeMethodOnUiThreadWithChannel: self.channel methodName: @"onRewardedAdClosed" args: args];
}

- (void)didRewardAdWithAdInfo:(LPMAdInfo *)adInfo reward:(LPMReward *)reward {
    NSDictionary *args = @{
            @"adObjectId": @(self.adObjectId),
            @"adInfo": [LevelPlayUtils dictionaryForLevelPlayAdInfo:adInfo],
            @"reward": [LevelPlayUtils dictionaryForLPMReward:reward]
    };
    [LevelPlayUtils invokeMethodOnUiThreadWithChannel: self.channel methodName: @"onRewardedAdRewarded" args: args];
}

@end
