#import "IronSourceError.h"

@implementation NSError (IronSourceError)

/// For IronSourceError on the plugin
- (NSDictionary *)toArgDictionary{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    dict[@"errorCode"] = [NSNumber numberWithInteger: self.code];
    if(self.userInfo != nil){
        dict[@"message"] = self.userInfo[NSLocalizedDescriptionKey];
    }
    return dict;
}

/// For IronSourceConsentViewError on the plugin
- (NSDictionary *)toArgDictionaryWithConsentViewType:(NSString *)consentViewType{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if(consentViewType != nil){
        dict[@"consentViewType"] = consentViewType;
    }
    dict[@"errorCode"] = [NSNumber numberWithInteger: self.code];
    if(self.userInfo != nil){
        dict[@"message"] = self.userInfo[NSLocalizedDescriptionKey];
    }
    return dict;
}

@end
