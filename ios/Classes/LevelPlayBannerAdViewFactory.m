#import "LevelPlayBannerAdViewFactory.h"
#import "LevelPlayBannerAdView.h"
#import <IronSource/IronSource.h>

@interface LevelPlayBannerAdViewFactory()
@property (nonatomic, strong) id<FlutterBinaryMessenger> levelPlayBinaryMessenger;
@end

@implementation LevelPlayBannerAdViewFactory

- (instancetype)initWithMessenger:(id<FlutterBinaryMessenger>)levelPlayBinaryMessenger
{
    self = [super init];
    if ( self )
    {
        self.levelPlayBinaryMessenger = levelPlayBinaryMessenger;
    }
    return self;
}

/**
 Creates an instance of FlutterStandardMessageCodec.

 @return An instance of FlutterStandardMessageCodec.
 */
- (id<FlutterMessageCodec>)createArgsCodec
{
    return [FlutterStandardMessageCodec sharedInstance];
}

- (id<FlutterPlatformView>)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args
{
    // Extract variables from dict
    NSString *adUnitId = args[@"adUnitId"];
    NSString *viewType = args[@"viewType"];
    NSString *placementName = [args[@"placementName"] isKindOfClass:[NSString class]] ? args[@"placementName"] : nil;
    NSDictionary *adSizeDict = args[@"adSize"];
    LPMAdSize *adSize = [self getLevelPlayAdSize:adSizeDict];
    LPMBannerAdView *bannerAdView = [[LPMBannerAdView alloc] initWithAdUnitId: adUnitId];
    if (adSize != nil) {
        [bannerAdView setAdSize:adSize];
    }
    if (placementName != nil) {
        [bannerAdView setPlacementName: placementName];
    }
    return [[LevelPlayBannerAdView alloc] initWithFrame:frame
                                                 viewId:viewId
                               levelPlayBinaryMessenger:self.levelPlayBinaryMessenger
                                           bannerAdView: bannerAdView
                                               viewType: viewType];
}

- (LPMAdSize *)getLevelPlayAdSize:(NSDictionary *)adSizeDict {
    NSNumber *widthNumber = adSizeDict[@"width"];
    NSNumber *heightNumber = adSizeDict[@"height"];
    NSString *adLabel = adSizeDict[@"adLabel"];
    NSNumber *isAdaptiveNumber = adSizeDict[@"isAdaptive"];

    int width = [widthNumber intValue];
    int height = [heightNumber intValue];
    BOOL isAdaptive = [isAdaptiveNumber boolValue];
    CGFloat widthFloat = [widthNumber floatValue];

    // At this point, developer has provided ad size, which means checks for
    // width and height already performed by the sdk and no need to check again.
    if (isAdaptive) {
        // Valid width provided as adaptive already called if entered here
        return [LPMAdSize createAdaptiveAdSizeWithWidth: widthFloat];
    } else if ([adLabel isEqualToString:@"BANNER"]) {
        return [LPMAdSize bannerSize];
    } else if ([adLabel isEqualToString:@"LARGE"]) {
        return [LPMAdSize largeSize];
    } else if ([adLabel isEqualToString:@"MEDIUM_RECTANGLE"]) {
        return [LPMAdSize mediumRectangleSize];
    } else if ([adLabel isEqualToString:@"CUSTOM"]) {
        return [LPMAdSize customSizeWithWidth:width height:height];
    } else {
        return nil;
    }
}

@end
