#import "ImpressionDataDelegateMethodHandler.h"

@implementation ImpressionDataDelegateMethodHandler

#pragma mark - ISImpressionDataDelegate

- (void)impressionDataDidSucceed:(ISImpressionData *)impressionData {
    if(impressionData == nil){
        [self invokeChannelMethodWithName:@"onImpressionSuccess" args:nil];
    } else {
        NSMutableDictionary *args = [[NSMutableDictionary alloc] init];
        if(impressionData.auction_id != nil){
            args[@"auctionId"] = impressionData.auction_id;
        }
        if(impressionData.ad_unit != nil){
            args[@"adUnit"] = impressionData.ad_unit;
        }
        if(impressionData.country != nil){
            args[@"country"] = impressionData.country;
        }
        if(impressionData.ab != nil){
            args[@"ab"] = impressionData.ab;
        }
        if(impressionData.segment_name != nil){
            args[@"segmentName"] = impressionData.segment_name;
        }
        if(impressionData.placement != nil){
            args[@"placement"] = impressionData.placement;
        }
        if(impressionData.ad_network != nil){
            args[@"adNetwork"] = impressionData.ad_network;
        }
        if(impressionData.instance_name != nil){
            args[@"instanceName"] = impressionData.instance_name;
        }
        if(impressionData.instance_id != nil){
            args[@"instanceId"] = impressionData.instance_id;
        }
        if(impressionData.revenue != nil){
            args[@"revenue"] = impressionData.revenue;
        }
        if(impressionData.precision != nil){
            args[@"precision"] = impressionData.precision;
        }
        if(impressionData.lifetime_revenue != nil){
            args[@"lifetimeRevenue"] = impressionData.lifetime_revenue;
        }
        if(impressionData.encrypted_cpm != nil){
            args[@"encryptedCPM"] = impressionData.encrypted_cpm;
        }
        [self invokeChannelMethodWithName:@"onImpressionSuccess" args:args];
    }
}

@end
