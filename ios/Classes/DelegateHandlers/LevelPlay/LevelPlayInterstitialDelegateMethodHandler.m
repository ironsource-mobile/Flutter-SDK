#import "LevelPlayInterstitialDelegateMethodHandler.h"
#import "../../LevelPlayUtils.h"

@implementation LevelPlayInterstitialDelegateMethodHandler

#pragma mark - LevelPlayInterstitialDelegate

- (void)didLoadWithAdInfo:(ISAdInfo *)adInfo {
    [self invokeChannelMethodWithName:@"LevelPlay_Interstitial:onAdReady" args: [LevelPlayUtils dictionaryForAdInfo: adInfo]];
}

- (void)didFailToLoadWithError:(NSError *)error {
    [self invokeChannelMethodWithName:@"LevelPlay_Interstitial:onAdLoadFailed" args: [LevelPlayUtils dictionaryForError: error]];
}

- (void)didOpenWithAdInfo:(ISAdInfo *)adInfo {
    [self invokeChannelMethodWithName:@"LevelPlay_Interstitial:onAdOpened" args: [LevelPlayUtils dictionaryForAdInfo: adInfo]];
}

- (void)didCloseWithAdInfo:(ISAdInfo *)adInfo {
    [self invokeChannelMethodWithName:@"LevelPlay_Interstitial:onAdClosed" args: [LevelPlayUtils dictionaryForAdInfo: adInfo]];
}

- (void)didFailToShowWithError:(NSError *)error
                     andAdInfo:(ISAdInfo *)adInfo {
    NSDictionary *args = @{
            @"error": [LevelPlayUtils dictionaryForError: error],
            @"adInfo": [LevelPlayUtils dictionaryForAdInfo: adInfo]
    };
    [self invokeChannelMethodWithName:@"LevelPlay_Interstitial:onAdShowFailed" args:args];
}

- (void)didClickWithAdInfo:(ISAdInfo *)adInfo {
    [self invokeChannelMethodWithName:@"LevelPlay_Interstitial:onAdClicked" args: [LevelPlayUtils dictionaryForAdInfo: adInfo]];
}

- (void)didShowWithAdInfo:(ISAdInfo *)adInfo {
    [self invokeChannelMethodWithName:@"LevelPlay_Interstitial:onAdShowSucceeded" args: [LevelPlayUtils dictionaryForAdInfo: adInfo]];
}

@end
