#import "LevelPlayUtils.h"

@implementation LevelPlayUtils

/**
 Creates a dictionary containing information about the native ad.

 @param nativeAd The LevelPlayNativeAd object from which to extract information.
 @return A dictionary containing the native ad information.
 */
+ (NSDictionary *)dictionaryForNativeAd:(LevelPlayNativeAd *)nativeAd {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];

    // Add other properties as needed
    [dictionary setObject:(nativeAd.title ?: [NSNull null]) forKey:@"title"];
    [dictionary setObject:(nativeAd.advertiser ?: [NSNull null]) forKey:@"advertiser"];
    [dictionary setObject:(nativeAd.body ?: [NSNull null]) forKey:@"body"];
    [dictionary setObject:(nativeAd.callToAction ?: [NSNull null]) forKey:@"callToAction"];
    [dictionary setObject:(nativeAd.icon.url.absoluteString ?: [NSNull null]) forKey:@"iconUri"];

    // Convert UIImage to NSData
    NSData *iconImageData = [self dataFromImage:nativeAd.icon.image];
    [dictionary setObject:(iconImageData ?: [NSNull null]) forKey:@"iconImageData"];

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
            @"lifetimeRevenue": adInfo.lifetime_revenue ?: [NSNull null],
            @"encryptedCpm": adInfo.encrypted_cpm ?: [NSNull null],
            @"conversionValue": adInfo.conversion_value ?: [NSNull null],
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

@end
