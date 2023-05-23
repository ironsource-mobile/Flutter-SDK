#import "ConsentViewDelegateMethodHandler.h"
#import "ConsentViewType.h"
#import "IronSourceError.h"

@implementation ConsentViewDelegateMethodHandler

#pragma mark - ISConsentViewDelegate

- (void)consentViewDidLoadSuccess:(NSString *)consentViewType {
    NSDictionary *args = [consentViewType toConsentViewTypeArgDictionary];
    [self invokeChannelMethodWithName:@"consentViewDidLoadSuccess" args:args];
}

- (void)consentViewDidFailToLoadWithError:(NSError *)error consentViewType:(NSString *)consentViewType {
    NSDictionary *args = [error toArgDictionaryWithConsentViewType:consentViewType];
    [self invokeChannelMethodWithName:@"consentViewDidFailToLoad" args:args];
}

- (void)consentViewDidShowSuccess:(NSString *)consentViewType {
    NSDictionary *args = [consentViewType toConsentViewTypeArgDictionary];
    [self invokeChannelMethodWithName:@"consentViewDidShowSuccess" args:args];
}

- (void)consentViewDidFailToShowWithError:(NSError *)error consentViewType:(NSString *)consentViewType {
    NSDictionary *args = [error toArgDictionaryWithConsentViewType:consentViewType];
    [self invokeChannelMethodWithName:@"consentViewDidFailToShow" args:args];
}

- (void)consentViewDidAccept:(NSString *)consentViewType {
    NSDictionary *args = [consentViewType toConsentViewTypeArgDictionary];
    [self invokeChannelMethodWithName:@"consentViewDidAccept" args:args];
}

- (void)consentViewDidDismiss:(NSString *)consentViewType {
    // Deprecated: Will never be called by the SDK.
}

@end
