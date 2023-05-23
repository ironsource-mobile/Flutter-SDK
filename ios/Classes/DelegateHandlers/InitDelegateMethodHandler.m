#import "InitDelegateMethodHandler.h"

@implementation InitDelegateMethodHandler

#pragma mark - ISInitializationDelegate

- (void)initializationDidComplete {
    [self invokeChannelMethodWithName:@"onInitializationComplete" args:nil];
}

@end
