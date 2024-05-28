#import <Flutter/Flutter.h>
#import "LevelPlayNativeAdViewFactory.h"

@interface IronSourceMediationPlugin : NSObject<FlutterPlugin>

+ (void)registerNativeAdViewFactory:(id<FlutterPluginRegistry>)registry
                         viewTypeId:(NSString *)viewTypeId
        nativeAdViewFactory:(LevelPlayNativeAdViewFactory *)nativeAdViewFactory;

+ (void)unregisterNativeAdViewFactory:
        (id<FlutterPluginRegistry>)registry
                           viewTypeId:(NSString *)viewTypeId;

@end
