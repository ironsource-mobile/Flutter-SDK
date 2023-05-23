#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSError (IronSourceError)
- (NSDictionary *)toArgDictionary;
- (NSDictionary *)toArgDictionaryWithConsentViewType:(NSString *)consentViewType;
@end

NS_ASSUME_NONNULL_END
