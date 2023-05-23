#import "LevelPlayInterstitialDelegateMethodHandler.h"
#import "IronSourceError.h"
#import "AdInfo.h"
#import "LevelPlayArgUtils.h"

@implementation LevelPlayInterstitialDelegateMethodHandler

#pragma mark - LevelPlayInterstitialDelegate

- (void)didLoadWithAdInfo:(ISAdInfo *)adInfo {
    [self invokeChannelMethodWithName:@"LevelPlay_Interstitial:onAdReady" args:[adInfo toArgDictionary]];
}

- (void)didFailToLoadWithError:(NSError *)error {
    [self invokeChannelMethodWithName:@"LevelPlay_Interstitial:onAdLoadFailed" args:[error toArgDictionary]];
}

- (void)didOpenWithAdInfo:(ISAdInfo *)adInfo {
    [self invokeChannelMethodWithName:@"LevelPlay_Interstitial:onAdOpened" args:[adInfo toArgDictionary]];
}

- (void)didCloseWithAdInfo:(ISAdInfo *)adInfo {
    [self invokeChannelMethodWithName:@"LevelPlay_Interstitial:onAdClosed" args:[adInfo toArgDictionary]];
}

- (void)didFailToShowWithError:(NSError *)error
                     andAdInfo:(ISAdInfo *)adInfo {
    [self invokeChannelMethodWithName:@"LevelPlay_Interstitial:onAdShowFailed"
                                 args:[LevelPlayArgUtils getDictionaryWithError:error andAdInfo:adInfo]];
}

- (void)didClickWithAdInfo:(ISAdInfo *)adInfo {
    [self invokeChannelMethodWithName:@"LevelPlay_Interstitial:onAdClicked" args:[adInfo toArgDictionary]];
}

- (void)didShowWithAdInfo:(ISAdInfo *)adInfo {
    [self invokeChannelMethodWithName:@"LevelPlay_Interstitial:onAdShowSucceeded" args:[adInfo toArgDictionary]];
}

@end
