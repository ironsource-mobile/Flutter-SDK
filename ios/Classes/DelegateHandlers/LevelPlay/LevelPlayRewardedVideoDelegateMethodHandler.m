#import "LevelPlayRewardedVideoDelegateMethodHandler.h"
#import "../../LevelPlayUtils.h"

@implementation LevelPlayRewardedVideoDelegateMethodHandler

#pragma mark - LevelPlayRewardedVideoDelegate

- (void)hasAvailableAdWithAdInfo:(ISAdInfo *)adInfo {
    [self invokeChannelMethodWithName:@"LevelPlay_RewardedVideo:onAdAvailable" args: [LevelPlayUtils dictionaryForAdInfo: adInfo]];
}

- (void)hasNoAvailableAd {
    [self invokeChannelMethodWithName:@"LevelPlay_RewardedVideo:onAdUnavailable" args:nil];
}

- (void)didReceiveRewardForPlacement:(ISPlacementInfo *)placementInfo withAdInfo:(ISAdInfo *)adInfo {
    NSDictionary *args = @{
            @"placement": [LevelPlayUtils dictionaryForPlacementInfo: placementInfo],
            @"adInfo": [LevelPlayUtils dictionaryForAdInfo: adInfo]
    };
    [self invokeChannelMethodWithName:@"LevelPlay_RewardedVideo:onAdRewarded" args: args];
}

- (void)didFailToShowWithError:(NSError *)error andAdInfo:(ISAdInfo *)adInfo {
    NSDictionary *args = @{
            @"error": [LevelPlayUtils dictionaryForError: error],
            @"adInfo": [LevelPlayUtils dictionaryForAdInfo: adInfo]
    };
    [self invokeChannelMethodWithName:@"LevelPlay_RewardedVideo:onAdShowFailed" args: args];
}

- (void)didOpenWithAdInfo:(ISAdInfo *)adInfo {
    [self invokeChannelMethodWithName:@"LevelPlay_RewardedVideo:onAdOpened" args: [LevelPlayUtils dictionaryForAdInfo: adInfo]];
}

- (void)didCloseWithAdInfo:(ISAdInfo *)adInfo {
    [self invokeChannelMethodWithName:@"LevelPlay_RewardedVideo:onAdClosed" args: [LevelPlayUtils dictionaryForAdInfo: adInfo]];
}


- (void)didClick:(ISPlacementInfo *)placementInfo withAdInfo:(ISAdInfo *)adInfo {
    NSDictionary *args = @{
            @"placement": [LevelPlayUtils dictionaryForPlacementInfo: placementInfo],
            @"adInfo": [LevelPlayUtils dictionaryForAdInfo: adInfo]
    };
    [self invokeChannelMethodWithName:@"LevelPlay_RewardedVideo:onAdClicked" args: args];
}

#pragma mark - LevelPlayRewardedVideoManualDelegate

- (void)didLoadWithAdInfo:(ISAdInfo *)adInfo {
    [self invokeChannelMethodWithName:@"LevelPlay_RewardedVideo:onAdReady" args: [LevelPlayUtils dictionaryForAdInfo: adInfo]];
}

- (void)didFailToLoadWithError:(NSError *)error {
    [self invokeChannelMethodWithName:@"LevelPlay_RewardedVideo:onAdLoadFailed" args: [LevelPlayUtils dictionaryForError: error]];
}

@end
