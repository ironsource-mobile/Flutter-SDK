#import "ConsentViewType.h"

@implementation NSString (ConsentViewType)

- (NSDictionary *)toConsentViewTypeArgDictionary{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"consentViewType"] = self;
    return dict;
}

@end
