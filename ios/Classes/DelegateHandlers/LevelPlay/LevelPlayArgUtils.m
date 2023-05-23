#import "LevelPlayArgUtils.h"
#import "ISPlacementInfo.h"
#import "IronSourceError.h"
#import "AdInfo.h"

@implementation LevelPlayArgUtils

+ (NSDictionary *)getDictionaryWithPlacement:(ISPlacementInfo *)placementInfo
                                   andAdInfo:(ISAdInfo *)adInfo {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"placement"] = [placementInfo toArgDictionary];
    dict[@"adInfo"] = [adInfo toArgDictionary];
    return dict;
}

+ (NSDictionary *)getDictionaryWithError:(NSError *)error
                               andAdInfo:(ISAdInfo *)adInfo {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"error"] = [error toArgDictionary];
    dict[@"adInfo"] = [adInfo toArgDictionary];
    return dict;
}

@end
