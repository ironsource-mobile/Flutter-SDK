#import "IronSourceMediationPlugin.h"
#import <IronSource/IronSource.h>
#import "ATTrackingManagerChannel.h"

@interface IronSourceMediationPlugin() <
    ISRewardedVideoDelegate,
    ISInterstitialDelegate,
    ISBannerDelegate,
    ISOfferwallDelegate,
    ISImpressionDataDelegate,
    ISConsentViewDelegate,
    ISRewardedVideoManualDelegate,
    ISInitializationDelegate
>
@property (nonatomic,strong) FlutterMethodChannel* channel;
@property (nonatomic,weak) ISBannerView* bannerView;
@property (nonatomic,strong) NSNumber* bannerOffset;
@property (nonatomic) NSInteger bannerPosition;
@property (nonatomic) BOOL shouldHideBanner;
@property (nonatomic,strong) UIViewController* bannerViewController;
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
    // set ironSource Listeners
    [IronSource setRewardedVideoDelegate:instance];
    [IronSource setInterstitialDelegate:instance];
    [IronSource setBannerDelegate:instance];
    [IronSource setOfferwallDelegate:instance];
    [IronSource addImpressionDataDelegate:instance];
    [IronSource setConsentViewWithDelegate:instance];
    
    // ATT Brigde
    [ATTrackingManagerChannel registerWithMessenger:[registrar messenger]];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if([@"validateIntegration" isEqualToString:call.method]) { /* Base API ====================*/
        [self validateIntegrationWithResult:result];
    } else if([@"shouldTrackNetworkState" isEqualToString:call.method]) {
        [self shouldTrackNetworkStateWithArgs:call.arguments result:result];
    } else if([@"setAdaptersDebug" isEqualToString:call.method]) {
        [self setAdaptersDebugWithArgs:call.arguments result:result];
    } else if([@"setDynamicUserId" isEqualToString:call.method]) {
        [self setDynamicUserIdWithArgs:call.arguments result:result];
    } else if([@"getAdvertiserId" isEqualToString:call.method]) {
        [self getAdvertiserIdWithResult:result];
    } else if([@"setConsent" isEqualToString:call.method]) {
        [self setConsentWithArgs:call.arguments result:result];
    } else if([@"setSegment" isEqualToString:call.method]) {
        [self setSegmentWithArgs:call.arguments result:result];
    } else if([@"setMetaData" isEqualToString:call.method]) {
        [self setMetaDataWithArgs:call.arguments result:result];
    } else if([@"setUserId" isEqualToString:call.method]) { /* Init API ========================*/
        [self setUserIdWithArgs:call.arguments result:result];
    } else if ([@"init" isEqualToString:call.method]) {
        [self initWithArgs:call.arguments result:result];
    } else if([@"showRewardedVideo" isEqualToString:call.method]) { /* RV API ==================*/
        [self showRewardedVideoWithArgs:call.arguments result:result];
    } else if([@"getRewardedVideoPlacementInfo" isEqualToString:call.method]) {
        [self getRewardedVideoPlacementInfoWithArgs:call.arguments result:result];
    } else if([@"isRewardedVideoAvailable" isEqualToString:call.method]) {
        [self isRewardedVideoAvailableWithResult:result];
    } else if([@"isRewardedVideoPlacementCapped" isEqualToString:call.method]) {
        [self isRewardedVideoPlacementCappedWithArgs:call.arguments result:result];
    } else if([@"setRewardedVideoServerParams" isEqualToString:call.method]) {
        [self setRewardedVideoServerParamsWithArgs:call.arguments result:result];
    } else if([@"clearRewardedVideoServerParams" isEqualToString:call.method]) {
        [self clearRewardedVideoServerParamsWithResult:result];
    } else if([@"setManualLoadRewardedVideo" isEqualToString:call.method]) {
        [self setManualLoadRewardedVideoWithResult:result];
    } else if([@"loadRewardedVideo" isEqualToString:call.method]) {
        [self loadRewardedVideoWithResult:result];
    } else if([@"loadInterstitial" isEqualToString:call.method]) { /* IS API ===================*/
        [self loadInterstitialWithResult:result];
    } else if([@"showInterstitial" isEqualToString:call.method]) {
        [self showInterstitialWithArgs:call.arguments result:result];
    } else if([@"isInterstitialReady" isEqualToString:call.method]) {
        [self isInterstitialReadyWithResult:result];
    } else if([@"isInterstitialPlacementCapped" isEqualToString:call.method]) {
        [self isInterstitialPlacementCappedWithArgs:call.arguments result:result];
    } else if([@"loadBanner" isEqualToString:call.method]) { /* BN API =========================*/
        [self loadBannerWithArgs:call.arguments result:result];
    } else if([@"destroyBanner" isEqualToString:call.method]) {
        [self destroyBannerWithResult:result];
    } else if([@"displayBanner" isEqualToString:call.method]) {
        [self displayBannerWithResult:result];
    } else if([@"hideBanner" isEqualToString:call.method]) {
        [self hideBannerWithResult:result];
    } else if([@"isBannerPlacementCapped" isEqualToString:call.method]) {
        [self isBannerPlacementCappedWithArgs:call.arguments result:result];
    } else if([@"isOfferwallAvailable" isEqualToString:call.method]) { /* OW API ===============*/
        [self isOfferwallAvailableWithResult:result];
    } else if([@"showOfferwall" isEqualToString:call.method]) {
        [self showOfferwallWithArgs:call.arguments result:result];
    } else if([@"getOfferwallCredits" isEqualToString:call.method]) {
        [self getOfferwallCreditsWithResult:result];
    } else if([@"setClientSideCallbacks" isEqualToString:call.method]) { /* Config API =========*/
        [self setClientSideCallbacksWithArgs:call.arguments result:result];
    } else if([@"setOfferwallCustomParams" isEqualToString:call.method]) {
        [self setOfferwallCustomParamsWithArgs:call.arguments result:result];
    } else if([@"getConversionValue" isEqualToString:call.method]) { /* ConversionValue API ====*/
        [self getConversionValueWithResult:result];
    } else if([@"loadConsentViewWithType" isEqualToString:call.method]) { /* ConsentView API ===*/
        [self loadConsentViewWithTypeWithArgs:call.arguments result:result];
    } else if([@"showConsentViewWithType" isEqualToString:call.method]) {
        [self showConsentViewWithTypeWithArgs:call.arguments result:result];
    } else if([@"setPluginData" isEqualToString:call.method]) { /* Internal Config API =*/
        [self setPluginDataWithArgs:call.arguments result:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

# pragma mark - Base API =========================================================================

- (void)validateIntegrationWithResult:(nonnull FlutterResult)result {
    [ISIntegrationHelper validateIntegration];
    return result(nil);
}

- (void)shouldTrackNetworkStateWithArgs:(nullable id) args result:(nonnull FlutterResult)result {
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

- (void)setAdaptersDebugWithArgs:(nullable id) args result:(nonnull FlutterResult)result {
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

- (void)setDynamicUserIdWithArgs:(nullable id) args
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

- (void)getAdvertiserIdWithResult:(nonnull FlutterResult)result {
    NSString *advertiserId = [IronSource advertiserId];
    return result(advertiserId);
}

- (void)setConsentWithArgs:(nullable id) args result:(nonnull FlutterResult)result {
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

- (void)setSegmentWithArgs:(nullable id) args result:(nonnull FlutterResult)result  {
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

- (void)setMetaDataWithArgs:(nullable id) args
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

# pragma mark - Init API =========================================================================

- (void)setUserIdWithArgs:(nullable id) args result:(nonnull FlutterResult)result {
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
- (void)initWithArgs:(nullable id)args result:(nonnull FlutterResult)result {
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
        [IronSource initWithAppKey:appKey adUnits:parsedAdUnits delegate:self];
    } else {
        [IronSource initWithAppKey:appKey delegate:self];
    }
    return result(nil);
}

# pragma mark - RV API ===========================================================================

- (void)showRewardedVideoWithArgs:(nullable id) args result:(nonnull FlutterResult)result{
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

- (void)getRewardedVideoPlacementInfoWithArgs:(nullable id) args result:(nonnull FlutterResult)result{
    if(!args){
        return result([FlutterError errorWithCode:@"ERROR" message:@"arguments are missing" details:nil]);
    }
    NSString *placementName = [args valueForKey:@"placementName"];
    if(placementName == nil || [[NSNull null] isEqual:placementName]){
        return result([FlutterError errorWithCode:@"ERROR" message:@"placementName is missing" details:nil]);
    }
    ISPlacementInfo *placementInfo = [IronSource rewardedVideoPlacementInfo:placementName];
    return result(placementInfo != nil ? [self getDictWithPlacementInfo:placementInfo] : nil);
}

- (void)isRewardedVideoAvailableWithResult:(nonnull FlutterResult)result {
    BOOL isRVAvailable = [IronSource hasRewardedVideo];
    return result([NSNumber numberWithBool:isRVAvailable]);
}

- (void)isRewardedVideoPlacementCappedWithArgs:(nullable id) args result:(nonnull FlutterResult)result{
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

- (void)setRewardedVideoServerParamsWithArgs:(nullable id) args result:(nonnull FlutterResult)result{
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

- (void)clearRewardedVideoServerParamsWithResult:(nonnull FlutterResult)result {
    [IronSource clearRewardedVideoServerParameters];
    return result(nil);
}

# pragma mark - Manual Load RV API ==============================================================

- (void)setManualLoadRewardedVideoWithResult:(nonnull FlutterResult)result {
    [IronSource setRewardedVideoManualDelegate:self];
    return result(nil);
}

- (void)loadRewardedVideoWithResult:(nonnull FlutterResult)result {
    [IronSource loadRewardedVideo];
    return result(nil);
}

# pragma mark - IS API ===========================================================================

- (void)loadInterstitialWithResult:(nonnull FlutterResult)result {
    [IronSource loadInterstitial];
    return result(nil);
}

- (void)showInterstitialWithArgs:(nullable id) args result:(nonnull FlutterResult)result{
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

- (void)isInterstitialReadyWithResult:(nonnull FlutterResult)result {
    BOOL isISReady = [IronSource hasInterstitial];
    return result([NSNumber numberWithBool:isISReady]);
}

- (void)isInterstitialPlacementCappedWithArgs:(nullable id) args result:(nonnull FlutterResult)result{
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

# pragma mark - BN API ===========================================================================

- (void)loadBannerWithArgs:(nullable id) args result:(nonnull FlutterResult)result{
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
                            bannerView:(ISBannerView*) bnView
                          bannerOffset:(NSNumber*) offset {
    // Positions
    const NSInteger BANNER_POSITION_TOP = 0;
    const NSInteger BANNER_POSITION_CENTER = 1;
    // const NSInteger BANNER_POSITION_BOTTOM = 2;
    
    CGFloat y;
    if (position == BANNER_POSITION_TOP) {
        y = (bnView.frame.size.height / 2);
        // safe area
        if (@available(ios 11.0, *)) {
            y += rootView.safeAreaInsets.top;
        }
        // vertical offset
        if(offset.intValue > 0){
            y += offset.floatValue;
        }
    } else if (position == BANNER_POSITION_CENTER) {
        y = (rootView.frame.size.height / 2) - (bnView.frame.size.height / 2);
        // vertical offset
        y += offset.floatValue;
    } else { // BANNER_POSITION_BOTTOM
        y = rootView.frame.size.height - (bnView.frame.size.height / 2);
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

- (void)destroyBannerWithResult:(nonnull FlutterResult)result {
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

- (void)displayBannerWithResult:(nonnull FlutterResult)result {
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

- (void)hideBannerWithResult:(nonnull FlutterResult)result {
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

- (void)isBannerPlacementCappedWithArgs:(nullable id) args result:(nonnull FlutterResult)result{
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

# pragma mark - OW API ===========================================================================

- (void)getOfferwallCreditsWithResult:(nonnull FlutterResult)result {
    [IronSource offerwallCredits];
    return result(nil);
}

- (void)showOfferwallWithArgs:(nullable id) args result:(nonnull FlutterResult)result{
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

- (void)isOfferwallAvailableWithResult:(nonnull FlutterResult)result {
    BOOL isAvailable = [IronSource hasOfferwall];
    return result([NSNumber numberWithBool:isAvailable]);
}

# pragma mark - Config API ===========================================================================

- (void)setClientSideCallbacksWithArgs:(nullable id) args result:(nonnull FlutterResult)result {
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

- (void)setOfferwallCustomParamsWithArgs:(nullable id) args result:(nonnull FlutterResult)result{
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
- (void)setPluginDataWithArgs:(nullable id) args result:(nonnull FlutterResult)result {
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

- (void)getConversionValueWithResult:(nonnull FlutterResult)result {
    NSNumber *conversionValue = [IronSource getConversionValue];
    return result(conversionValue);
}

# pragma mark - ConsentView API ======================================================================

- (void)loadConsentViewWithTypeWithArgs:(nullable id) args result:(nonnull FlutterResult)result {
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

- (void)showConsentViewWithTypeWithArgs:(nullable id) args result:(nonnull FlutterResult)result {
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

# pragma mark - Rewarded Video Delegate Functions =================================================

- (void)rewardedVideoHasChangedAvailability:(BOOL)isAvailable {
    NSDictionary *args = @{ @"isAvailable": [NSNumber numberWithBool:isAvailable] };
    [self invokeChannelMethodWithName:@"onRewardedVideoAvailabilityChanged" args:args];
}

- (void)didReceiveRewardForPlacement:(ISPlacementInfo *)placementInfo {
    NSDictionary *args = [self getDictWithPlacementInfo:placementInfo];
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
    NSDictionary *args = [self getDictWithPlacementInfo:placementInfo];
    [self invokeChannelMethodWithName:@"onRewardedVideoAdClicked" args:args];
}

# pragma mark - Rewarded Video Manual Load Delegate Functions ======================================

- (void)rewardedVideoDidFailToLoadWithError:(NSError *)error {
    NSDictionary *args = [self getDictWithIronSourceError:error];
    [self invokeChannelMethodWithName:@"onRewardedVideoAdLoadFailed" args:args];
}

- (void)rewardedVideoDidLoad {
    [self invokeChannelMethodWithName:@"onRewardedVideoAdReady" args:nil];
}


# pragma mark - Interstitial Delegate Functions ====================================================

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

# pragma mark - Banner Delegate Functions ===========================================================

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
    [self invokeChannelMethodWithName:@"onBannerAdLoaded" args:nil];
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

# pragma mark - Offerwall Delegate Functions ========================================================

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

# pragma mark - Initialization Delegate Functions ===================================================

- (void)initializationDidComplete {
    [self invokeChannelMethodWithName:@"onInitializationComplete" args:nil];
}

# pragma mark - ImpressionData Delegate Functions ===================================================

- (void)impressionDataDidSucceed:(ISImpressionData *)impressionData {
    if(impressionData == nil){
        [self invokeChannelMethodWithName:@"onImpressionSuccess" args:nil];
    } else {
        NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
        if(impressionData.auction_id != nil){
            args[@"auctionId"] = impressionData.auction_id;
        }
        if(impressionData.ad_unit != nil){
            args[@"adUnit"] = impressionData.ad_unit;
        }
        if(impressionData.country != nil){
            args[@"country"] = impressionData.country;
        }
        if(impressionData.ab != nil){
            args[@"ab"] = impressionData.ab;
        }
        if(impressionData.segment_name != nil){
            args[@"segmentName"] = impressionData.segment_name;
        }
        if(impressionData.placement != nil){
            args[@"placement"] = impressionData.placement;
        }
        if(impressionData.ad_network != nil){
            args[@"adNetwork"] = impressionData.ad_network;
        }
        if(impressionData.instance_name != nil){
            args[@"instanceName"] = impressionData.instance_name;
        }
        if(impressionData.ad_unit != nil){
            args[@"instanceId"] = impressionData.instance_id;
        }
        if(impressionData.revenue != nil){
            args[@"revenue"] = impressionData.revenue;
        }
        if(impressionData.precision != nil){
            args[@"precision"] = impressionData.precision;
        }
        if(impressionData.lifetime_revenue != nil){
            args[@"lifetimeRevenue"] = impressionData.lifetime_revenue;
        }
        if(impressionData.encrypted_cpm != nil){
            args[@"encryptedCPM"] = impressionData.encrypted_cpm;
        }
        [self invokeChannelMethodWithName:@"onImpressionSuccess" args:args];
    }
}

# pragma mark - ConsentView Delegate Functions =======================================================

- (void)consentViewDidLoadSuccess:(NSString *)consentViewType {
    NSDictionary *args = [self getDictWithConsentViewType:consentViewType andError:nil];
    [self invokeChannelMethodWithName:@"consentViewDidLoadSuccess" args:args];
}

- (void)consentViewDidFailToLoadWithError:(NSError *)error consentViewType:(NSString *)consentViewType {
    NSDictionary *args = [self getDictWithConsentViewType:consentViewType andError:error];
    [self invokeChannelMethodWithName:@"consentViewDidFailToLoad" args:args];
}

- (void)consentViewDidShowSuccess:(NSString *)consentViewType {
    NSDictionary *args = [self getDictWithConsentViewType:consentViewType andError:nil];
    [self invokeChannelMethodWithName:@"consentViewDidShowSuccess" args:args];
}

- (void)consentViewDidFailToShowWithError:(NSError *)error consentViewType:(NSString *)consentViewType {
    NSDictionary *args = [self getDictWithConsentViewType:consentViewType andError:error];
    [self invokeChannelMethodWithName:@"consentViewDidFailToShow" args:args];
}

- (void)consentViewDidAccept:(NSString *)consentViewType {
    NSDictionary *args = [self getDictWithConsentViewType:consentViewType andError:nil];
    [self invokeChannelMethodWithName:@"consentViewDidAccept" args:args];
}

- (void)consentViewDidDismiss:(NSString *)consentViewType {
    // Deprecated: Never will be called by the SDK.
}

# pragma mark - Utils ===============================================================================

- (UIViewController *)getRootViewController {
    return [UIApplication sharedApplication].keyWindow.rootViewController;
}

- (NSDictionary *)getDictWithPlacementInfo:(ISPlacementInfo *)placementInfo {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if(placementInfo.placementName != nil){
        dict[@"placementName"] = placementInfo.placementName;
    }
    if(placementInfo.rewardName != nil){
        dict[@"rewardName"] = placementInfo.rewardName;
    }
    if(placementInfo.rewardAmount != nil){
        dict[@"rewardAmount"] = placementInfo.rewardAmount;
    }
    return dict;
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

// thin wrapper for UI thread execution of invokeMethod
// No success result handling expected for now.
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

- (NSMutableDictionary *)getDictWithConsentViewType:(NSString *)consentViewType
                                           andError:(nullable NSError *)error {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if(consentViewType != nil){
        dict[@"consentViewType"] = consentViewType;
    }
    if(error != nil){
        dict[@"errorCode"] = [NSNumber numberWithInteger: error.code];
    }
    if(error != nil && error.userInfo != nil){
        dict[@"message"] = error.userInfo[NSLocalizedDescriptionKey];
    }
    return dict;
}

@end
