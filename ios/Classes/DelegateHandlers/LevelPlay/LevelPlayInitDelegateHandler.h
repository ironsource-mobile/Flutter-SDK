#import "MethodInvoker.h"
#import <IronSource/IronSource.h>

NS_ASSUME_NONNULL_BEGIN

@interface LevelPlayInitDelegateHandler : MethodInvoker

- (void)onInitFailed:(NSDictionary *)errorInfo;
- (void)onInitSuccess:(NSDictionary *)config;

@end

NS_ASSUME_NONNULL_END