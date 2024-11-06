#import <IronSource/IronSource.h>
#import "LevelPlayBannerAdView.h"
#import "LevelPlayUtils.h"

@interface LevelPlayBannerAdView()<LPMBannerAdViewDelegate>

// MARK: Properties

@property (nonatomic, strong) FlutterMethodChannel *methodChannel;
@property (nonatomic, strong) LPMBannerAdView *bannerAdView;

@end

@implementation LevelPlayBannerAdView

// MARK: Initialization

- (instancetype)initWithFrame:(CGRect)frame
                       viewId:(int64_t)viewId
        levelPlayBinaryMessenger:(id<FlutterBinaryMessenger>)levelPlayBinaryMessenger
        bannerAdView:(LPMBannerAdView *)bannerAdView
        viewType:(NSString *)viewType
{
    self = [super init];
    if ( self )
    {
        self.bannerAdView = bannerAdView;
        [self.bannerAdView setDelegate: self];

        NSString *uniqueChannelName = [NSString stringWithFormat: @"%@_%lld", viewType, viewId];
        self.methodChannel = [FlutterMethodChannel methodChannelWithName: uniqueChannelName binaryMessenger: levelPlayBinaryMessenger];

        __weak typeof(self) weakSelf = self;
        [self.methodChannel setMethodCallHandler:^(FlutterMethodCall *call, FlutterResult result) {
            [weakSelf handleMethodCall:call result:result];
        }];
    }
    return self;
}

// MARK: Method Call Handling

/**
 Handles method calls received from Flutter.

 @param call The method call received from Flutter.
 @param result The result to be sent back to Flutter.
 */
- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *methodName = call.method;

    if ([methodName isEqualToString:@"loadAd"]) {
        [self loadAd:result];
    } else if ([methodName isEqualToString:@"destroyBanner"]) {
        [self destroyBanner:result];
    } else if ([methodName isEqualToString:@"pauseAutoRefresh"]) {
        [self pauseAutoRefresh:result];
    } else if ([methodName isEqualToString:@"resumeAutoRefresh"]) {
        [self resumeAutoRefresh:result];
    }  else {
        result(FlutterMethodNotImplemented);
    }
}

// MARK: Banner Ad View Methods

- (void)loadAd:(FlutterResult)result {
    [_bannerAdView loadAdWithViewController: [LevelPlayUtils getRootViewController]];
    result(nil);
}

- (void)destroyBanner:(FlutterResult)result {
    [_bannerAdView destroy];
    result(nil);
}

- (void)pauseAutoRefresh:(FlutterResult)result {
    [_bannerAdView pauseAutoRefresh];
    result(nil);
}

- (void)resumeAutoRefresh:(FlutterResult)result {
    [_bannerAdView resumeAutoRefresh];
    result(nil);
}

// MARK: View

- (LPMBannerAdView *)view
{
    return self.bannerAdView;
}

// MARK: Deallocation

- (void)dealloc
{
    // Destroy the ad
    [self.bannerAdView destroy];
    // Ensure method channel is set
    if (self.methodChannel != nil) {
        // Retain the method channel temporarily to avoid deallocation during the async block
        FlutterMethodChannel *methodChannel = self.methodChannel;
        // Set method call handler to nil on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [methodChannel setMethodCallHandler:nil];
        });
        // Release the retained method channel after async block execution
        self.methodChannel = nil;
    }
}

// MARK: LPMBannerAdViewDelegate

- (void)didLoadAdWithAdInfo:(LPMAdInfo *) adInfo {
    NSDictionary *args = @{
            @"adInfo": [LevelPlayUtils dictionaryForLevelPlayAdInfo:adInfo]
    };
    [LevelPlayUtils invokeMethodOnUiThreadWithChannel: self.methodChannel methodName: @"onAdLoaded" args: args];
}

- (void)didFailToLoadAdWithAdUnitId:(NSString *)adUnitId error:(NSError *)error {
    NSDictionary *args = @{
            @"error": [LevelPlayUtils dictionaryForLevelPlayAdError:error adUnitId:adUnitId]
    };
    [LevelPlayUtils invokeMethodOnUiThreadWithChannel: self.methodChannel methodName: @"onAdLoadFailed" args: args];
}

- (void)didClickAdWithAdInfo:(LPMAdInfo *)adInfo {
    NSDictionary *args = @{
            @"adInfo": [LevelPlayUtils dictionaryForLevelPlayAdInfo:adInfo]
    };
    [LevelPlayUtils invokeMethodOnUiThreadWithChannel: self.methodChannel methodName: @"onAdClicked" args: args];
}

- (void)didDisplayAdWithAdInfo:(LPMAdInfo *)adInfo {
    NSDictionary *args = @{
            @"adInfo": [LevelPlayUtils dictionaryForLevelPlayAdInfo:adInfo]
    };
    [LevelPlayUtils invokeMethodOnUiThreadWithChannel: self.methodChannel methodName: @"onAdDisplayed" args: args];
}

- (void)didFailToDisplayAdWithAdInfo:(LPMAdInfo *)adInfo error:(NSError *)error {
    NSDictionary *args = @{
            @"adInfo": [LevelPlayUtils dictionaryForLevelPlayAdInfo:adInfo],
            @"error": [LevelPlayUtils dictionaryForLevelPlayAdError:error adUnitId:adInfo.adUnitId],
    };
    [LevelPlayUtils invokeMethodOnUiThreadWithChannel: self.methodChannel methodName: @"onAdDisplayFailed" args: args];
}

- (void)didLeaveAppWithAdInfo:(LPMAdInfo *)adInfo {
    NSDictionary *args = @{
            @"adInfo": [LevelPlayUtils dictionaryForLevelPlayAdInfo:adInfo]
    };
    [LevelPlayUtils invokeMethodOnUiThreadWithChannel: self.methodChannel methodName: @"onAdLeftApplication" args: args];
}

- (void)didExpandAdWithAdInfo:(LPMAdInfo *)adInfo {
    NSDictionary *args = @{
            @"adInfo": [LevelPlayUtils dictionaryForLevelPlayAdInfo:adInfo]
    };
    [LevelPlayUtils invokeMethodOnUiThreadWithChannel: self.methodChannel methodName: @"onAdExpanded" args: args];
}

- (void)didCollapseAdWithAdInfo:(LPMAdInfo *)adInfo {
    NSDictionary *args = @{
            @"adInfo": [LevelPlayUtils dictionaryForLevelPlayAdInfo:adInfo]
    };
    [LevelPlayUtils invokeMethodOnUiThreadWithChannel: self.methodChannel methodName: @"onAdCollapsed" args: args];
}

@end
