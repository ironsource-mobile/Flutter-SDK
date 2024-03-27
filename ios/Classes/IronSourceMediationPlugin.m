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

@interface IronSourceMediationPlugin()<
ISRewardedVideoDelegate,
ISInterstitialDelegate,
ISBannerDelegate,
ISRewardedVideoManualDelegate,
ISOfferwallDelegate>
@property (nonatomic,strong) FlutterMethodChannel* channel;
@property (nonatomic,weak) ISBannerView* bannerView;
@property (nonatomic,strong) NSNumber* bannerOffset;
@property (nonatomic) NSInteger bannerPosition;
@property (nonatomic) BOOL shouldHideBanner;
@property (nonatomic,strong) UIViewController* bannerViewController;
@property (nonatomic,strong) InitDelegateMethodHandler* initializationDelegate;
@property (nonatomic,strong) UIViewController* CurrentViewController;
@end

@implementation IronSourceMediationPlugin

- (id)initWithChannel:(FlutterMethodChannel*)channel {
    if (self = [super init]) {
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
    IronSourceMediationPlugin* instance = [[IronSourceMediationPlugin alloc] initWithChannel:channel];
    [registrar addMethodCallDelegate:instance channel:channel];

    // Set ironSource delegates
    // Init
    instance.initializationDelegate = [[InitDelegateMethodHandler alloc] initWithChannel:channel];
    // ConsentView
    [IronSource setConsentViewWithDelegate: [[ConsentViewDelegateMethodHandler alloc] initWithChannel:channel]];
    // RewardedVideo
    [IronSource setRewardedVideoDelegate:instance];
    // Interstitial
    [IronSource setInterstitialDelegate:instance];
    // Banner
    [IronSource setBannerDelegate:instance];
    // OfferWall
    [IronSource setOfferwallDelegate:instance];
    // Imp Data
    [IronSource addImpressionDataDelegate:[[ImpressionDataDelegateMethodHandler alloc] initWithChannel:channel]];

# pragma mark - LevelPlay Delegates=========================================================================
    // LevelPlay RewardedVideo
     [IronSource setLevelPlayRewardedVideoDelegate:[[LevelPlayRewardedVideoDelegateMethodHandler alloc] initWithChannel:channel]];
    // LevelPlay Interstitial
    [IronSource setLevelPlayInterstitialDelegate:[[LevelPlayInterstitialDelegateMethodHandler alloc] initWithChannel:channel]];
    // LevelPlay Banner
    [IronSource setLevelPlayBannerDelegate:[[LevelPlayBannerDelegateMethodHandler alloc] initWithChannel:channel]];

    // ATT Brigde
    [ATTrackingManagerChannel registerWithMessenger:[registrar messenger]];
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
    } else if([@"setManualLoadRewardedVideo" isEqualToString:call.method]) {
        [self setManualLoadRewardedVideo:result];
    } else if([@"loadRewardedVideo" isEqualToString:call.method]) {
        [self loadRewardedVideo:result];
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
    } else if([@"isOfferwallAvailable" isEqualToString:call.method]) { /* OfferWall API ===============*/
        [self isOfferwallAvailable:result];
    } else if([@"showOfferwall" isEqualToString:call.method]) {
        [self showOfferwall:call.arguments result:result];
    } else if([@"getOfferwallCredits" isEqualToString:call.method]) {
        [self getOfferwallCredits:result];
    } else if([@"setClientSideCallbacks" isEqualToString:call.method]) { /* Config API =========*/
        [self setClientSideCallbacks:call.arguments result:result];
    } else if([@"setOfferwallCustomParams" isEqualToString:call.method]) {
        [self setOfferwallCustomParams:call.arguments result:result];
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

-(void)launchTestSuite:(nonnull FlutterResult)result{
    [IronSource launchTestSuite:[self getRootViewController]];
    return result(nil);
}

- (void)validateIntegration:(nonnull FlutterResult)result {
    [ISIntegrationHelper validateIntegration];
    return result(nil);
}

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

- (void)getAdvertiserId:(nonnull FlutterResult)result {
    NSString *advertiserId = [IronSource advertiserId];
    return result(advertiserId);
}

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

- (void)setWaterfallConfiguration:(nullable id) args
                           result:(FlutterResult)result {
    if (!args){
        return result([FlutterError errorWithCode:@"ERROR" message:@"arguments are missing" details:nil]);
    }
    NSDictionary *waterfallConfigurationDataMap = [args objectForKey:@"waterfallConfiguration"];
    if (waterfallConfigurationDataMap == nil || [[NSNull null] isEqual:waterfallConfigurationDataMap]){
        return result([FlutterError errorWithCode:@"ERROR" message:@"waterfallConfiguration is missing" details:nil]);
    }

    NSNumber *ceiling = waterfallConfigurationDataMap[@"ceiling"] ?: [NSNull null];
    NSNumber *floor = waterfallConfigurationDataMap[@"floor"] ?: [NSNull null];
    NSString *adUnitString = waterfallConfigurationDataMap[@"adUnit"] ?: [NSNull null];

    ISAdUnit *adUnit = [self getAdUnit:adUnitString];

    if (adUnit) {
        if (ceiling && floor) {
            ISWaterfallConfigurationBuilder *builder = [ISWaterfallConfiguration builder];
            [builder setCeiling:ceiling];
            [builder setFloor:floor];
            ISWaterfallConfiguration *configuration = [builder build];
            [IronSource setWaterfallConfiguration:configuration forAdUnit:adUnit];
        } else {
            ISWaterfallConfiguration *clearConfiguration = [ISWaterfallConfiguration clear];
            [IronSource setWaterfallConfiguration:clearConfiguration forAdUnit:adUnit];
        }
    }

    return result(nil);
}

-(ISAdUnit *)getAdUnit:(NSString *)adUnitString {
    if ([adUnitString isEqualToString:@"REWARDED_VIDEO"]) {
        return ISAdUnit.IS_AD_UNIT_REWARDED_VIDEO;
    } else if ([adUnitString isEqualToString:@"INTERSTITIAL"]) {
        return ISAdUnit.IS_AD_UNIT_INTERSTITIAL;
    } else if ([adUnitString isEqualToString:@"BANNER"]) {
        return ISAdUnit.IS_AD_UNIT_BANNER;
    } else if ([adUnitString isEqualToString:@"OFFERWALL"]) {
        return ISAdUnit.IS_AD_UNIT_OFFERWALL;
    } else {
        return nil;
    }
}

# pragma mark - Init API =========================================================================

//TODO: implement with real error codes

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
            } else if ([unit isEqualToString:@"OFFERWALL"]){
                [parsedAdUnits addObject:IS_OFFERWALL];
            } else if ([unit isEqualToString:@"BANNER"]){
                [parsedAdUnits addObject:IS_BANNER];
            }
        }
        [IronSource initWithAppKey:appKey adUnits:parsedAdUnits delegate:self.initializationDelegate];
    } else {
        [IronSource initWithAppKey:appKey delegate:self.initializationDelegate];
    }
    return result(nil);
}

# pragma mark - RewardedVideo API ===========================================================================

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

- (void)isRewardedVideoAvailable:(nonnull FlutterResult)result {
    BOOL isRewardedVideoAvailable = [IronSource hasRewardedVideo];
    return result([NSNumber numberWithBool:isRewardedVideoAvailable]);
}

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

- (void)clearRewardedVideoServerParams:(nonnull FlutterResult)result {
    [IronSource clearRewardedVideoServerParameters];
    return result(nil);
}

# pragma mark - Manual Load RewardedVideo API ==============================================================

- (void)setManualLoadRewardedVideo:(nonnull FlutterResult)result {
    [IronSource setRewardedVideoManualDelegate:self];
    [IronSource setLevelPlayRewardedVideoManualDelegate:[[LevelPlayRewardedVideoDelegateMethodHandler alloc] initWithChannel:_channel]];
    return result(nil);
}

- (void)loadRewardedVideo:(nonnull FlutterResult)result {
    [IronSource loadRewardedVideo];
    return result(nil);
}

# pragma mark - Interstitial API ===========================================================================

- (void)loadInterstitial:(nonnull FlutterResult)result {
    [IronSource loadInterstitial];
    return result(nil);
}

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

- (void)isInterstitialReady:(nonnull FlutterResult)result {
    BOOL isInterstitialReady = [IronSource hasInterstitial];
    return result([NSNumber numberWithBool:isInterstitialReady]);
}

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
        ISBannerSize* size = [self getBannerSize:description width:[width integerValue] height:[height integerValue]];
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

// Fallback to BANNER in the case of an illegal description
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

// Fallback to BOTTOM in the case of an illegal position integer
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

    // Wrap the CGFloat value in an NSNumber before returning it
    return result([NSNumber numberWithDouble:adaptiveHeight]);
}

# pragma mark - OfferWall API ===========================================================================

- (void)getOfferwallCredits:(nonnull FlutterResult)result {
    [IronSource offerwallCredits];
    return result(nil);
}

- (void)showOfferwall:(nullable id) args result:(nonnull FlutterResult)result{
    if(!args){
        return result([FlutterError errorWithCode:@"ERROR" message:@"arguments are missing" details:nil]);
    }
    NSString *placementName = [args valueForKey:@"placementName"];
    if(placementName == nil || [[NSNull null] isEqual:placementName]){
        [IronSource showOfferwallWithViewController: [self getRootViewController]];
    } else {
        [IronSource showOfferwallWithViewController: [self getRootViewController] placement:placementName];
    }
    return result(nil);
}

- (void)isOfferwallAvailable:(nonnull FlutterResult)result {
    BOOL isAvailable = [IronSource hasOfferwall];
    return result([NSNumber numberWithBool:isAvailable]);
}

# pragma mark - Config API ===========================================================================

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

- (void)setOfferwallCustomParams:(nullable id) args result:(nonnull FlutterResult)result{
    if(!args){
        return result([FlutterError errorWithCode:@"ERROR" message:@"arguments are missing" details:nil]);
    }
    NSDictionary<NSString*, NSString*> *parameters = [args valueForKey:@"parameters"];
    if(parameters == nil || [[NSNull null] isEqual:parameters]){
        return result([FlutterError errorWithCode:@"ERROR" message:@"paramters is missing" details:nil]);
    }
    [[ISConfigurations getConfigurations] setOfferwallCustomParameters:parameters];
    return result(nil);
}

#pragma mark - Internal Config API ===================================================================

/// Only called internally in the process of init on the Flutter plugin
/// pluginType and pluginVersion are required
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

- (void)getConversionValue:(nonnull FlutterResult)result {
    NSNumber *conversionValue = [IronSource getConversionValue];
    return result(conversionValue);
}

# pragma mark - ConsentView API ======================================================================

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

#pragma mark - BannerLoadSuccessDelegate ===========================================================

- (void)bannerDidLoad:(ISBannerView *)bannerView {
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

- (void)bannerDidFailToLoadWithError:(NSError *)error {
    NSDictionary *args = [self getDictWithIronSourceError:error];
    [self invokeChannelMethodWithName:@"onBannerAdLoadFailed" args:args];
}

- (void)didClickBanner {
    [self invokeChannelMethodWithName:@"onBannerAdClicked" args:nil];
}

- (void)bannerWillPresentScreen {
    // Not called by every network
    [self invokeChannelMethodWithName:@"onBannerAdScreenPresented" args:nil];
}

- (void)bannerDidDismissScreen {
    // Not called by every network
    [self invokeChannelMethodWithName:@"onBannerAdScreenDismissed" args:nil];
}

- (void)bannerWillLeaveApplication {
    [self invokeChannelMethodWithName:@"onBannerAdLeftApplication" args:nil];
}


#pragma mark - Utils ===============================================================================

- (UIViewController *)getRootViewController {
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

#pragma mark - Rewarded VideoDelegate ==============================================================


- (void)rewardedVideoHasChangedAvailability:(BOOL)isAvailable {
    NSDictionary *args = @{ @"isAvailable": [NSNumber numberWithBool:isAvailable] };
    [self invokeChannelMethodWithName:@"onRewardedVideoAvailabilityChanged" args:args];
}

- (void)didReceiveRewardForPlacement:(ISPlacementInfo *)placementInfo {
    NSDictionary *args = [placementInfo toArgDictionary];
    [self invokeChannelMethodWithName:@"onRewardedVideoAdRewarded" args:args];
}

- (void)rewardedVideoDidFailToShowWithError:(NSError *)error {
    NSDictionary *args = [self getDictWithIronSourceError:error];
    [self invokeChannelMethodWithName:@"onRewardedVideoAdShowFailed" args:args];
}

- (void)rewardedVideoDidOpen {
    [self invokeChannelMethodWithName:@"onRewardedVideoAdOpened" args:nil];
}

- (void)rewardedVideoDidClose {
    [self invokeChannelMethodWithName:@"onRewardedVideoAdClosed" args:nil];
}

- (void)rewardedVideoDidStart {
    [self invokeChannelMethodWithName:@"onRewardedVideoAdStarted" args:nil];
}

- (void)rewardedVideoDidEnd {
    [self invokeChannelMethodWithName:@"onRewardedVideoAdEnded" args:nil];
}

- (void)didClickRewardedVideo:(ISPlacementInfo *)placementInfo {
    NSDictionary *args = [placementInfo toArgDictionary];
    [self invokeChannelMethodWithName:@"onRewardedVideoAdClicked" args:args];
}

#pragma mark - ISRewardedVideoManualDelegate

- (void)rewardedVideoDidFailToLoadWithError:(NSError *)error {
    NSDictionary *args = [self getDictWithIronSourceError:error];
    [self invokeChannelMethodWithName:@"onRewardedVideoAdLoadFailed" args:args];
}

- (void)rewardedVideoDidLoad {
    [self invokeChannelMethodWithName:@"onRewardedVideoAdReady" args:nil];
}


#pragma mark - Interstitial Delegate ===============================================================================


- (void)interstitialDidLoad {
    [self invokeChannelMethodWithName:@"onInterstitialAdReady" args:nil];
}

- (void)interstitialDidFailToLoadWithError:(NSError *)error {
    NSDictionary *args = [self getDictWithIronSourceError:error];
    [self invokeChannelMethodWithName:@"onInterstitialAdLoadFailed" args:args];
}

- (void)interstitialDidOpen{
    [self invokeChannelMethodWithName:@"onInterstitialAdOpened" args:nil];
}

- (void)interstitialDidClose{
    [self invokeChannelMethodWithName:@"onInterstitialAdClosed" args:nil];
}

- (void)interstitialDidShow{
    [self invokeChannelMethodWithName:@"onInterstitialAdShowSucceeded" args:nil];
}

- (void)interstitialDidFailToShowWithError:(NSError *)error{
    NSDictionary *args = [self getDictWithIronSourceError:error];
    [self invokeChannelMethodWithName:@"onInterstitialAdShowFailed" args:args];
}

- (void)didClickInterstitial{
    [self invokeChannelMethodWithName:@"onInterstitialAdClicked" args:nil];
}

#pragma mark - Offerwall Delegate ===============================================================================


- (void)offerwallHasChangedAvailability:(BOOL)available {
    NSDictionary *args = @{ @"isAvailable": [NSNumber numberWithBool:available] };
    [self invokeChannelMethodWithName:@"onOfferwallAvailabilityChanged" args:args];
}

- (void)offerwallDidShow {
    [self invokeChannelMethodWithName:@"onOfferwallOpened" args:nil];
}

- (void)offerwallDidFailToShowWithError:(NSError *)error {
    NSDictionary *args = [self getDictWithIronSourceError:error];
    [self invokeChannelMethodWithName:@"onOfferwallShowFailed" args:args];
}

- (BOOL)didReceiveOfferwallCredits:(NSDictionary *)creditInfo {
    // creditInfo should have matching keys: credits, totalCredits, totalCreditsFlag
    NSString *credits = [creditInfo valueForKey:@"credits"]; // implicit cast to NSString
    NSString *totalCredits = [creditInfo valueForKey:@"totalCredits"]; // implicit cast to NSString
    NSString *totalCreditsFlag = [creditInfo valueForKey:@"totalCreditsFlag"]; // implicit cast to NSString
    // creditInfo dictionary values are NSTaggedPointerString,
    //  so they must be cast before being passed to the Flutter side through the channel
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if(credits != nil){
        dict[@"credits"] = [NSNumber numberWithInt:credits.intValue];
    }
    if(totalCredits != nil){
        dict[@"totalCredits"] = [NSNumber numberWithInt: totalCredits.intValue];
    }
    if(totalCreditsFlag != nil){
        dict[@"totalCreditsFlag"] = [NSNumber numberWithBool:totalCreditsFlag.boolValue];
    }
    [self invokeChannelMethodWithName:@"onOfferwallAdCredited" args:dict];
    return YES;
}

- (void)didFailToReceiveOfferwallCreditsWithError:(NSError *)error {
    NSDictionary *args = [self getDictWithIronSourceError:error];
    [self invokeChannelMethodWithName:@"onGetOfferwallCreditsFailed" args:args];
}

- (void)offerwallDidClose {
    [self invokeChannelMethodWithName:@"onOfferwallClosed" args:nil];
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
