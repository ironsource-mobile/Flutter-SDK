#import "ISPlacementInfo.h"

@implementation ISPlacementInfo (ISPlacementInfo)

- (NSDictionary *)toArgDictionary{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if(self.placementName != nil){
        dict[@"placementName"] = self.placementName;
    }
    if(self.rewardName != nil){
        dict[@"rewardName"] = self.rewardName;
    }
    if(self.rewardAmount != nil){
        dict[@"rewardAmount"] = self.rewardAmount;
    }
    return dict;
};

@end
