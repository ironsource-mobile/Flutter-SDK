#import "MethodInvoker.h"
#import <Flutter/Flutter.h>

@interface MethodInvoker()
@property (nonatomic,strong) FlutterMethodChannel* channel;
@end

@implementation MethodInvoker

- (id)initWithChannel:(FlutterMethodChannel*)channel {
    if (self = [super init]) {
        self.channel = channel;
    }
    return self;
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

@end
