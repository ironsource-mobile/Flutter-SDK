#import "LevelPlayMediationPlugin.h"
#import <IronSource/IronSource.h>
#import "ATTrackingManagerChannel.h"
#import "LevelPlayNativeAdViewFactoryTemplate.h"
#import "LevelPlayNativeAdViewFactory.h"
#import "LevelPlayNativeAdView.h"
#import "LevelPlayBannerAdViewFactory.h"
#import "LevelPlayBannerAdView.h"
#import "LevelPlayUtils.h"
#import "LevelPlayAdObjectManager.h"

@interface LevelPlayMediationPlugin()<LPMImpressionDataDelegate>
@property (nonatomic,strong) FlutterMethodChannel* channel;
@property (nonatomic,strong) NSObject<FlutterPluginRegistrar> *registrar;
@property (nonatomic, strong) NSMutableDictionary<NSString *, LevelPlayNativeAdViewFactory *> *nativeAdViewFactories;
@property (nonatomic, strong) LevelPlayAdObjectManager *levelPlayAdObjectManager;

@end

static LevelPlayMediationPlugin *instance = nil;

@implementation LevelPlayMediationPlugin

- (id)initWithChannel:(FlutterMethodChannel*)channel {
    if (self = [super init]) {
        self.channel = channel;
    }
    return self;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"unity_levelplay_mediation"
                                     binaryMessenger:[registrar messenger]];
    if (!instance) {
        instance = [[LevelPlayMediationPlugin alloc] initWithChannel:channel];
        instance.registrar = registrar;
        instance.nativeAdViewFactories = [NSMutableDictionary dictionary];
    }
    __weak LevelPlayMediationPlugin *weakInstance = instance; // Capture a weak reference to the instance
    [registrar addMethodCallDelegate:instance channel:channel];
        
    // ATT Brigde
    [ATTrackingManagerChannel registerWithMessenger:[registrar messenger]];

    // Banner ad view registry
    LevelPlayBannerAdViewFactory *bannerAdViewFactory = [[LevelPlayBannerAdViewFactory alloc] initWithMessenger:[instance.registrar messenger]];
    [instance.registrar registerViewFactory: bannerAdViewFactory withId: @"LevelPlayBannerAdView"];

    // Native ad view registry
    LevelPlayNativeAdViewFactoryTemplate *nativeAdViewFactory = [[LevelPlayNativeAdViewFactoryTemplate alloc] initWithMessenger:[instance.registrar messenger]];
    [instance.nativeAdViewFactories setValue:nativeAdViewFactory forKey:@"LevelPlayNativeAdView"];
    [instance.registrar registerViewFactory: nativeAdViewFactory withId: @"LevelPlayNativeAdView"];

    // Ad instance manager registry
    instance.levelPlayAdObjectManager = [[LevelPlayAdObjectManager alloc] initWithChannel: channel];
}

/// Clean up
- (void)detachFromEngineForRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar{
    self.channel = nil;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    // Base API
    if([@"validateIntegration" isEqualToString:call.method]) {
        [self validateIntegration:result];
    } else if([@"setDynamicUserId" isEqualToString:call.method]) {
        [self setDynamicUserId:call.arguments result:result];
    } else if([@"setAdaptersDebug" isEqualToString:call.method]) {
        [self setAdaptersDebug:call.arguments result:result];
    } else if([@"setConsent" isEqualToString:call.method]) {
        [self setConsent:call.arguments result:result];
    } else if([@"setSegment" isEqualToString:call.method]) {
        [self setSegment:call.arguments result:result];
    } else if([@"setMetaData" isEqualToString:call.method]) {
        [self setMetaData:call.arguments result:result];
    } else if ([@"launchTestSuite" isEqualToString:call.method]) {
        [self launchTestSuite:result];
    } else if ([@"addImpressionDataListener" isEqualToString:call.method]) {
        [self addImpressionDataListener:call.arguments result:result];
    } else if([@"setPluginData" isEqualToString:call.method]) {
        [self setPluginData:call.arguments result:result];
    // LevelPlay Init API
    } else if ([@"init" isEqualToString:call.method]) {
        [self init:call.arguments result:result];
    // LevelPlay Interstitial Ad API
    } else if ([@"createInterstitialAd" isEqualToString:call.method]) {
        [self createInterstitialAd: call.arguments result:result];
    } else if ([@"loadInterstitialAd" isEqualToString:call.method]) {
        [self loadInterstitialAd: call.arguments result:result];
    } else if ([@"showInterstitialAd" isEqualToString:call.method]) {
        [self showInterstitialAd: call.arguments result:result];
    } else if ([@"isInterstitialAdReady" isEqualToString:call.method]) {
        [self isInterstitialAdReady:call.arguments result: result];
    } else if([@"isInterstitialAdPlacementCapped" isEqualToString:call.method]) {
        [self isInterstitialAdPlacementCapped:call.arguments result:result];
    } else if ([@"disposeAd" isEqualToString:call.method]) {
        [self disposeAd: call.arguments result: result];
    } else if ([@"disposeAllAds" isEqualToString:call.method]) {
        [self disposeAllAd: result];
    // LPMAdSize API
    } else if([@"createAdaptiveAdSize" isEqualToString:call.method]) {
        [self createAdaptiveAdSize:call.arguments result:result];
    // LevelPlay Rewarded Ad API
    } else if ([@"createRewardedAd" isEqualToString:call.method]) {
        [self createRewardedAd: call.arguments result:result];
    } else if ([@"loadRewardedAd" isEqualToString:call.method]) {
        [self loadRewardedAd: call.arguments result:result];
    } else if ([@"showRewardedAd" isEqualToString:call.method]) {
        [self showRewardedAd: call.arguments result:result];
    } else if ([@"isRewardedAdReady" isEqualToString:call.method]) {
        [self isRewardedAdReady:call.arguments result: result];
    } else if([@"isRewardedAdPlacementCapped" isEqualToString:call.method]) {
        [self isRewardedAdPlacementCapped:call.arguments result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

#pragma mark - Base API ===================================================================

/**
 * Validates the integration of the SDK.
 *
 * @param result The result to be returned after validating the integration.
 */
- (void)validateIntegration:(nonnull FlutterResult)result {
    [LevelPlay validateIntegration];
    result(nil);
}

/**
 * Sets the dynamic user ID for LevelPlay.
 *
 * @param args   The arguments containing the dynamic user ID.
 * @param result The result to be returned after processing.
 */
- (void)setDynamicUserId:(nullable id) args result:(nonnull FlutterResult)result {
    NSString *userId = [args valueForKey:@"userId"];
    [LevelPlay setDynamicUserId:userId];
    result(nil);
}

/**
 * Enables or disables debug mode for adapters.
 *
 * @param args   The arguments containing the debug mode information.
 * @param result The result to be returned after processing.
 */
- (void)setAdaptersDebug:(nullable id) args result:(nonnull FlutterResult)result {
    NSNumber *isEnabledNum = [args valueForKey:@"isEnabled"];
    BOOL isEnabled = [isEnabledNum boolValue];
    [LevelPlay setAdaptersDebug:isEnabled];
    result(nil);
}

/**
 * Sets the consent status for LevelPlay.
 *
 * @param args   The arguments containing the consent status.
 * @param result The result to be returned after processing.
 */
- (void)setConsent:(nullable id) args result:(nonnull FlutterResult)result {
    NSNumber *isConsentNum = [args valueForKey:@"isConsent"];
    BOOL isConsent = [isConsentNum boolValue];
    [LevelPlay setConsent:isConsent];
    result(nil);
}

/**
 * Sets the segment data for LevelPlay.
 *
 * @param args   The arguments containing the segment data.
 * @param result The result to be returned after processing.
 */
- (void)setSegment:(nullable id) args result:(nonnull FlutterResult)result  {
    NSDictionary *segmentDict = [args valueForKey:@"segment"];
    LPMSegment *segment = [[LPMSegment alloc] init];
    NSMutableArray<NSString*> *allKeys = [[segmentDict allKeys] mutableCopy];
    for (NSString *key in allKeys) {
        if ([key isEqualToString:@"level"]){
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
        } else if ([key isEqualToString:@"customParameters"]){
            NSDictionary *customParams = [segmentDict objectForKey:key];
            if(customParams != nil && ![[NSNull null] isEqual:customParams]){
                // set custom values
                NSMutableArray<NSString*> *customKeys = [[customParams allKeys] mutableCopy];
                for (NSString *customKey in customKeys) {
                    NSString *customValue = [customParams objectForKey:customKey];
                    if(customValue != nil && ![[NSNull null] isEqual:customValue]){
                        [segment setCustomValue:customValue forKey:customKey];
                    }
                }
            }
        }
    }
    [LevelPlay setSegment:segment];
    result(nil);
}

/**
 * Sets metadata for LevelPlay.
 *
 * @param args   The arguments containing the metadata.
 * @param result The result to be returned after processing.
 */
- (void)setMetaData:(nullable id) args result:(nonnull FlutterResult)result  {
    NSDictionary<NSString*, NSArray<NSString*>*> *metaDataDict = [args valueForKey:@"metaData"];
    NSMutableArray<NSString*> *allKeys = [[metaDataDict allKeys] mutableCopy];
    for (NSString* key in allKeys) {
        NSArray<NSString*> *valArr = [metaDataDict objectForKey:key];
        if(valArr != nil && ![[NSNull null] isEqual:valArr]) {
            [LevelPlay setMetaDataWithKey:key values:[valArr mutableCopy]];
        }
    }
    result(nil);
}

/**
 * Launches the LevelPlay test suite for integration validation.
 *
 * @param result The result to be returned after processing.
 */
- (void)launchTestSuite:(nonnull FlutterResult)result{
    [LevelPlay launchTestSuite:[self getRootViewController]];
    result(nil);
}

/**
 * Adds a listener for receiving impression data events from LevelPlay.
 *
 * @param args   The arguments (unused for this method).
 * @param result The result to be returned after processing.
 */
- (void)addImpressionDataListener:(nullable id) args result:(nonnull FlutterResult)result {
    [LevelPlay addImpressionDataDelegate:self];
    result(nil);
}

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

#pragma mark - LevelPlay Init ===============================================================================
/**
 * Initializes LevelPlay with the provided app key and ad units.
 *
 * @param args   The arguments containing the app key and ad units.
 * @param result The result to be returned after processing.
 */
- (void)init:(nullable id)args result:(nonnull FlutterResult)result {
    if(!args){
        result([FlutterError errorWithCode:@"ERROR" message:@"arguments are missing" details:nil]);
        return;
    }

    NSString *appKey = [args valueForKey:@"appKey"];
    NSString *userId = [args valueForKey:@"userId"];
    if(appKey == nil || [[NSNull null] isEqual:appKey]){
        result([FlutterError errorWithCode:@"ERROR" message:@"appKey is missing" details:nil]);
        return;
    }
    LPMInitRequestBuilder *requestBuilder = [[LPMInitRequestBuilder alloc] initWithAppKey: appKey];
    if(userId != nil){
        [requestBuilder withUserId: userId];
    }
    LPMInitRequest *initRequest = [requestBuilder build];
    [LevelPlay initWithRequest:initRequest completion:^(LPMConfiguration *_Nullable config, NSError *_Nullable error){
        if(error) {
            // There was an error on initialization. Take necessary actions or retry
            [LevelPlayUtils invokeMethodOnUiThreadWithChannel:self.channel 
                                                   methodName:@"onInitFailed" 
                                                         args:[LevelPlayUtils dictionaryForInitError: error]];
        } else {
            // Initialization was successful. You can now load banner ad or perform other tasks
            [LevelPlayUtils invokeMethodOnUiThreadWithChannel:self.channel 
                                                   methodName:@"onInitSuccess" 
                                                         args:[LevelPlayUtils dictionaryForInitSuccess: config]];
        }
    }];

    result(nil);
}

#pragma mark - LevelPlay Interstitial Ad API ===============================================================================

/**
 * Creates a new LevelPlay interstitial ad instance.
 *
 * @param args   The arguments containing the ad unit ID and optional bid floor.
 * @param result The result to be returned containing the created ad instance ID.
 */
- (void)createInterstitialAd:(nullable id) args result:(nonnull FlutterResult)result{
    NSString *adUnitId = args[@"adUnitId"];
    NSNumber *bidFloor = args[@"bidFloor"];
    NSString *adId = [self.levelPlayAdObjectManager createInterstitialAd:adUnitId bidFloor:bidFloor];
    result(adId);
}

/**
 * Loads a LevelPlay interstitial ad.
 *
 * @param args   The arguments containing the ad instance ID.
 * @param result The result to be returned after processing.
 */
- (void)loadInterstitialAd:(nullable id) args result:(nonnull FlutterResult)result{
    NSString *adId = args[@"adId"];
    [self.levelPlayAdObjectManager loadInterstitialAd:adId];
    result(nil);
}

/**
 * Shows a LevelPlay interstitial ad.
 *
 * @param args   The arguments containing the ad instance ID and optional placement name.
 * @param result The result to be returned after processing.
 */
- (void)showInterstitialAd:(nullable id) args result:(nonnull FlutterResult)result{
    NSString *adId = args[@"adId"];
    NSString *placementName = args[@"placementName"];
    [self.levelPlayAdObjectManager showInterstitialAd:adId placementName:placementName rootViewController:[LevelPlayUtils getRootViewController]];
    result(nil);
}

/**
 * Checks if a LevelPlay interstitial ad is ready to be shown.
 *
 * @param args   The arguments containing the ad instance ID.
 * @param result The result to be returned containing the ready status as a boolean.
 */
- (void)isInterstitialAdReady:(nullable id) args result:(nonnull FlutterResult)result{
    NSString *adId = args[@"adId"];
    BOOL isReady = [self.levelPlayAdObjectManager isInterstitialAdReady:adId];
    result(@(isReady));
}

/**
 * Checks whether the specified placement for interstitial ads is capped.
 *
 * @param args   The arguments containing the placement name.
 * @param result The result to be returned after processing.
 */
- (void)isInterstitialAdPlacementCapped:(nullable id) args result:(nonnull FlutterResult)result{
    if(!args){
        result([FlutterError errorWithCode:@"ERROR" message:@"arguments are missing" details:nil]);
        return;
    }
    NSString *placementName = [args valueForKey:@"placementName"];
    if(placementName == nil || [[NSNull null] isEqual:placementName]){
        result([FlutterError errorWithCode:@"ERROR" message:@"placementName is missing" details:nil]);
        return;
    }
    BOOL isCapped = [LPMInterstitialAd isPlacementCapped:placementName];
    result([NSNumber numberWithBool:isCapped]);
}

/**
 * Disposes of a LevelPlay ad instance and releases its resources.
 *
 * @param args   The arguments containing the ad instance ID.
 * @param result The result to be returned after processing.
 */
- (void)disposeAd:(nullable id) args result:(nonnull FlutterResult)result{
    NSString *adId = args[@"adId"];
    [self.levelPlayAdObjectManager disposeAd:adId];
    result(nil);
}

/**
 * Disposes of all LevelPlay ad instances and releases their resources.
 *
 * @param result The result to be returned after processing.
 */
- (void)disposeAllAd:(nullable FlutterResult) result {
    [self.levelPlayAdObjectManager disposeAllAds];
    result(nil);
}

#pragma mark - LPMAdSize API ===============================================================================

/**
 * Creates an adaptive ad size for LevelPlay banner ads.
 *
 * @param args   The arguments containing the optional width parameter.
 * @param result The result to be returned containing the adaptive ad size data.
 */
- (void)createAdaptiveAdSize:(nullable id) args result:(nonnull FlutterResult)result{
    if(!args){
        result([FlutterError errorWithCode:@"ERROR" message:@"arguments are missing" details:nil]);
        return;
    }
    NSNumber *widthNumber = [args[@"width"] isKindOfClass:[NSNumber class]] ? args[@"width"] : nil;
    if (widthNumber == nil) {
        LPMAdSize *adSize = [LPMAdSize createAdaptiveAdSize];
        result([LevelPlayUtils dictionaryForAdSize: adSize]);
        return;
    }
    CGFloat width = [widthNumber floatValue];
    LPMAdSize *adSize = [LPMAdSize createAdaptiveAdSizeWithWidth: width];
    result([LevelPlayUtils dictionaryForAdSize: adSize]);
}

#pragma mark - LevelPlay Rewarded Ad API ===============================================================================

/**
 * Creates a new LevelPlay rewarded ad instance.
 *
 * @param args   The arguments containing the ad unit ID and optional bid floor.
 * @param result The result to be returned containing the created ad instance ID.
 */
- (void)createRewardedAd:(nullable id) args result:(nonnull FlutterResult)result{
    NSString *adUnitId = args[@"adUnitId"];
    NSNumber *bidFloor = args[@"bidFloor"];
    NSString *adId = [self.levelPlayAdObjectManager createRewardedAd:adUnitId bidFloor:bidFloor];
    result(adId);
}

/**
 * Loads a LevelPlay rewarded ad.
 *
 * @param args   The arguments containing the ad instance ID.
 * @param result The result to be returned after processing.
 */
- (void)loadRewardedAd:(nullable id) args result:(nonnull FlutterResult)result{
    NSString *adId = args[@"adId"];
    [self.levelPlayAdObjectManager loadRewardedAd:adId];
    result(nil);
}

/**
 * Shows a LevelPlay rewarded ad.
 *
 * @param args   The arguments containing the ad instance ID and optional placement name.
 * @param result The result to be returned after processing.
 */
- (void)showRewardedAd:(nullable id) args result:(nonnull FlutterResult)result{
    NSString *adId = args[@"adId"];
    NSString *placementName = args[@"placementName"];
    [self.levelPlayAdObjectManager showRewardedAd:adId placementName:placementName rootViewController:[LevelPlayUtils getRootViewController]];
    result(nil);
}

/**
 * Checks if a LevelPlay rewarded ad is ready to be shown.
 *
 * @param args   The arguments containing the ad instance ID.
 * @param result The result to be returned containing the ready status as a boolean.
 */
- (void)isRewardedAdReady:(nullable id) args result:(nonnull FlutterResult)result{
    NSString *adId = args[@"adId"];
    BOOL isReady = [self.levelPlayAdObjectManager isRewardedAdReady:adId];
    result(@(isReady));
}

/**
 * Checks whether the specified placement for rewarded ads is capped.
 *
 * @param args   The arguments containing the placement name.
 * @param result The result to be returned after processing.
 */
- (void)isRewardedAdPlacementCapped:(nullable id) args result:(nonnull FlutterResult)result{
    if(!args){
        result([FlutterError errorWithCode:@"ERROR" message:@"arguments are missing" details:nil]);
        return;
    }
    NSString *placementName = [args valueForKey:@"placementName"];
    if(placementName == nil || [[NSNull null] isEqual:placementName]){
        result([FlutterError errorWithCode:@"ERROR" message:@"placementName is missing" details:nil]);
        return;
    }
    BOOL isCapped = [LPMRewardedAd isPlacementCapped:placementName];
    result([NSNumber numberWithBool:isCapped]);
}

#pragma mark - LevelPlay Native Ad API ===============================================================================

/**
 * Registers a native ad view factory with the Flutter plugin registry.
 * @param registry The FlutterPluginRegistry instance where the factory will be registered.
 * @param viewTypeId The unique identifier for the native ad view factory.
 * @param nativeAdViewFactory The factory object responsible for creating native ad views.
 */
+ (void)registerNativeAdViewFactory:(id<FlutterPluginRegistry>)registry
                      viewTypeId:(NSString *)viewTypeId
        nativeAdViewFactory:(LevelPlayNativeAdViewFactory *)nativeAdViewFactory {
    LevelPlayMediationPlugin *flutterPlugin = instance;
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
    LevelPlayMediationPlugin *flutterPlugin = instance;

    id<FlutterPluginRegistry> factory = flutterPlugin.nativeAdViewFactories[viewTypeId];
    if (factory)
        [flutterPlugin.nativeAdViewFactories removeObjectForKey:viewTypeId];
}

#pragma mark - LPMImpressionDataDelegate ===============================================================================

/**
 * Called when impression data is successfully received from LevelPlay.
 * Implements LPMImpressionDataDelegate protocol.
 *
 * @param impressionData The impression data received from LevelPlay.
 */
- (void)impressionDataDidSucceed:(LPMImpressionData *)impressionData {
    [LevelPlayUtils invokeMethodOnUiThreadWithChannel:self.channel 
                                           methodName:@"onImpressionSuccess"
                                                 args:impressionData != nil ? [LevelPlayUtils dictionaryForLPMImpressionData:impressionData] : [NSNull null]];
}

#pragma mark - Utils ===============================================================================

/**
 * Retrieves the root view controller from the main application window.
 *
 * @return The root view controller of the application.
 */
- (UIViewController *)getRootViewController {
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

@end
