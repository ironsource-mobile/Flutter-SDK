#import "LevelPlayNativeAdViewFactory.h"
#import "LevelPlayNativeAdView.h"
#import <IronSource/IronSource.h>

/**
 Factory class for creating instances of LevelPlayNativeAdView.
 */
@interface LevelPlayNativeAdViewFactory()
@property (nonatomic, strong) id<FlutterBinaryMessenger> levelPlayBinaryMessenger;
@end

@implementation LevelPlayNativeAdViewFactory

/**
 Initializes the factory with the specified Flutter binary messenger.

 @param levelPlayBinaryMessenger The Flutter binary messenger used to communicate with the Flutter engine.
 @param delegate The delegate used to bind the native ad to the view.
 @param layoutName The layout name provided when implementing custom native ad.
 @return An instance of LevelPlayNativeAdViewFactory.
 */
    - (instancetype)initWithMessenger:(id<FlutterBinaryMessenger>)levelPlayBinaryMessenger delegate:(id<LevelPlayNativeAdViewFactoryDelegate>)delegate layoutName:(nullable NSString *)layoutName
{
    self = [super init];
    if ( self )
    {
        self.levelPlayBinaryMessenger = levelPlayBinaryMessenger;
        self.delegate = delegate;
        self.layoutName = layoutName;
    }
    return self;
}

/**
 Creates an instance of FlutterStandardMessageCodec.

 @return An instance of FlutterStandardMessageCodec.
 */
- (id<FlutterMessageCodec>)createArgsCodec
{
    return [FlutterStandardMessageCodec sharedInstance];
}

/**
 Creates a LevelPlayNativeAdView with the specified frame, view identifier, and arguments.

 @param frame The frame rectangle for the view.
 @param viewId The unique identifier for the view.
 @param args The arguments passed to the view.
 @return A LevelPlayNativeAdView instance.
 */
- (id<FlutterPlatformView>)createWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args
{
    // Extract variables from dict
    NSString *placement = [args[@"placement"] isKindOfClass:[NSString class]] ? args[@"placement"] : nil; // May be NSNull
    NSString *templateType = [args[@"templateType"] isKindOfClass:[NSString class]] ? args[@"templateType"] : nil; // May be NSNull
    NSString *viewType = [args[@"viewType"] isKindOfClass:[NSString class]] ? args[@"viewType"] : nil; // May be NSNull
    NSDictionary *templateStyleDict = [args[@"templateStyle"] isKindOfClass:[NSDictionary class]] ? args[@"templateStyle"] : nil; // May be NSNull
    // Parse LevelPlayNativeAdElementStyle objects
    LevelPlayNativeAdElementStyle *titleStyle = [self parseElementStyle:templateStyleDict[@"titleStyle"]];
    LevelPlayNativeAdElementStyle *bodyStyle = [self parseElementStyle:templateStyleDict[@"bodyStyle"]];
    LevelPlayNativeAdElementStyle *advertiserStyle = [self parseElementStyle:templateStyleDict[@"advertiserStyle"]];
    LevelPlayNativeAdElementStyle *callToActionStyle = [self parseElementStyle:templateStyleDict[@"callToActionStyle"]];
    // Create the template style from parsed element styles(if exist)
    LevelPlayNativeAdTemplateStyle *templateStyle = [[LevelPlayNativeAdTemplateStyle alloc] initWithTitle:titleStyle
                                                                                                bodyStyle:bodyStyle
                                                                                          advertiserStyle:advertiserStyle
                                                                                        callToActionStyle:callToActionStyle];
    // Create the native ad layout
    ISNativeAdView* isNativeAdView = nil;
    NSString *nibName = nil;
    NSBundle *bundle = nil;
    UINib *nib = nil;

    if (self.layoutName != nil) {
        nibName = self.layoutName;
        // Get the bundle
        bundle = [NSBundle mainBundle];
        // Load the NIB
        nib = [UINib nibWithNibName:nibName bundle:bundle];
    } else {
        if ([templateType isEqualToString:@"SMALL"]) {
            nibName = @"LevelPlayNativeAdViewSmall";
        } else if ([templateType isEqualToString:@"MEDIUM"]) {
            nibName = @"LevelPlayNativeAdViewMedium";
        } else {
            @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Invalid templateType" userInfo:nil];
        }
        // Get the bundle path for the resource bundle
        bundle = [NSBundle bundleForClass:[self class]];
        NSURL *bundleURL = [bundle URLForResource:@"ironsource_mediation" withExtension:@"bundle"];
        bundle = [NSBundle bundleWithURL:bundleURL]; // Resource bundle
        // Load the NIB file from the resource bundle
        nib = [UINib nibWithNibName:nibName bundle:bundle];
    }

    NSArray *nibObjects = [nib instantiateWithOwner:nil options:nil];
    if (nibObjects.count > 0) {
        isNativeAdView = nibObjects[0];
    } else {
        isNativeAdView = [[ISNativeAdView alloc] init];
    }

    LevelPlayNativeAdView *nativeAdView = [[LevelPlayNativeAdView alloc] initWithFrame:frame
                                                                                viewId:viewId
                                                                             placement:placement
                                                              levelPlayBinaryMessenger:self.levelPlayBinaryMessenger
                                                                          templateType: templateType
                                                                         templateStyle: templateStyle
                                                                        isNativeAdView: isNativeAdView
                                                                              viewType: viewType];

    nativeAdView.delegate = self.delegate;

    return nativeAdView;
}

- (LevelPlayNativeAdElementStyle *)parseElementStyle:(NSDictionary *)styleDict {
    if (!styleDict || ![styleDict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }

    NSNumber *backgroundColor = styleDict[@"backgroundColor"];
    NSNumber *textSize = styleDict[@"textSize"];
    NSNumber *textColor = styleDict[@"textColor"];
    NSString *fontStyle = styleDict[@"fontStyle"];
    NSNumber *cornerRadius = styleDict[@"cornerRadius"];

    return [[LevelPlayNativeAdElementStyle alloc] initWithBackgroundColor:backgroundColor
                                                                 textSize:textSize
                                                                textColor:textColor
                                                                fontStyle:fontStyle
                                                             cornerRadius:cornerRadius];
}

@end
