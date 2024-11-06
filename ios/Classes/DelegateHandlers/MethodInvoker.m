#import "MethodInvoker.h"
#import <Flutter/Flutter.h>
#import "../LevelPlayUtils.h"

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

- (void)invokeChannelMethodWithName:(NSString *) methodName args:(NSDictionary *) args {
    [LevelPlayUtils invokeMethodOnUiThreadWithChannel: self.channel methodName: methodName args: args];
}

@end
