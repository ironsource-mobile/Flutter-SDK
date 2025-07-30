#import <Flutter/Flutter.h>
#import <Foundation/Foundation.h>
#import <IronSource/IronSource.h>

@interface LevelPlayUtils : NSObject

+ (void)invokeMethodOnUiThreadWithChannel:(FlutterMethodChannel *)channel methodName:(NSString *)methodName args:(NSDictionary *)args;
+ (NSDictionary *)dictionaryForNativeAd:(LevelPlayNativeAd *)nativeAd;
+ (NSDictionary *)dictionaryForAdInfo:(ISAdInfo *)adInfo;
+ (NSDictionary *)dictionaryForError:(NSError *)error;
+ (NSData *)dataFromImage:(UIImage *)image;
+ (ISAdUnit *)getAdUnit:(NSString *)adUnitString;
+ (NSDictionary *)dictionaryForInitError:(NSError *)error;
+ (NSDictionary *)dictionaryForInitSuccess:(LPMConfiguration *)config;
+ (NSDictionary *)dictionaryForLevelPlayAdInfo:(LPMAdInfo *)adInfo;
+ (NSDictionary *)dictionaryForImpressionData:(ISImpressionData *)impressionData;
+ (NSDictionary *)dictionaryForAdSize:(LPMAdSize *)adSize;
+ (NSDictionary *)dictionaryForLevelPlayAdError:(NSError *)error adUnitId:(NSString *) adUnitId;
+ (NSDictionary *)dictionaryForPlacementInfo:(ISPlacementInfo *)placementInfo;
+ (NSDictionary *)dictionaryForIronSourceConsentViewError:(NSError *)error consentViewType:(NSString *)consentViewType;
+ (UIViewController *)getRootViewController;
+ (NSDictionary *)dictionaryForLPMReward:(LPMReward *)reward;
+ (NSDictionary *)dictionaryForLPMImpressionData:(LPMImpressionData *)impressionData;

@end
