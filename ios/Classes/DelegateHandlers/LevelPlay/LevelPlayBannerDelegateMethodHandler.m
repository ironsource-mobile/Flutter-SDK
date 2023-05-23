#import "LevelPlayBannerDelegateMethodHandler.h"
#import "IronSourceError.h"
#import "AdInfo.h"

@implementation LevelPlayBannerDelegateMethodHandler

#pragma mark - LevelPlayBannerDelegate

- (void)didLoad:(ISBannerView *)bannerView withAdInfo:(ISAdInfo *)adInfo {
    [self invokeChannelMethodWithName:@"LevelPlay_Banner:onAdLoaded" args:[adInfo toArgDictionary]];
}

- (void)didFailToLoadWithError:(NSError *)error {
    [self invokeChannelMethodWithName:@"LevelPlay_Banner:onAdLoadFailed" args:[error toArgDictionary]];
}

- (void)didClickWithAdInfo:(ISAdInfo *)adInfo {
    [self invokeChannelMethodWithName:@"LevelPlay_Banner:onAdClicked" args:[adInfo toArgDictionary]];
}

- (void)didPresentScreenWithAdInfo:(ISAdInfo *)adInfo {
    [self invokeChannelMethodWithName:@"LevelPlay_Banner:onAdScreenPresented" args:[adInfo toArgDictionary]];
}

- (void)didDismissScreenWithAdInfo:(ISAdInfo *)adInfo {
    [self invokeChannelMethodWithName:@"LevelPlay_Banner:onAdScreenDismissed" args:[adInfo toArgDictionary]];
}

- (void)didLeaveApplicationWithAdInfo:(ISAdInfo *)adInfo {
    [self invokeChannelMethodWithName:@"LevelPlay_Banner:onAdLeftApplication" args:[adInfo toArgDictionary]];
}

@end
 
