#import "LevelPlayInitDelegateHandler.h"

@implementation LevelPlayInitDelegateHandler

- (void)onInitFailed:(NSDictionary *)errorInfo {
    [self invokeChannelMethodWithName:@"onInitFailed" args: errorInfo];
}

- (void)onInitSuccess:(NSDictionary *)configInfo {
    [self invokeChannelMethodWithName:@"onInitSuccess" args: configInfo];
}

@end
