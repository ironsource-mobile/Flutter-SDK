#import <Flutter/Flutter.h>
#import "LevelPlayNativeAdViewFactory.h"

@interface LevelPlayMediationPlugin : NSObject<FlutterPlugin>

+ (void)registerNativeAdViewFactory:(id<FlutterPluginRegistry>)registry
                         viewTypeId:(NSString *)viewTypeId
        nativeAdViewFactory:(LevelPlayNativeAdViewFactory *)nativeAdViewFactory;

+ (void)unregisterNativeAdViewFactory:
        (id<FlutterPluginRegistry>)registry
                           viewTypeId:(NSString *)viewTypeId;

@end
