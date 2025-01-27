#import "LevelPlayUtils.h"

@implementation LevelPlayUtils

+ (void)invokeMethodOnUiThreadWithChannel:(FlutterMethodChannel *)channel
        methodName:(NSString *)methodName
        args:(NSDictionary *)args{
    // Dispatch the method invocation to the main UI thread
    dispatch_async(dispatch_get_main_queue(), ^{
        // Invoke the method on the Flutter method channel without handling the result
        [channel invokeMethod:methodName arguments:args ? args : nil];
    });
}

/**
 Creates a dictionary containing information about the native ad.

 @param nativeAd The LevelPlayNativeAd object from which to extract information.
 @return A dictionary containing the native ad information.
 */
+ (NSDictionary *)dictionaryForNativeAd:(LevelPlayNativeAd *)nativeAd {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    // Add properties to the dictionary
    [dictionary setObject:(nativeAd.title ?: [NSNull null]) forKey:@"title"];
    [dictionary setObject:(nativeAd.advertiser ?: [NSNull null]) forKey:@"advertiser"];
    [dictionary setObject:(nativeAd.body ?: [NSNull null]) forKey:@"body"];
    [dictionary setObject:(nativeAd.callToAction ?: [NSNull null]) forKey:@"callToAction"];

    // Handle the nested 'icon' structure
    NSMutableDictionary *iconDictionary = [NSMutableDictionary dictionary];
    [iconDictionary setObject:(nativeAd.icon.url.absoluteString ?: [NSNull null]) forKey:@"uri"];

    // Convert UIImage to NSData
    NSData *iconImageData = [self dataFromImage:nativeAd.icon.image];
    [iconDictionary setObject:(iconImageData ?: [NSNull null]) forKey:@"imageData"];

    [dictionary setObject:[iconDictionary copy] forKey:@"icon"];

    return [dictionary copy];
}

/**
 Creates a dictionary containing information about the ad.

 @param adInfo The ISAdInfo object from which to extract information.
 @return A dictionary containing the ad information.
 */
+ (NSDictionary *)dictionaryForAdInfo:(ISAdInfo *)adInfo {
    return @{
            @"auctionId": adInfo.auction_id ?: [NSNull null],
            @"adUnit": adInfo.ad_unit ?: [NSNull null],
            @"adNetwork": adInfo.ad_network ?: [NSNull null],
            @"instanceName": adInfo.instance_name ?: [NSNull null],
            @"instanceId": adInfo.instance_id ?: [NSNull null],
            @"country": adInfo.country ?: [NSNull null],
            @"revenue": adInfo.revenue != nil ? @(adInfo.revenue.doubleValue) : [NSNull null],
            @"precision": adInfo.precision ?: [NSNull null],
            @"ab": adInfo.ab ?: [NSNull null],
            @"segmentName": adInfo.segment_name ?: [NSNull null],
            @"lifetimeRevenue": adInfo.lifetime_revenue != nil ? @(adInfo.lifetime_revenue.doubleValue) : [NSNull null],
            @"encryptedCpm": adInfo.encrypted_cpm ?: [NSNull null],
            @"conversionValue": adInfo.conversion_value != nil ? @(adInfo.conversion_value.doubleValue) : [NSNull null],
    };
}

/**
 Creates a dictionary containing information about the error.

 @param error The NSError object representing the error.
 @return A dictionary containing the error information.
 */
+ (NSDictionary *)dictionaryForError:(NSError *)error {
    return @{
            @"errorCode": [NSNumber numberWithInteger:error.code],
            @"message": error.userInfo[NSLocalizedDescriptionKey] ?: [NSNull null],
    };
}

/**
 Converts a UIImage object to NSData.

 @param image The UIImage object to convert.
 @return The NSData representation of the UIImage.
 */
+ (NSData *)dataFromImage:(UIImage *)image {
    if (image == nil) {
        return nil;
    }

    // Convert UIImage to NSData (PNG representation)
    NSData *imageData = UIImagePNGRepresentation(image);

    return imageData;
}

/**
 * Converts the ad unit string to the corresponding ISAdUnit object.
 *
 * @param adUnitString The string representation of the ad unit.
 * @return The ISAdUnit object corresponding to the ad unit string.
 */
+ (ISAdUnit *)getAdUnit:(NSString *)adUnitString {
    // Check the ad unit string and return the corresponding ISAdUnit object
    if ([adUnitString isEqualToString:@"REWARDED_VIDEO"]) {
        return ISAdUnit.IS_AD_UNIT_REWARDED_VIDEO;
    } else if ([adUnitString isEqualToString:@"INTERSTITIAL"]) {
        return ISAdUnit.IS_AD_UNIT_INTERSTITIAL;
    } else if ([adUnitString isEqualToString:@"BANNER"]) {
        return ISAdUnit.IS_AD_UNIT_BANNER;
    } else if ([adUnitString isEqualToString:@"NATIVE_AD"]) {
        return ISAdUnit.IS_AD_UNIT_NATIVE_AD;
    } else {
        return nil; // Return nil if the ad unit string is invalid
    }
}

/**
 Creates a dictionary containing information about the init error.

 @param error The NSError object representing the error.
 @return A dictionary containing the error information.
 */
+ (NSDictionary *)dictionaryForInitError:(NSError *)error {
    return @{
            @"errorCode": [NSNumber numberWithInteger:error.code],
            @"errorMessage": error.userInfo[NSLocalizedDescriptionKey] ?: [NSNull null],
    };
}

/**
 Creates a dictionary containing information about the init error.

 @param error The NSError object representing the error.
 @return A dictionary containing the error information.
 */
+ (NSDictionary *)dictionaryForInitSuccess:(LPMConfiguration *)config {
    return @{
            @"isAdQualityEnabled": [NSNumber numberWithBool:config.isAdQualityEnabled]
    };
}

/**
 Creates a dictionary containing information about the ad.

 @param adInfo The LPMAdInfo object from which to extract information.
 @return A dictionary containing the ad information.
 */
+ (NSDictionary *)dictionaryForLevelPlayAdInfo:(LPMAdInfo *)adInfo {
    return @{
            @"adUnitId": adInfo.adUnitId, // (nonnull)
            @"adFormat": adInfo.adFormat, // (nonnull)
            @"impressionData": @{
                    @"auctionId": adInfo.auctionId, // (nonnull)
                    @"adUnitName": adInfo.adUnitName, // (nonnull)
                    @"adUnitId": adInfo.adUnitId, // (nonnull)
                    @"adFormat": adInfo.adFormat, // (nonnull)
                    @"country": adInfo.country, // (nonnull)
                    @"ab": adInfo.ab, // (nonnull)
                    @"segmentName": adInfo.segmentName, // (nonnull)
                    @"placement": adInfo.placementName ?: [NSNull null], // (nullable)
                    @"adNetwork": adInfo.adNetwork, // (nonnull)
                    @"instanceName": adInfo.instanceName, // (nonnull)
                    @"instanceId": adInfo.instanceId, // (nonnull)
                    @"revenue": @([adInfo.revenue doubleValue]), // (nonnull)
                    @"precision": adInfo.precision, // (nonnull)
                    @"encryptedCPM": adInfo.encryptedCPM,  // (nonnull)
                    @"conversionValue": adInfo.conversionValue ? @([adInfo.conversionValue doubleValue]) : [NSNull null], // (nullable)
            },
            @"adSize": [self dictionaryForAdSize:adInfo.adSize]
    };
}

+ (NSDictionary *)dictionaryForImpressionData:(ISImpressionData *)impressionData {
    return @{
            @"auctionId": impressionData.auction_id ?: [NSNull null],
            @"adUnit": impressionData.ad_unit ?: [NSNull null],
            @"adUnitName": impressionData.mediation_ad_unit_name ?: [NSNull null],
            @"adUnitId": impressionData.mediation_ad_unit_id ?: [NSNull null],
            @"adFormat": impressionData.ad_format ?: [NSNull null],
            @"country": impressionData.instance_name ?: [NSNull null],
            @"ab": impressionData.ab ?: [NSNull null],
            @"segmentName": impressionData.segment_name ?: [NSNull null],
            @"placement": impressionData.placement ?: [NSNull null],
            @"adNetwork": impressionData.ad_network ?: [NSNull null],
            @"instanceName": impressionData.instance_name ?: [NSNull null],
            @"instanceId": impressionData.instance_id ?: [NSNull null],
            @"revenue": impressionData.revenue ? @([impressionData.revenue doubleValue]) : [NSNull null],
            @"precision": impressionData.precision ?: [NSNull null],
            @"lifetimeRevenue": impressionData.lifetime_revenue ? @([impressionData.lifetime_revenue doubleValue]) : [NSNull null],
            @"encryptedCPM": impressionData.encrypted_cpm ?: [NSNull null],
            @"conversionValue": impressionData.conversion_value ? @([impressionData.conversion_value doubleValue]) : [NSNull null],
    };
}

/**
 Creates a dictionary containing information about the ad size.

 @param adSize The LPMAdSize object.
 @return A dictionary containing the adSize information.
 */
+ (NSDictionary *)dictionaryForAdSize:(LPMAdSize *)adSize {
    if (adSize == nil) {
        return [NSNull null];
    }

    return @{
            @"width": @(adSize.width),
            @"height": @(adSize.height),
            @"adLabel": adSize.sizeDescription,
            @"isAdaptive": @(adSize.isAdaptive)
    };
}

/**
 Creates a dictionary containing information about the ad size.

 @return A dictionary containing the adSize information.
 */
+ (NSDictionary *)dictionaryForLevelPlayAdError:(NSError *)error adUnitId:(NSString *) adUnitId {
    return @{
            @"adUnitId": adUnitId?: [NSNull null],
            @"errorCode": [NSNumber numberWithInteger:error.code],
            @"errorMessage": error.userInfo[NSLocalizedDescriptionKey],
    };
}

+ (NSDictionary *)dictionaryForPlacementInfo:(ISPlacementInfo *)placementInfo {
    return @{
            @"placementName": placementInfo.placementName ?: [NSNull null],
            @"rewardName": placementInfo.rewardName ?: [NSNull null],
            @"rewardAmount": placementInfo.rewardAmount ?: [NSNull null],
    };
}

/// For IronSourceConsentViewError on the plugin
+ (NSDictionary *)dictionaryForIronSourceConsentViewError:(NSError *)error consentViewType:(NSString *)consentViewType {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if(consentViewType != nil){
        dict[@"consentViewType"] = consentViewType;
    }
    dict[@"errorCode"] = [NSNumber numberWithInteger: error.code];
    if(error.userInfo != nil){
        dict[@"message"] = error.userInfo[NSLocalizedDescriptionKey];
    }
    return dict;
}

+ (UIViewController *)getRootViewController {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    UIViewController *rootViewController = keyWindow.rootViewController;

    if (!rootViewController) {
        UIWindow *delegateWindow = [UIApplication sharedApplication].delegate.window;
        rootViewController = delegateWindow.rootViewController;
    }

    NSAssert(rootViewController != nil, @"Root view controller should not be nil");

    return rootViewController;
}

+ (NSDictionary *)dictionaryForLPMReward:(LPMReward *)reward {
    return @{
            @"name": reward.name,
            @"amount": [NSNumber numberWithInteger: reward.amount],
    };
}

@end
