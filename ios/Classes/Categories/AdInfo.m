#import "AdInfo.h"

@implementation ISAdInfo (AdInfo)

- (NSDictionary *)toArgDictionary {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if(self.auction_id != nil){
        dict[@"auctionId"] = self.auction_id;
    }
    if(self.ad_unit != nil){
        dict[@"adUnit"] = self.ad_unit;
    }
    if(self.ad_network != nil){
        dict[@"adNetwork"] = self.ad_network;
    }
    if(self.instance_name != nil){
        dict[@"instanceName"] = self.instance_name;
    }
    if(self.instance_id != nil){
        dict[@"instanceId"] = self.instance_id;
    }
    if(self.country != nil){
        dict[@"country"] = self.country;
    }
    if(self.revenue != nil){
        dict[@"revenue"] = self.revenue;
    }
    if(self.precision != nil){
        dict[@"precision"] = self.precision;
    }
    if(self.ab != nil){
        dict[@"ab"] = self.ab;
    }
    if(self.segment_name != nil){
        dict[@"segmentName"] = self.segment_name;
    }
    if(self.encrypted_cpm != nil){
        dict[@"encryptedCPM"] = self.encrypted_cpm;
    }

    return dict;
}

@end
