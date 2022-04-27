#import <Flutter/Flutter.h>
#import "ATTrackingManagerChannel.h"
#import <AppTrackingTransparency/AppTrackingTransparency.h>

@implementation ATTrackingManagerChannel

// Register the MethodCallHandler to the channel with the main plugin's binaryMessenger
+ (void)registerWithMessenger:(NSObject<FlutterBinaryMessenger> *)messenger{
    FlutterMethodChannel* attChannel = [FlutterMethodChannel
                                     methodChannelWithName:@"ironsource_mediation/att"
                                     binaryMessenger:messenger];
    
    // This handler will be invoked on the UI thread.
    [attChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        if([@"getTrackingAuthorizationStatus" isEqualToString:call.method]) {
            [ATTrackingManagerChannel getTrackingAuthorizationStatusWithResult:result];
        } else if([@"requestTrackingAuthorization" isEqualToString:call.method]) {
            [ATTrackingManagerChannel requestTrackingAuthorizationWithResult:result];
        }else {
            result(FlutterMethodNotImplemented);
        }
    }];
}

+ (void)getTrackingAuthorizationStatusWithResult:(FlutterResult)result {
    if (@available(iOS 14, *)) {
        result([NSNumber numberWithInt:(int)ATTrackingManager.trackingAuthorizationStatus]);
    } else {
        result([NSNumber numberWithInt:-1]);
    }
}

+ (void)requestTrackingAuthorizationWithResult:(FlutterResult)result {
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                result([NSNumber numberWithInt:(int)status]);
        }];
    } else {
        result([NSNumber numberWithInt:-1]);
    }
}

@end
