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
            @"adNetwork": adInfo.ad_network ?: [NSNull null],
            @"instanceName": adInfo.instance_name ?: [NSNull null],
            @"instanceId": adInfo.instance_id ?: [NSNull null],
            @"country": adInfo.country ?: [NSNull null],
            @"revenue": adInfo.revenue != nil ? @(adInfo.revenue.doubleValue) : [NSNull null],
            @"precision": adInfo.precision ?: [NSNull null],
            @"ab": adInfo.ab ?: [NSNull null],
            @"segmentName": adInfo.segment_name ?: [NSNull null],
            @"encryptedCPM": adInfo.encrypted_cpm ?: [NSNull null],
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
 Creates a dictionary containing information about the init success.

 @param config The LPMConfiguration object representing the configuration.
 @return A dictionary containing the configuration information.
 */
+ (NSDictionary *)dictionaryForInitSuccess:(LPMConfiguration *)config {
    return @{
            @"isAdQualityEnabled": [NSNumber numberWithBool:config.isAdQualityEnabled],
            @"ab": config.ab ?: [NSNull null]
    };
}

/**
 Creates a dictionary containing information about the ad.

 @param adInfo The LPMAdInfo object from which to extract information.
 @return A dictionary containing the ad information.
 */
+ (NSDictionary *)dictionaryForLevelPlayAdInfo:(LPMAdInfo *)adInfo {
    return @{
            @"adId": adInfo.adId, // (nonnull)
            @"adUnitId": adInfo.adUnitId, // (nonnull)
            @"adUnitName": adInfo.adUnitName, // (nonnull)
            @"adSize": [self dictionaryForAdSize:adInfo.adSize],
            @"adFormat": adInfo.adFormat, // (nonnull)
            @"placementName": adInfo.placementName ?: [NSNull null], // (nullable)
            @"auctionId": adInfo.auctionId, // (nonnull)
            @"country": adInfo.country, // (nonnull)
            @"ab": adInfo.ab, // (nonnull)
            @"segmentName": adInfo.segmentName, // (nonnull)
            @"adNetwork": adInfo.adNetwork, // (nonnull)
            @"instanceName": adInfo.instanceName, // (nonnull)
            @"instanceId": adInfo.instanceId, // (nonnull)
            @"revenue": @([adInfo.revenue doubleValue]), // (nonnull)
            @"precision": adInfo.precision, // (nonnull)
            @"encryptedCPM": adInfo.encryptedCPM,  // (nonnull)
            @"conversionValue": adInfo.conversionValue ? @([adInfo.conversionValue doubleValue]) : [NSNull null], // (nullable)
            @"creativeId": adInfo.creativeId, // (nonnull)
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

+ (NSDictionary *)dictionaryForLPMImpressionData:(LPMImpressionData *)impressionData {
    return @{
            @"auctionId": impressionData.auctionId ?: [NSNull null],
            @"mediationAdUnitName": impressionData.mediationAdUnitName ?: [NSNull null],
            @"mediationAdUnitId": impressionData.mediationAdUnitId ?: [NSNull null],
            @"adFormat": impressionData.adFormat ?: [NSNull null],
            @"country": impressionData.country ?: [NSNull null],
            @"ab": impressionData.ab ?: [NSNull null],
            @"segmentName": impressionData.segmentName ?: [NSNull null],
            @"placement": impressionData.placement ?: [NSNull null],
            @"adNetwork": impressionData.adNetwork ?: [NSNull null],
            @"instanceName": impressionData.instanceName ?: [NSNull null],
            @"instanceId": impressionData.instanceId ?: [NSNull null],
            @"revenue": impressionData.revenue ? @([impressionData.revenue doubleValue]) : [NSNull null],
            @"precision": impressionData.precision ?: [NSNull null],
            @"encryptedCPM": impressionData.encryptedCpm ?: [NSNull null],
            @"conversionValue": impressionData.conversionValue ? @([impressionData.conversionValue doubleValue]) : [NSNull null],
            @"creativeId": impressionData.creativeId ?: [NSNull null],
    };
}

@end
