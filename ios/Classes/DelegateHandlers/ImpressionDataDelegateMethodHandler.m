#import "ImpressionDataDelegateMethodHandler.h"
#import "../LevelPlayUtils.h"

@implementation ImpressionDataDelegateMethodHandler

#pragma mark - ISImpressionDataDelegate

- (void)impressionDataDidSucceed:(ISImpressionData *)impressionData {
    [self invokeChannelMethodWithName:@"onImpressionSuccess" args: impressionData != nil ? [LevelPlayUtils dictionaryForImpressionData:impressionData] : [NSNull null]];
}

@end
