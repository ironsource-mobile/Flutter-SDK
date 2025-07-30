#import "LevelPlayImpressionDataDelegateHandler.h"
#import "../../LevelPlayUtils.h"

@implementation LevelPlayImpressionDataDelegateHandler

#pragma mark - ISImpressionDataDelegate

- (void)impressionDataDidSucceed:(LPMImpressionData *)impressionData {
    [self invokeChannelMethodWithName:@"onLevelPlayImpressionSuccess" args: impressionData != nil ? [LevelPlayUtils dictionaryForLPMImpressionData:impressionData] : [NSNull null]];
}

@end
