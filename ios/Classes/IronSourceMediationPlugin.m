#import "IronSourceMediationPlugin.h"
#import <IronSource/IronSource.h>
#import "ATTrackingManagerChannel.h"
#import "InitDelegateMethodHandler.h"
#import "ConsentViewDelegateMethodHandler.h"
#import "ImpressionDataDelegateMethodHandler.h"
#import "ISPlacementInfo.h"
#import "LevelPlayRewardedVideoDelegateMethodHandler.h"
#import "LevelPlayInterstitialDelegateMethodHandler.h"
#import "LevelPlayBannerDelegateMethodHandler.h"
#import "LevelPlayNativeAdViewFactoryTemplate.h"
#import "LevelPlayNativeAdViewFactory.h"
#import "LevelPlayNativeAdView.h"
#import "LevelPlayUtils.h"

@interface IronSourceMediationPlugin()
@property (nonatomic,strong) FlutterMethodChannel* channel;
@property (nonatomic,weak) ISBannerView* bannerView;
@property (nonatomic,strong) NSNumber* bannerOffset;
@property (nonatomic) NSInteger bannerPosition;
@property (nonatomic) BOOL shouldHideBanner;
@property (nonatomic,strong) UIViewController* bannerViewController;
@property (nonatomic,strong) InitDelegateMethodHandler* initializationDelegate;
@property (nonatomic,strong) UIViewController* CurrentViewController;
@property (nonatomic,strong) NSObject<FlutterPluginRegistrar> *registrar;
@property (nonatomic, strong) NSMutableDictionary<NSString *, LevelPlayNativeAdViewFactory *> *nativeAdViewFactories;

@end

static IronSourceMediationPlugin *instance = nil;

@implementation IronSourceMediationPlugin

- (id)initWithChannel:(FlutterMethodChannel*)channel {
    if (self = [super init]) {
        // observe device orientation changes
        // observe device orientation changes
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didChangeOrientation:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
        self.channel = channel;
        self.shouldHideBanner = NO;
    }
    return self;
}

// for banner center recalibration
- (void)didChangeOrientation:(NSNotification*)notification {
    [self setBannerCenter];
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"ironsource_mediation"
                                     binaryMessenger:[registrar messenger]];
    if (!instance) {
        instance = [[IronSourceMediationPlugin alloc] initWithChannel:channel];
        instance.registrar = registrar;
        instance.nativeAdViewFactories = [NSMutableDictionary dictionary];
    }
    __weak IronSourceMediationPlugin *weakInstance = instance; // Capture a weak reference to the instance
    [registrar addMethodCallDelegate:instance channel:channel];
    
    // Set ironSource delegates
    // Init
    instance.initializationDelegate = [[InitDelegateMethodHandler alloc] initWithChannel:channel];
    // ConsentView
    [IronSource setConsentViewWithDelegate: [[ConsentViewDelegateMethodHandler alloc] initWithChannel:channel]];
    // Imp Data
    [IronSource addImpressionDataDelegate:[[ImpressionDataDelegateMethodHandler alloc] initWithChannel:channel]];
    
# pragma mark - LevelPlay Delegates=========================================================================
    // LevelPlay RewardedVideo
     [IronSource setLevelPlayRewardedVideoDelegate:[[LevelPlayRewardedVideoDelegateMethodHandler alloc] initWithChannel:channel]];
    // LevelPlay Interstitial
    [IronSource setLevelPlayInterstitialDelegate:[[LevelPlayInterstitialDelegateMethodHandler alloc] initWithChannel:channel]];
    // LevelPlay Banner
    [IronSource setLevelPlayBannerDelegate:[[LevelPlayBannerDelegateMethodHandler alloc] initWithChannel:channel onDidLoadLevelPlayBanner:^(ISBannerView * _Nonnull bannerView, ISAdInfo * _Nonnull adInfo) {
        // LevelPlay banner didLoad - display banner
        [weakInstance onDidLoadLevelPlayBanner:bannerView adInfo:adInfo]; // Use weakInstance to avoid retain cycles
    }]];
    
    // ATT Brigde
    [ATTrackingManagerChannel registerWithMessenger:[registrar messenger]];


    // Native ad view registry
    LevelPlayNativeAdViewFactoryTemplate *nativeAdViewFactory = [[LevelPlayNativeAdViewFactoryTemplate alloc] initWithMessenger:[instance.registrar messenger]];
    [instance.nativeAdViewFactories setValue:nativeAdViewFactory forKey:@"levelPlayNativeAdViewType"];
    [instance.registrar registerViewFactory: nativeAdViewFactory withId: @"levelPlayNativeAdViewType"];
}

/// Clean up
- (void)detachFromEngineForRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar{
    self.channel = nil;
    self.bannerView = nil;
    self.bannerViewController = nil;
    self.bannerOffset = nil;
    self.initializationDelegate = nil;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if([@"validateIntegration" isEqualToString:call.method]) { /* Base API ====================*/
        [self validateIntegration:result];
    } else if([@"shouldTrackNetworkState" isEqualToString:call.method]) {
        [self shouldTrackNetworkState:call.arguments result:result];
    } else if([@"setAdaptersDebug" isEqualToString:call.method]) {
        [self setAdaptersDebug:call.arguments result:result];
    } else if([@"setDynamicUserId" isEqualToString:call.method]) {
        [self setDynamicUserId:call.arguments result:result];
    } else if([@"getAdvertiserId" isEqualToString:call.method]) {
        [self getAdvertiserId:result];
    } else if([@"setConsent" isEqualToString:call.method]) {
        [self setConsent:call.arguments result:result];
    } else if([@"setSegment" isEqualToString:call.method]) {
        [self setSegment:call.arguments result:result];
    } else if([@"setMetaData" isEqualToString:call.method]) {
        [self setMetaData:call.arguments result:result];
    } else if([@"setWaterfallConfiguration" isEqualToString:call.method]) {
        [self setWaterfallConfiguration:call.arguments result:result];
    } else if([@"setUserId" isEqualToString:call.method]) { /* Init API ========================*/
        [self setUserId:call.arguments result:result];
    } else if ([@"init" isEqualToString:call.method]) {
        [self init:call.arguments result:result];
    } else if ([@"launchTestSuite" isEqualToString:call.method]) {
        [self launchTestSuite:result];
    } else if([@"showRewardedVideo" isEqualToString:call.method]) { /* RewardedVideo API ==================*/
        [self showRewardedVideo:call.arguments result:result];
    } else if([@"getRewardedVideoPlacementInfo" isEqualToString:call.method]) {
        [self getRewardedVideoPlacementInfo:call.arguments result:result];
    } else if([@"isRewardedVideoAvailable" isEqualToString:call.method]) {
        [self isRewardedVideoAvailable:result];
    } else if([@"isRewardedVideoPlacementCapped" isEqualToString:call.method]) {
        [self isRewardedVideoPlacementCapped:call.arguments result:result];
    } else if([@"setRewardedVideoServerParams" isEqualToString:call.method]) {
        [self setRewardedVideoServerParams:call.arguments result:result];
    } else if([@"clearRewardedVideoServerParams" isEqualToString:call.method]) {
        [self clearRewardedVideoServerParams:result];
    } else if([@"loadRewardedVideo" isEqualToString:call.method]) {
        [self loadRewardedVideo:result];
    } else if([@"setLevelPlayRewardedVideoManual" isEqualToString:call.method]) {
        [self setLevelPlayRewardedVideoManual:result];
    } else if([@"loadInterstitial" isEqualToString:call.method]) { /* Interstitial API ===================*/
        [self loadInterstitial:result];
    } else if([@"showInterstitial" isEqualToString:call.method]) {
        [self showInterstitial:call.arguments result:result];
    } else if([@"isInterstitialReady" isEqualToString:call.method]) {
        [self isInterstitialReady:result];
    } else if([@"isInterstitialPlacementCapped" isEqualToString:call.method]) {
        [self isInterstitialPlacementCapped:call.arguments result:result];
    } else if([@"loadBanner" isEqualToString:call.method]) { /* Banner API =========================*/
        [self loadBanner:call.arguments result:result];
    } else if([@"destroyBanner" isEqualToString:call.method]) {
        [self destroyBanner:result];
    } else if([@"displayBanner" isEqualToString:call.method]) {
        [self displayBanner:result];
    } else if([@"hideBanner" isEqualToString:call.method]) {
        [self hideBanner:result];
    } else if([@"isBannerPlacementCapped" isEqualToString:call.method]) {
        [self isBannerPlacementCapped:call.arguments result:result];
    } else if([@"getMaximalAdaptiveHeight" isEqualToString:call.method]) {
        [self getMaximalAdaptiveHeight:call.arguments result:result];
    } else if([@"setClientSideCallbacks" isEqualToString:call.method]) { /* Config API =========*/
        [self setClientSideCallbacks:call.arguments result:result];
    } else if([@"getConversionValue" isEqualToString:call.method]) { /* ConversionValue API ====*/
        [self getConversionValue:result];
    } else if([@"loadConsentViewWithType" isEqualToString:call.method]) { /* ConsentView API ===*/
        [self loadConsentViewWithType:call.arguments result:result];
    } else if([@"showConsentViewWithType" isEqualToString:call.method]) {
        [self showConsentViewWithType:call.arguments result:result];
    } else if([@"setPluginData" isEqualToString:call.method]) { /* Internal Config API =*/
        [self setPluginData:call.arguments result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

# pragma mark - Base API =========================================================================

/**
 * Validates the integration of the SDK.
 *
 * @param result The result to be returned after validating the integration.
 */
- (void)validateIntegration:(nonnull FlutterResult)result {
    [ISIntegrationHelper validateIntegration];
    return result(nil);
}

/**
 * Indicates whether IronSource should track network state.
 *
 * @param args   The arguments containing the network state tracking information.
 * @param result The result to be returned after processing.
 */
- (void)shouldTrackNetworkState:(nullable id) args result:(nonnull FlutterResult)result {
    if(!args){
        return result([FlutterError errorWithCode:@"ERROR" message:@"arguments are missing" details:nil]);
    }
    NSNumber *isEnabledNum = [args valueForKey:@"isEnabled"];
    if(isEnabledNum == nil || [[NSNull null] isEqual:isEnabledNum]){
        return result([FlutterError errorWithCode:@"ERROR" message:@"isEnabled is missing" details:nil]);
    }
    BOOL isEnabled = [isEnabledNum boolValue];
    [IronSource shouldTrackReachability:isEnabled];
    return result(nil);
}

/**
 * Enables or disables debug mode for adapters.
 *
 * @param args   The arguments containing the debug mode information.
 * @param result The result to be returned after processing.
 */
- (void)setAdaptersDebug:(nullable id) args result:(nonnull FlutterResult)result {
    if(!args){
        return result([FlutterError errorWithCode:@"ERROR" message:@"arguments are missing" details:nil]);
    }
    NSNumber *isEnabledNum = [args valueForKey:@"isEnabled"];
    if(isEnabledNum == nil || [[NSNull null] isEqual:isEnabledNum]){
        return result([FlutterError errorWithCode:@"ERROR" message:@"isEnabled is missing" details:nil]);
    }
    BOOL isEnabled = [isEnabledNum boolValue];
    [IronSource setAdaptersDebug:isEnabled];
    return result(nil);
}

/**
 * Sets the dynamic user ID for IronSource.
 *
 * @param args   The arguments containing the dynamic user ID.
 * @param result The result to be returned after processing.
 */
- (void)setDynamicUserId:(nullable id) args
                          result:(nonnull FlutterResult)result {
    if(!args){
        return result([FlutterError errorWithCode:@"ERROR" message:@"arguments are missing" details:nil]);
    }
    NSString *userId = [args valueForKey:@"userId"];
    if(userId == nil || [[NSNull null] isEqual:userId]){
        return result([FlutterError errorWithCode:@"ERROR" message:@"userId is missing" details:nil]);
    }
    [IronSource setDynamicUserId:userId];
    return result(nil);
}

/**
 * Retrieves the advertiser ID from IronSource SDK.
 *
 * @param result The result to be returned after processing.
 */
- (void)getAdvertiserId:(nonnull FlutterResult)result {
    NSString *advertiserId = [IronSource advertiserId];
    return result(advertiserId);
}

/**
 * Sets the consent status for IronSource.
 *
 * @param args   The arguments containing the consent status.
 * @param result The result to be returned after processing.
 */
- (void)setConsent:(nullable id) args result:(nonnull FlutterResult)result {
    if(!args){
        return result([FlutterError errorWithCode:@"ERROR" message:@"arguments are missing" details:nil]);
    }
    NSNumber *isConsentNum = [args valueForKey:@"isConsent"];
    if(isConsentNum == nil || [[NSNull null] isEqual:isConsentNum]){
        return result([FlutterError errorWithCode:@"ERROR" message:@"isConsent is missing" details:nil]);
    }
    BOOL isConsent = [isConsentNum boolValue];
    [IronSource setConsent:isConsent];
    return result(nil);
}

/**
 * Sets the segment data for IronSource.
 *
 * @param args   The arguments containing the segment data.
 * @param result The result to be returned after processing.
 */
- (void)setSegment:(nullable id) args result:(nonnull FlutterResult)result  {
    if (!args){
        return result([FlutterError errorWithCode:@"ERROR" message:@"arguments are missing" details:nil]);
    }
    
    NSDictionary *segmentDict = [args valueForKey:@"segment"];
    if (segmentDict == nil || [[NSNull null] isEqual:segmentDict]){
        return result([FlutterError errorWithCode:@"ERROR" message:@"segment is missing" details:nil]);
    }
    
    ISSegment *segment = [[ISSegment alloc] init];
    NSMutableArray<NSString*> *allKeys = [[segmentDict allKeys] mutableCopy];
    for (NSString *key in allKeys)
    {
        if ([key isEqualToString:@"age"]){
            NSNumber *age = [segmentDict objectForKey:key];
            if(age != nil && ![[NSNull null] isEqual:age]){
                segment.age = [age intValue];
            }
        } else if([key isEqualToString:@"gender"]){
            NSString *gender = [segmentDict objectForKey:key];
            if(gender != nil && ![[NSNull null] isEqual:gender]){
                if([gender isEqualToString:@"male"])
                    segment.gender = IRONSOURCE_USER_MALE;
                else if([gender isEqualToString:@"female"])
                    segment.gender = IRONSOURCE_USER_FEMALE;
            }
        } else if ([key isEqualToString:@"level"]){
            NSNumber *level = [segmentDict objectForKey:key];
            if(level != nil && ![[NSNull null] isEqual:level]){
                segment.level = [level intValue];
            }
        } else if ([key isEqualToString:@"isPaying"]){
            NSNumber *isPayingNum = [segmentDict objectForKey:key];
            if(isPayingNum != nil && ![[NSNull null] isEqual:isPayingNum]){
                segment.paying = [isPayingNum boolValue];
            }
        } else if ([key isEqualToString:@"userCreationDate"]){
            NSNumber *ucd = [segmentDict objectForKey:key];
            if(ucd != nil && ![[NSNull null] isEqual:ucd]){
                NSDate *date = [NSDate dateWithTimeIntervalSince1970: [ucd doubleValue]/1000];
                segment.userCreationDate = date;
            }
        } else if ([key isEqualToString:@"segmentName"]){
            NSString *segmentName = [segmentDict objectForKey:key];
            if(segmentName != nil && ![[NSNull null] isEqual:segmentName]){
                segment.segmentName = segmentName;
            }
        } else if ([key isEqualToString:@"iapTotal"]){
            NSNumber *iapTotalNum = [segmentDict objectForKey:key];
            if(iapTotalNum != nil && ![[NSNull null] isEqual:iapTotalNum]){
                segment.iapTotal = [iapTotalNum doubleValue];
            }
        } else {
            NSString *valStr = [segmentDict objectForKey:key];
            if(valStr != nil && ![[NSNull null] isEqual:valStr]){
                [segment setCustomValue:valStr forKey:key];
            }
        }
    }
    [IronSource setSegment:segment];
    return result(nil);
}

/**
 * Sets metadata for IronSource.
 *
 * @param args   The arguments containing the metadata.
 * @param result The result to be returned after processing.
 */
- (void)setMetaData:(nullable id) args
                     result:(nonnull FlutterResult)result  {
    if (!args){
        return result([FlutterError errorWithCode:@"ERROR" message:@"arguments are missing" details:nil]);
    }
    
    NSDictionary<NSString*, NSArray<NSString*>*> *metaDataDict = [args valueForKey:@"metaData"];
    if (metaDataDict == nil || [[NSNull null] isEqual:metaDataDict]){
        return result([FlutterError errorWithCode:@"ERROR" message:@"metaData is missing" details:nil]);
    }
    
    NSMutableArray<NSString*> *allKeys = [[metaDataDict allKeys] mutableCopy];
    for (NSString* key in allKeys)
    {
        NSArray<NSString*> *valArr = [metaDataDict objectForKey:key];
        if(valArr != nil && ![[NSNull null] isEqual:valArr]) {
            [IronSource setMetaDataWithKey:key values:[valArr mutableCopy]];
        }
    }
    return result(nil);
}

/**
 * Launches the IronSource test suite.
 *
 * @param result The result to be returned after processing.
 */
- (void)launchTestSuite:(nonnull FlutterResult)result{
    [IronSource launchTestSuite:[self getRootViewController]];
    return result(nil);
}

/**
 * Sets the waterfall configuration for a given ad unit.
 *
 * @param args   The arguments containing the waterfall configuration data.
 * @param result The result to be returned after processing.
 */
- (void)setWaterfallConfiguration:(nullable id)args result:(FlutterResult)result {
    // Check if arguments are missing
    if (!args) {
        return result([FlutterError errorWithCode:@"ERROR" message:@"arguments are missing" details:nil]);
    }

    // Retrieve waterfall configuration data map from arguments
    NSDictionary *waterfallConfigurationDataMap = [args objectForKey:@"waterfallConfiguration"];

    // Check if waterfall configuration data map is missing
    if (waterfallConfigurationDataMap == nil || [[NSNull null] isEqual:waterfallConfigurationDataMap]) {
        return result([FlutterError errorWithCode:@"ERROR" message:@"waterfallConfiguration is missing" details:nil]);
    }

    // Retrieve ceiling, floor, and ad unit from the waterfall configuration data map
    NSNumber *ceiling = waterfallConfigurationDataMap[@"ceiling"] ?: [NSNull null];
    NSNumber *floor = waterfallConfigurationDataMap[@"floor"] ?: [NSNull null];
    NSString *adUnitString = waterfallConfigurationDataMap[@"adUnit"] ?: [NSNull null];

    // Convert ad unit string to ISAdUnit object
    ISAdUnit *adUnit = [LevelPlayUtils getAdUnit:adUnitString];

    // Check if ad unit exists
    if (adUnit) {
        // Check if both ceiling and floor are present
        if (ceiling && floor) {
            // Build waterfall configuration with ceiling and floor
            ISWaterfallConfigurationBuilder *builder = [ISWaterfallConfiguration builder];
            [builder setCeiling:ceiling];
            [builder setFloor:floor];
            ISWaterfallConfiguration *configuration = [builder build];

            // Set the waterfall configuration for the ad unit
            [IronSource setWaterfallConfiguration:configuration forAdUnit:adUnit];
        }
    }

    // Return success result
    return result(nil);
}

# pragma mark - Init API =========================================================================

//TODO: implement with real error codes

/**
 * Sets the user ID for IronSource.
 *
 * @param args   The arguments containing the user ID.
 * @param result The result to be returned after processing.
 */
- (void)setUserId:(nullable id) args result:(nonnull FlutterResult)result {
    if(!args){
        return result([FlutterError errorWithCode:@"ERROR" message:@"arguments are missing" details:nil]);
    }
    NSString *userId = [args valueForKey:@"userId"];
    if(userId == nil || [[NSNull null] isEqual:userId]){
        return result([FlutterError errorWithCode:@"ERROR" message:@"userId is missing" details:nil]);
    }
    [IronSource setUserId:userId];
    return result(nil);
}

//TODO: Use real error codes
/**
 * Initializes IronSource with the provided app key and ad units.
 *
 * @param args   The arguments containing the app key and ad units.
 * @param result The result to be returned after processing.
 */
- (void)init:(nullable id)args result:(nonnull FlutterResult)result {
    if(!args){
        return result([FlutterError errorWithCode:@"ERROR" message:@"arguments are missing" details:nil]);
    }
    
    NSString *appKey = [args valueForKey:@"appKey"];
    NSArray<NSString*> *adUnits = [args valueForKey:@"adUnits"];
    if(appKey == nil || [[NSNull null] isEqual:appKey]){
        return result([FlutterError errorWithCode:@"ERROR" message:@"appKey is missing" details:nil]);
    }
    
    if(adUnits != nil && adUnits.count){
        NSMutableArray<NSString*> *parsedAdUnits = [[NSMutableArray alloc]init];
        for(NSString *unit in adUnits){
            if([unit isEqualToString:@"REWARDED_VIDEO"]){
                [parsedAdUnits addObject:IS_REWARDED_VIDEO];
            } else if ([unit isEqualToString:@"INTERSTITIAL"]){
                [parsedAdUnits addObject:IS_INTERSTITIAL];
            } else if ([unit isEqualToString:@"BANNER"]){
                [parsedAdUnits addObject:IS_BANNER];
            } else if ([unit isEqualToString:@"NATIVE_AD"]){
                [parsedAdUnits addObject:IS_NATIVE_AD];
            }
        }
        [IronSource initWithAppKey:appKey adUnits:parsedAdUnits delegate:self.initializationDelegate];
    } else {
        [IronSource initWithAppKey:appKey delegate:self.initializationDelegate];
    }

    return result(nil);
}

# pragma mark - RewardedVideo API ===========================================================================

/**
 * Shows a rewarded video ad with an optional placement name.
 *
 * @param args   The arguments containing the placement name (optional).
 * @param result The result to be returned after processing.
 */
- (void)showRewardedVideo:(nullable id) args result:(nonnull FlutterResult)result{
    if(!args){
        return result([FlutterError errorWithCode:@"ERROR" message:@"arguments are missing" details:nil]);
    }
    NSString *placementName = [args valueForKey:@"placementName"];
    if(placementName == nil || [[NSNull null] isEqual:placementName]){
        [IronSource showRewardedVideoWithViewController:[self getRootViewController]];
    } else {
        [IronSource showRewardedVideoWithViewController:[self getRootViewController] placement:placementName];
    }
    return result(nil);
}

/**
 * Retrieves information about a rewarded video placement.
 *
 * @param args   The arguments containing the placement name.
 * @param result The result to be returned after processing.
 */
- (void)getRewardedVideoPlacementInfo:(nullable id) args result:(nonnull FlutterResult)result{
    if(!args){
        return result([FlutterError errorWithCode:@"ERROR" message:@"arguments are missing" details:nil]);
    }
    NSString *placementName = [args valueForKey:@"placementName"];
    if(placementName == nil || [[NSNull null] isEqual:placementName]){
        return result([FlutterError errorWithCode:@"ERROR" message:@"placementName is missing" details:nil]);
    }
    ISPlacementInfo *placementInfo = [IronSource rewardedVideoPlacementInfo:placementName];
    return result(placementInfo != nil ? [placementInfo toArgDictionary] : nil);
}

/**
 * Checks whether a rewarded video ad is available.
 *
 * @param result The result to be returned after processing.
 */
- (void)isRewardedVideoAvailable:(nonnull FlutterResult)result {
    BOOL isRewardedVideoAvailable = [IronSource hasRewardedVideo];
    return result([NSNumber numberWithBool:isRewardedVideoAvailable]);
}

/**
 * Checks whether a rewarded video placement is capped.
 *
 * @param args   The arguments containing the placement name.
 * @param result The result to be returned after processing.
 */
- (void)isRewardedVideoPlacementCapped:(nullable id) args result:(nonnull FlutterResult)result{
    if(!args){
        return result([FlutterError errorWithCode:@"ERROR" message:@"arguments are missing" details:nil]);
    }
    NSString *placementName = [args valueForKey:@"placementName"];
    if(placementName == nil || [[NSNull null] isEqual:placementName]){
        return result([FlutterError errorWithCode:@"ERROR" message:@"placementName is missing" details:nil]);
    }
    BOOL isCapped = [IronSource isRewardedVideoCappedForPlacement:placementName];
    return result([NSNumber numberWithBool:isCapped]);
}

/**
 * Sets server parameters for rewarded video.
 *
 * @param args   The arguments containing the server parameters.
 * @param result The result to be returned after processing.
 */
- (void)setRewardedVideoServerParams:(nullable id) args result:(nonnull FlutterResult)result{
    if(!args){
        return result([FlutterError errorWithCode:@"ERROR" message:@"arguments are missing" details:nil]);
    }
    NSDictionary<NSString*, NSString*> *parameters = [args valueForKey:@"parameters"];
    if(parameters == nil || [[NSNull null] isEqual:parameters]){
        return result([FlutterError errorWithCode:@"ERROR" message:@"paramters is missing" details:nil]);
    }
    [IronSource setRewardedVideoServerParameters:parameters];
    return result(nil);
}

/**
 * Clears server parameters for rewarded video.
 *
 * @param result The result to be returned after processing.
 */
- (void)clearRewardedVideoServerParams:(nonnull FlutterResult)result {
    [IronSource clearRewardedVideoServerParameters];
    return result(nil);
}

# pragma mark - Manual Load RewardedVideo API ==============================================================

/**
 * Sets the manual load rewarded video delegate for IronSource.
 *
 * @param result The result to be returned after processing.
 */
- (void)setLevelPlayRewardedVideoManual:(nonnull FlutterResult)result {
    // Set the level play rewarded video manual delegate with the Flutter channel
    [IronSource setLevelPlayRewardedVideoManualDelegate:[[LevelPlayRewardedVideoDelegateMethodHandler alloc] initWithChannel:_channel]];

    // Return nil to indicate the completion of the method execution
    return result(nil);
}

/**
 * Loads rewarded video ads from the IronSource SDK.
 *
 * @param result The result to be returned after processing.
 */
- (void)loadRewardedVideo:(nonnull FlutterResult)result {
    [IronSource loadRewardedVideo];
    return result(nil);
}

# pragma mark - Interstitial API ===========================================================================

/**
 * Loads interstitial ads from the IronSource SDK.
 *
 * @param result The result to be returned after processing.
 */
- (void)loadInterstitial:(nonnull FlutterResult)result {
    [IronSource loadInterstitial];
    return result(nil);
}

/**
 * Shows an interstitial ad from the IronSource SDK.
 *
 * @param args   The arguments containing the placement name.
 * @param result The result to be returned after processing.
 */
- (void)showInterstitial:(nullable id) args result:(nonnull FlutterResult)result{
    if(!args){
        return result([FlutterError errorWithCode:@"ERROR" message:@"arguments are missing" details:nil]);
    }
    NSString *placementName = [args valueForKey:@"placementName"];
    if(placementName == nil || [[NSNull null] isEqual:placementName]){
        [IronSource showInterstitialWithViewController:[self getRootViewController]];
    } else {
        [IronSource showInterstitialWithViewController:[self getRootViewController] placement:placementName];
    }
    return result(nil);
}

/**
 * Checks whether an interstitial ad is ready to be shown from the IronSource SDK.
 *
 * @param result The result to be returned after processing.
 */
- (void)isInterstitialReady:(nonnull FlutterResult)result {
    BOOL isInterstitialReady = [IronSource hasInterstitial];
    return result([NSNumber numberWithBool:isInterstitialReady]);
}

/**
 * Checks whether the specified placement for interstitial ads is capped.
 *
 * @param args   The arguments containing the placement name.
 * @param result The result to be returned after processing.
 */
- (void)isInterstitialPlacementCapped:(nullable id) args result:(nonnull FlutterResult)result{
    if(!args){
        return result([FlutterError errorWithCode:@"ERROR" message:@"arguments are missing" details:nil]);
    }
    NSString *placementName = [args valueForKey:@"placementName"];
    if(placementName == nil || [[NSNull null] isEqual:placementName]){
        return result([FlutterError errorWithCode:@"ERROR" message:@"placementName is missing" details:nil]);
    }
    BOOL isCapped = [IronSource isInterstitialCappedForPlacement:placementName];
    return result([NSNumber numberWithBool:isCapped]);
}

# pragma mark - Banner API ===========================================================================

/**
 * Loads a banner ad with the specified parameters.
 *
 * @param args   The arguments containing banner parameters.
 * @param result The result to be returned after processing.
 */
- (void)loadBanner:(nullable id) args result:(nonnull FlutterResult)result{
    @synchronized(self) {
        if(!args){
            return result([FlutterError errorWithCode:@"ERROR" message:@"arguments are missing" details:nil]);
        }
        // Get args
        NSString *description = [args valueForKey:@"description"];
        if(description == nil || [[NSNull null] isEqual:description]){
            return result([FlutterError errorWithCode:@"ERROR" message:@"description is missing" details:nil]);
        }
        NSNumber *width = [args valueForKey:@"width"];
        if(width == nil || [[NSNull null] isEqual:width]){
            return result([FlutterError errorWithCode:@"ERROR" message:@"width is missing" details:nil]);
        }
        NSNumber *height = [args valueForKey:@"height"];
        if(height == nil || [[NSNull null] isEqual:height]){
            return result([FlutterError errorWithCode:@"ERROR" message:@"height is missing" details:nil]);
        }
        NSNumber *isAdaptive = [args valueForKey:@"isAdaptive"];
        if(isAdaptive == nil || [[NSNull null] isEqual:isAdaptive]){
            return result([FlutterError errorWithCode:@"ERROR" message:@"isAdaptive is missing" details:nil]);
        }
        NSNumber *containerWidth = [args valueForKey:@"containerWidth"];
        if(containerWidth == nil || [[NSNull null] isEqual:containerWidth]){
            return result([FlutterError errorWithCode:@"ERROR" message:@"containerWidth is missing" details:nil]);
        }
        NSNumber *containerHeight = [args valueForKey:@"containerHeight"];
        if(containerHeight == nil || [[NSNull null] isEqual:containerHeight]){
            return result([FlutterError errorWithCode:@"ERROR" message:@"containerHeight is missing" details:nil]);
        }
        NSNumber *position = [args valueForKey:@"position"];
        if(position == nil || [[NSNull null] isEqual:position]){
            return result([FlutterError errorWithCode:@"ERROR" message:@"position is missing" details:nil]);
        }
        NSNumber *offset = [args valueForKey:@"offset"];
        NSString *placementName = [args valueForKey:@"placementName"];
        
        self.bannerOffset = (offset != nil || [[NSNull null] isEqual:offset]) ? offset : [NSNumber numberWithInt:0];
        self.bannerViewController = [self getRootViewController];
        self.bannerPosition = [position integerValue];

        // Get banner size
        ISBannerSize* size = [self getBannerSize:description width:[width integerValue] height:[height integerValue]];
        // Set isAdaptive
        size.adaptive = [isAdaptive boolValue];
        // Handle banner properties according to isAdaptive value
        if (isAdaptive) {
            // isAdaptive is true
            // Convert NSNumber to CGFloat
            CGFloat containerWidthFloat = [containerWidth doubleValue];
            CGFloat containerHeightFloat = [containerHeight doubleValue];
            // Set container params with width and adaptiveHeight
            ISContainerParams *containerParams = [[ISContainerParams alloc] initWithWidth:containerWidthFloat height:containerHeightFloat];
            [size setContainerParams:containerParams];
        }
        // Load banner view
        // if already loaded, console error would be shown by iS SDK
        if(placementName == nil || [[NSNull null] isEqual:placementName]){
            [IronSource loadBannerWithViewController:_bannerViewController size:size];
        } else {
            [IronSource loadBannerWithViewController:_bannerViewController size:size placement:placementName];
        }
        return result(nil);
    }
}

/**
 * Retrieves the banner size based on the description.
 * Fallbacks to BANNER size in case of an illegal description.
 *
 * @param description The description of the banner size.
 * @param width       The width of the banner.
 * @param height      The height of the banner.
 *
 * @return The ISBannerSize object representing the banner size.
 */
- (ISBannerSize *)getBannerSize:(NSString *)description width:(NSInteger)width height:(NSInteger)height {
    if ([description isEqualToString:@"CUSTOM"]) {
        return [[ISBannerSize alloc] initWithWidth:width andHeight:height];
    } else if ([description isEqualToString:@"SMART"]) {
        return ISBannerSize_SMART;
    } else if ([description isEqualToString:@"BANNER"]) {
        return ISBannerSize_BANNER;
    } else if ([description isEqualToString:@"RECTANGLE"]) {
        return ISBannerSize_RECTANGLE;
    } else if ([description isEqualToString:@"LARGE"]) {
        return ISBannerSize_LARGE;
    } else {
        return ISBannerSize_BANNER;
    }
}

/**
 * Calculates the center point for the banner view based on the position integer.
 * Fallbacks to BOTTOM position in case of an illegal position integer.
 *
 * @param position    The position integer representing the placement of the banner view.
 * @param rootView    The root view where the banner view will be displayed.
 * @param bannerView  The banner view to be positioned.
 * @param offset      The vertical offset for the banner view.
 *
 * @return The CGPoint representing the center point for the banner view.
 */
- (CGPoint)getBannerCenterWithPosition:(NSInteger)position
                              rootView:(UIView *)rootView
                            bannerView:(ISBannerView*) bannerView
                          bannerOffset:(NSNumber*) offset {
    // Positions
    const NSInteger BANNER_POSITION_TOP = 0;
    const NSInteger BANNER_POSITION_CENTER = 1;
    // const NSInteger BANNER_POSITION_BOTTOM = 2;
    
    CGFloat y;
    if (position == BANNER_POSITION_TOP) {
        y = (bannerView.frame.size.height / 2);
        // safe area
        if (@available(ios 11.0, *)) {
            y += rootView.safeAreaInsets.top;
        }
        // vertical offset
        if(offset.intValue > 0){
            y += offset.floatValue;
        }
    } else if (position == BANNER_POSITION_CENTER) {
        y = (rootView.frame.size.height / 2) - (bannerView.frame.size.height / 2);
        // vertical offset
        y += offset.floatValue;
    } else { // BANNER_POSITION_BOTTOM
        y = rootView.frame.size.height - (bannerView.frame.size.height / 2);
        // safe area
        if (@available(ios 11.0, *)) {
            y -= rootView.safeAreaInsets.bottom;
        }
        // vertical offset
        if(offset.intValue < 0){
            y += offset.floatValue;
        }
    }
    return CGPointMake(rootView.frame.size.width / 2, y);
}

/**
 * Destroys the banner view and resets its properties.
 *
 * @param result The result to be returned after destroying the banner view.
 */
- (void)destroyBanner:(nonnull FlutterResult)result {
    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized(self) {
            if (self.bannerView != nil) {
                [IronSource destroyBanner:self.bannerView];
                self.bannerView = nil;
                self.bannerViewController = nil;
                self.bannerOffset = nil;
                self.shouldHideBanner = NO; // Reset the visibility
            }
            return result(nil);
        }
    });
}

/**
 * Displays the banner view.
 *
 * @param result The result to be returned after displaying the banner view.
 */
- (void)displayBanner:(nonnull FlutterResult)result {
    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized(self) {
            if (self.bannerView != nil) {
                self.shouldHideBanner = NO;
                [self.bannerView setHidden:NO];
            }
            return result(nil);
        }
    });
}

/**
 * Hides the banner view.
 *
 * @param result The result to be returned after hiding the banner view.
 */
- (void)hideBanner:(nonnull FlutterResult)result {
    self.shouldHideBanner = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized(self) {
            if (self.bannerView != nil) {
                [self.bannerView setHidden:YES];
            }
            return result(nil);
        }
    });
}

/**
 * Checks if the banner placement is capped.
 *
 * @param args   The arguments containing the placement name.
 * @param result The result to be returned after checking the placement cap.
 */
- (void)isBannerPlacementCapped:(nullable id) args result:(nonnull FlutterResult)result{
    if(!args){
        return result([FlutterError errorWithCode:@"ERROR" message:@"arguments are missing" details:nil]);
    }
    NSString *placementName = [args valueForKey:@"placementName"];
    if(placementName == nil || [[NSNull null] isEqual:placementName]){
        return result([FlutterError errorWithCode:@"ERROR" message:@"placementName is missing" details:nil]);
    }
    BOOL isCapped = [IronSource isBannerCappedForPlacement:placementName];
    return result([NSNumber numberWithBool:isCapped]);
}

/**
 * Sets the center position for the banner view.
 */
- (void)setBannerCenter {
    dispatch_async(dispatch_get_main_queue(), ^{
        @synchronized(self) {
            self.bannerView.center = [self getBannerCenterWithPosition:self.bannerPosition
                                                              rootView:self.bannerViewController.view
                                                            bannerView:self.bannerView
                                                          bannerOffset:self.bannerOffset];
        }
    });
}

/**
 * Returns maximal adaptive height for given width.
 *
 * @param args   The arguments containing the placement name.
 * @param result The result to be returned after checking the placement cap.
 */
- (void)getMaximalAdaptiveHeight:(nullable id) args result:(nonnull FlutterResult)result{
    if(!args){
        return result([FlutterError errorWithCode:@"ERROR" message:@"arguments are missing" details:nil]);
    }
    NSNumber *width = [args valueForKey:@"width"];
    if(width == nil || [[NSNull null] isEqual:width]){
        return result([FlutterError errorWithCode:@"ERROR" message:@"width is missing" details:nil]);
    }
    // Extract the CGFloat value from the NSNumber object
    CGFloat widthFloat = [width doubleValue];

    CGFloat adaptiveHeight = [ISBannerSize getMaximalAdaptiveHeightWithWidth: widthFloat];


    // Convert the CGFloat value to an integer before wrapping it in an NSNumber
    NSInteger adaptiveHeightInteger = (NSInteger)adaptiveHeight;

    // Wrap the integer value in an NSNumber before returning it
    return result([NSNumber numberWithInteger:adaptiveHeightInteger]);
}

- (void)onDidLoadLevelPlayBanner:(ISBannerView *)bannerView adInfo:(ISAdInfo *)adInfo {
    dispatch_async(dispatch_get_main_queue(), ^{
                @synchronized(self) {
                    self.bannerView = bannerView;
                    [self.bannerView setAccessibilityLabel:@"bannerContainer"];
                    [self.bannerView setHidden:self.shouldHideBanner];
                    self.bannerView.center = [self getBannerCenterWithPosition:self.bannerPosition
                                                                                   rootView:self.bannerViewController.view
                                                                                 bannerView:self.bannerView
                                                                               bannerOffset:self.bannerOffset];
                    [self.bannerViewController.view addSubview:self.bannerView];
                }
            });
}


# pragma mark - LevelPlay Native Ad API ===========================================================================

/**
 * Registers a native ad view factory with the Flutter plugin registry.
 * @param registry The FlutterPluginRegistry instance where the factory will be registered.
 * @param viewTypeId The unique identifier for the native ad view factory.
 * @param nativeAdViewFactory The factory object responsible for creating native ad views.
 */
+ (void)registerNativeAdViewFactory:(id<FlutterPluginRegistry>)registry
                      viewTypeId:(NSString *)viewTypeId
        nativeAdViewFactory:(LevelPlayNativeAdViewFactory *)nativeAdViewFactory {
    IronSourceMediationPlugin *flutterPlugin = instance;
    if (!flutterPlugin) {
        [NSException exceptionWithName:NSInvalidArgumentException
                                reason:@"The plugin may have not been registered."
                              userInfo:nil];
    }

    if (flutterPlugin != nil && flutterPlugin.nativeAdViewFactories != nil) {
        // Check if the key already exists in the nativeAdViewFactories dictionary
        if ([flutterPlugin.nativeAdViewFactories objectForKey:viewTypeId]) {
            [NSException raise:NSInvalidArgumentException
                        format:@"A native ad view factory with ID %@ already exists.", viewTypeId];
        }

        // Add the native ad view factory to the nativeAdViewFactories dictionary
        [flutterPlugin.nativeAdViewFactories setValue:nativeAdViewFactory forKey:viewTypeId];

        if (flutterPlugin.registrar) {
            [flutterPlugin.registrar registerViewFactory: nativeAdViewFactory withId: viewTypeId];
        }
    }
}

/**
 Unregisters a native ad view factory from the Flutter plugin registry.

 @param registry The FlutterPluginRegistry instance from which the factory will be unregistered.
 @param viewTypeId The ID of the native ad view factory to be unregistered.
 */
+ (void)unregisterNativeAdViewFactory:
        (id<FlutterPluginRegistry>)registry
        viewTypeId:(NSString *)viewTypeId {
    IronSourceMediationPlugin *flutterPlugin = instance;

    id<FlutterPluginRegistry> factory = flutterPlugin.nativeAdViewFactories[viewTypeId];
    if (factory)
        [flutterPlugin.nativeAdViewFactories removeObjectForKey:viewTypeId];
}

# pragma mark - Config API ===========================================================================

/**
 * Sets whether client-side callbacks are enabled for IronSource.
 *
 * @param args   The arguments containing the boolean value indicating whether client-side callbacks are enabled.
 * @param result The result to be returned after setting client-side callbacks.
 */
- (void)setClientSideCallbacks:(nullable id) args result:(nonnull FlutterResult)result {
    if(!args){
        return result([FlutterError errorWithCode:@"ERROR" message:@"arguments are missing" details:nil]);
    }
    NSNumber *isEnabledNum = [args valueForKey:@"isEnabled"];
    if(isEnabledNum == nil || [[NSNull null] isEqual:isEnabledNum]){
        return result([FlutterError errorWithCode:@"ERROR" message:@"isEnabled is missing" details:nil]);
    }
    [[ISSupersonicAdsConfiguration configurations] setUseClientSideCallbacks: isEnabledNum];
    return result(nil);
}

#pragma mark - Internal Config API ===================================================================

/**
 * Sets plugin data for IronSource.
 *
 * Only called internally in the process of initializing the Flutter plugin.
 * pluginType and pluginVersion are required.
 *
 * @param args   The arguments containing the plugin data.
 * @param result The result to be returned after setting the plugin data.
 */
- (void)setPluginData:(nullable id) args result:(nonnull FlutterResult)result {
    if(!args){
        return result([FlutterError errorWithCode:@"ERROR" message:@"arguments are missing" details:nil]);
    }
    NSString *pluginType = [args valueForKey:@"pluginType"];
    if(pluginType == nil || [[NSNull null] isEqual:pluginType]){
        return result([FlutterError errorWithCode:@"ERROR" message:@"pluginType is missing" details:nil]);
    }
    NSString *pluginVersion = [args valueForKey:@"pluginVersion"];
    if(pluginVersion == nil || [[NSNull null] isEqual:pluginVersion]){
        return result([FlutterError errorWithCode:@"ERROR" message:@"pluginVersion is missing" details:nil]);
    }
    NSString *pluginFrameworkVersion = [args valueForKey:@"pluginFrameworkVersion"];
    
    [ISConfigurations getConfigurations].plugin = pluginType;
    [ISConfigurations getConfigurations].pluginVersion = pluginVersion;
    
    /// Double check if the value is not nil or null. If null is passed, the ironSource SDK would throw since it only checks nil and not null.
    if(pluginFrameworkVersion == nil || [[NSNull null] isEqual:pluginFrameworkVersion]){
        [ISConfigurations getConfigurations].pluginFrameworkVersion = pluginFrameworkVersion;
    }
    
    return result(nil);
}

# pragma mark - ConversionValue API ==================================================================

/**
 * Retrieves the conversion value from IronSource.
 *
 * @param result The result to be returned after retrieving the conversion value.
 */
- (void)getConversionValue:(nonnull FlutterResult)result {
    NSNumber *conversionValue = [IronSource getConversionValue];
    return result(conversionValue);
}

# pragma mark - ConsentView API ======================================================================

/**
 * Loads the consent view with the specified type.
 *
 * @param args   The arguments containing the consent view type.
 * @param result The result to be returned after loading the consent view.
 */
- (void)loadConsentViewWithType:(nullable id) args result:(nonnull FlutterResult)result {
    if(!args){
        return result([FlutterError errorWithCode:@"ERROR" message:@"arguments are missing" details:nil]);
    }
    NSString *consentViewType = [args valueForKey:@"consentViewType"];
    if(consentViewType == nil || [[NSNull null] isEqual:consentViewType]){
        return result([FlutterError errorWithCode:@"ERROR" message:@"consentViewType is missing" details:nil]);
    }
    [IronSource loadConsentViewWithType:consentViewType];
    return result(nil);
}

/**
 * Shows the consent view with the specified type.
 *
 * @param args   The arguments containing the consent view type.
 * @param result The result to be returned after showing the consent view.
 */
- (void)showConsentViewWithType:(nullable id) args result:(nonnull FlutterResult)result {
    if(!args){
        return result([FlutterError errorWithCode:@"ERROR" message:@"arguments are missing" details:nil]);
    }
    NSString *consentViewType = [args valueForKey:@"consentViewType"];
    if(consentViewType == nil || [[NSNull null] isEqual:consentViewType]){
        return result([FlutterError errorWithCode:@"ERROR" message:@"consentViewType is missing" details:nil]);
    }
    [IronSource showConsentViewWithViewController:[self getRootViewController] andType:consentViewType];
    return result(nil);
}

#pragma mark - Utils ===============================================================================

- (UIViewController *)getRootViewController {
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

#pragma mark - Helper Functions ===============================================================================

- (void)invokeChannelMethodWithName:(NSString *) methodName args:(id _Nullable) args {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.channel invokeMethod:methodName arguments:args result:^(id _Nullable result){
            if([result isKindOfClass:[FlutterError class]]){
                FlutterError *error = result;
                NSLog(@"Critical Error: invokeMethod %@ failed with FlutterError errorCode: %@, message: %@, details: %@", methodName, [error code], [error message], [error details]);
            } else if([result isKindOfClass:[FlutterMethodNotImplemented class]]){
                NSLog(@"Critical Error: invokeMethod %@ failed with FlutterMethodNotImplemented", methodName);
                [result raise]; // force shut down
            }
        }];
    });
}

- (NSMutableDictionary *)getDictWithIronSourceError:(NSError *)error{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if(error != nil){
        dict[@"errorCode"] = [NSNumber numberWithInteger: error.code];
    }
    if(error != nil && error.userInfo != nil){
        dict[@"message"] = error.userInfo[NSLocalizedDescriptionKey];
    }
    return dict;
}

@end
