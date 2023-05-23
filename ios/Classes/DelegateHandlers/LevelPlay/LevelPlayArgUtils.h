#import <Foundation/Foundation.h>
#import <IronSource/IronSource.h>

NS_ASSUME_NONNULL_BEGIN

@interface LevelPlayArgUtils : NSObject
+ (NSDictionary *)getDictionaryWithPlacement:(ISPlacementInfo *)placementInfo andAdInfo:(ISAdInfo *)adInfo;
+ (NSDictionary *)getDictionaryWithError:(NSError *)error andAdInfo:(ISAdInfo *)adInfo;
@end

NS_ASSUME_NONNULL_END
