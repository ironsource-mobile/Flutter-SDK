#import "LevelPlayRewardedVideoDelegateMethodHandler.h"
#import "IronSourceError.h"
#import "AdInfo.h"
#import "LevelPlayArgUtils.h"

@implementation LevelPlayRewardedVideoDelegateMethodHandler

#pragma mark - LevelPlayRewardedVideoDelegate

- (void)hasAvailableAdWithAdInfo:(ISAdInfo *)adInfo {
    [self invokeChannelMethodWithName:@"LevelPlay_RewardedVideo:onAdAvailable" args:[adInfo toArgDictionary]];
}

- (void)hasNoAvailableAd {
    [self invokeChannelMethodWithName:@"LevelPlay_RewardedVideo:onAdUnavailable" args:nil];
}

- (void)didReceiveRewardForPlacement:(ISPlacementInfo *)placementInfo withAdInfo:(ISAdInfo *)adInfo {
    [self invokeChannelMethodWithName:@"LevelPlay_RewardedVideo:onAdRewarded" args:[LevelPlayArgUtils getDictionaryWithPlacement:placementInfo andAdInfo:adInfo]];
}

- (void)didFailToShowWithError:(NSError *)error andAdInfo:(ISAdInfo *)adInfo {
    [self invokeChannelMethodWithName:@"LevelPlay_RewardedVideo:onAdShowFailed" args:[LevelPlayArgUtils getDictionaryWithError:error andAdInfo:adInfo]];
}

- (void)didOpenWithAdInfo:(ISAdInfo *)adInfo {
    [self invokeChannelMethodWithName:@"LevelPlay_RewardedVideo:onAdOpened" args:[adInfo toArgDictionary]];
}

- (void)didCloseWithAdInfo:(ISAdInfo *)adInfo {
    [self invokeChannelMethodWithName:@"LevelPlay_RewardedVideo:onAdClosed" args:[adInfo toArgDictionary]];
}


- (void)didClick:(ISPlacementInfo *)placementInfo withAdInfo:(ISAdInfo *)adInfo {
    [self invokeChannelMethodWithName:@"LevelPlay_RewardedVideo:onAdClicked" args:[LevelPlayArgUtils getDictionaryWithPlacement:placementInfo andAdInfo:adInfo]];
}

#pragma mark - LevelPlayRewardedVideoManualDelegate

- (void)didLoadWithAdInfo:(ISAdInfo *)adInfo {
    [self invokeChannelMethodWithName:@"LevelPlay_RewardedVideo:onAdReady" args:[adInfo toArgDictionary]];
}

- (void)didFailToLoadWithError:(NSError *)error {
    [self invokeChannelMethodWithName:@"LevelPlay_RewardedVideo:onAdLoadFailed" args:[error toArgDictionary]];
}

@end
