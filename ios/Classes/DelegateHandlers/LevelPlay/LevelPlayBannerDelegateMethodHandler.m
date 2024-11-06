#import "LevelPlayBannerDelegateMethodHandler.h"
#import "../../LevelPlayUtils.h"

@implementation LevelPlayBannerDelegateMethodHandler


- (instancetype)initWithChannel:(FlutterMethodChannel *)channel onDidLoadLevelPlayBanner:(void (^)(ISBannerView *bannerView, ISAdInfo *adInfo))onDidLoadLevelPlayBanner {
    self = [super initWithChannel:channel];
    if (self) {
        _onDidLoadLevelPlayBanner = onDidLoadLevelPlayBanner;
        [IronSource setLevelPlayBannerDelegate:self];
    }
    return self;
}

#pragma mark - LevelPlayBannerDelegate

- (void)didLoad:(ISBannerView *)bannerView withAdInfo:(ISAdInfo *)adInfo {
    if (self.onDidLoadLevelPlayBanner) {
            self.onDidLoadLevelPlayBanner(bannerView, adInfo);
        }
    [self invokeChannelMethodWithName:@"LevelPlay_Banner:onAdLoaded" args: [LevelPlayUtils dictionaryForAdInfo: adInfo]];
}

- (void)didFailToLoadWithError:(NSError *)error {
    [self invokeChannelMethodWithName:@"LevelPlay_Banner:onAdLoadFailed" args: [LevelPlayUtils dictionaryForError: error]];
}

- (void)didClickWithAdInfo:(ISAdInfo *)adInfo {
    [self invokeChannelMethodWithName:@"LevelPlay_Banner:onAdClicked" args: [LevelPlayUtils dictionaryForAdInfo: adInfo]];
}

- (void)didPresentScreenWithAdInfo:(ISAdInfo *)adInfo {
    [self invokeChannelMethodWithName:@"LevelPlay_Banner:onAdScreenPresented" args: [LevelPlayUtils dictionaryForAdInfo: adInfo]];
}

- (void)didDismissScreenWithAdInfo:(ISAdInfo *)adInfo {
    [self invokeChannelMethodWithName:@"LevelPlay_Banner:onAdScreenDismissed" args: [LevelPlayUtils dictionaryForAdInfo: adInfo]];
}

- (void)didLeaveApplicationWithAdInfo:(ISAdInfo *)adInfo {
    [self invokeChannelMethodWithName:@"LevelPlay_Banner:onAdLeftApplication" args: [LevelPlayUtils dictionaryForAdInfo: adInfo]];
}

@end
 
