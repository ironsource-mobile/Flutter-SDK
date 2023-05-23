#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface MethodInvoker: NSObject
- (id)initWithChannel:(FlutterMethodChannel*)channel;
- (void)invokeChannelMethodWithName:(NSString *) methodName args:(id _Nullable) args;
@end

NS_ASSUME_NONNULL_END
