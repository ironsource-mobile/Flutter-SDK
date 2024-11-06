#import "ConsentViewDelegateMethodHandler.h"
#import "../LevelPlayUtils.h"

@implementation ConsentViewDelegateMethodHandler

#pragma mark - ISConsentViewDelegate

- (void)consentViewDidLoadSuccess:(NSString *)consentViewType {
    NSDictionary *args = @{
            @"consentViewType": consentViewType
    };
    [self invokeChannelMethodWithName:@"consentViewDidLoadSuccess" args:args];
}

- (void)consentViewDidFailToLoadWithError:(NSError *)error consentViewType:(NSString *)consentViewType {
    [self invokeChannelMethodWithName:@"consentViewDidFailToLoad" args: [LevelPlayUtils dictionaryForIronSourceConsentViewError: error consentViewType: consentViewType]];
}

- (void)consentViewDidShowSuccess:(NSString *)consentViewType {
    NSDictionary *args = @{
            @"consentViewType": consentViewType
    };
    [self invokeChannelMethodWithName:@"consentViewDidShowSuccess" args:args];
}

- (void)consentViewDidFailToShowWithError:(NSError *)error consentViewType:(NSString *)consentViewType {
    [self invokeChannelMethodWithName:@"consentViewDidFailToShow" args: [LevelPlayUtils dictionaryForIronSourceConsentViewError: error consentViewType: consentViewType]];
}

- (void)consentViewDidAccept:(NSString *)consentViewType {
    NSDictionary *args = @{
            @"consentViewType": consentViewType
    };
    [self invokeChannelMethodWithName:@"consentViewDidAccept" args:args];
}

- (void)consentViewDidDismiss:(NSString *)consentViewType {
    // Deprecated: Will never be called by the SDK.
}

@end
