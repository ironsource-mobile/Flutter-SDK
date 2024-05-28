#import <IronSource/IronSource.h>
#import "LevelPlayNativeAdView.h"
#import "LevelPlayUtils.h"

/**
 Class for implementing instance of LevelPlayNativeAdView.
 */
@interface LevelPlayNativeAdView()<LevelPlayNativeAdDelegate>

// MARK: Properties

@property (nonatomic, strong) FlutterMethodChannel *methodChannel;
@property (nonatomic, strong, nullable) LevelPlayNativeAd *nativeAd;
@property (nonatomic, copy, nullable) NSString *placement;
@property (nonatomic, copy, nullable) NSString *templateType;
@property (nonatomic, copy, nullable) LevelPlayNativeAdTemplateStyle *templateStyle;
@property (nonatomic, strong) ISNativeAdView *isNativeAdView;

@end

@implementation LevelPlayNativeAdView

// MARK: Initialization

- (instancetype)initWithFrame:(CGRect)frame
                       viewId:(int64_t)viewId
        placement:(nullable NSString *)placement
        levelPlayBinaryMessenger:(id<FlutterBinaryMessenger>)levelPlayBinaryMessenger
        templateType:(nullable NSString *)templateType
        templateStyle:(nullable LevelPlayNativeAdTemplateStyle *)templateStyle
        isNativeAdView:(ISNativeAdView *)isNativeAdView
        viewType:(nullable NSString *)viewType
{
    self = [super init];
    if ( self )
    {
        self.placement = placement;
        self.templateType = templateType;
        self.templateStyle = templateStyle;
        self.isNativeAdView = isNativeAdView;

        NSString *uniqueChannelName = [NSString stringWithFormat: @"%@_%lld", viewType, viewId];
        self.methodChannel = [FlutterMethodChannel methodChannelWithName: uniqueChannelName binaryMessenger: levelPlayBinaryMessenger];

        __weak typeof(self) weakSelf = self;
        [self.methodChannel setMethodCallHandler:^(FlutterMethodCall *call, FlutterResult result) {
            [weakSelf handleMethodCall:call result:result];
        }];

        // Apply styles before ad loaded
        [self applyStylesWithTitleView:self.isNativeAdView.adTitleView
                              bodyView:self.isNativeAdView.adBodyView
                        advertiserView:self.isNativeAdView.adBodyView
                      callToActionView:self.isNativeAdView.adCallToActionView];
    }
    return self;
}

- (void)applyStylesWithTitleView:(UILabel *)titleView
                      bodyView:(UILabel *)bodyView
                advertiserView:(UILabel *)advertiserView
              callToActionView:(UIButton *)callToActionView {
    if (self.templateStyle) {
        [self applyStyleToTextView:titleView style:self.templateStyle.titleStyle];
        [self applyStyleToTextView:bodyView style:self.templateStyle.bodyStyle];
        [self applyStyleToTextView:advertiserView style:self.templateStyle.advertiserStyle];
        [self applyStyleToButton:callToActionView style:self.templateStyle.callToActionStyle];
    }
}

- (void)applyStyleToTextView:(UILabel *)textView style:(LevelPlayNativeAdElementStyle *)style {
    if (textView && style) {
        [self applyCommonStyles:textView style:style];

        if (style.textColor && ![style.textColor isKindOfClass:[NSNull class]]) {
            UIColor *textColor = [UIColor colorWithRed:((CGFloat)(([style.textColor integerValue] >> 16) & 0xFF)) / 255.0
                                                 green:((CGFloat)(([style.textColor integerValue] >> 8) & 0xFF)) / 255.0
                                                  blue:((CGFloat)([style.textColor integerValue] & 0xFF)) / 255.0
                                                 alpha:1.0];
            [textView setTextColor:textColor];
        }
        if (style.fontStyle && ![style.fontStyle isKindOfClass:[NSNull class]]) {
            [textView setFont:[self parseFontStyle:style.fontStyle]];
        }
        if (style.textSize && ![style.textSize isKindOfClass:[NSNull class]]) {
            [textView setFont:[textView.font fontWithSize:[style.textSize floatValue]]];
        }
    }
}

- (void)applyStyleToButton:(UIButton *)button style:(LevelPlayNativeAdElementStyle *)style {
    if (button && style) {
        [self applyCommonStyles:button style:style];

        if (style.textColor && ![style.textColor isKindOfClass:[NSNull class]]) {
            UIColor *textColor = [UIColor colorWithRed:((CGFloat)(([style.textColor integerValue] >> 16) & 0xFF)) / 255.0
                                                 green:((CGFloat)(([style.textColor integerValue] >> 8) & 0xFF)) / 255.0
                                                  blue:((CGFloat)([style.textColor integerValue] & 0xFF)) / 255.0
                                                 alpha:1.0];
            [button setTitleColor:textColor forState:UIControlStateNormal];
        }
        if (style.fontStyle && ![style.fontStyle isKindOfClass:[NSNull class]]) {
            [button.titleLabel setFont:[self parseFontStyle:style.fontStyle]];
        }
        if (style.textSize && ![style.textSize isKindOfClass:[NSNull class]]) {
            [button.titleLabel setFont:[button.titleLabel.font fontWithSize:[style.textSize floatValue]]];
        }
    }
}

- (void)applyCommonStyles:(UIView *)view style:(LevelPlayNativeAdElementStyle *)style {
    if (view && style) {
        if (style.backgroundColor && ![style.backgroundColor isKindOfClass:[NSNull class]]) {
            UIColor *backgroundColor = [UIColor colorWithRed:((CGFloat)(([style.backgroundColor integerValue] >> 16) & 0xFF)) / 255.0
                                                       green:((CGFloat)(([style.backgroundColor integerValue] >> 8) & 0xFF)) / 255.0
                                                        blue:((CGFloat)([style.backgroundColor integerValue] & 0xFF)) / 255.0
                                                       alpha:1.0];
            view.backgroundColor = backgroundColor;
        }
        if (style.cornerRadius && ![style.cornerRadius isKindOfClass:[NSNull class]]) {
            CGFloat cornerRadius = [style.cornerRadius floatValue];
            view.layer.cornerRadius = cornerRadius;
            view.layer.masksToBounds = YES;
        }
    }
}


- (UIFont *)parseFontStyle:(NSString *)fontStyle {
    if (fontStyle) {
        NSString *lowercaseFontStyle = [fontStyle lowercaseString];
        if ([lowercaseFontStyle containsString:@"bold"]) {
            return [UIFont boldSystemFontOfSize:[UIFont systemFontSize]];
        } else if ([lowercaseFontStyle containsString:@"italic"]) {
            return [UIFont italicSystemFontOfSize:[UIFont systemFontSize]];
        } else if ([lowercaseFontStyle containsString:@"monospace"]) {
            // Implement monospace font handling if needed
            // Example: return [UIFont fontWithName:@"Courier" size:[UIFont systemFontSize]];
            // Use system default font size for monospace font
            return [UIFont systemFontOfSize:[UIFont systemFontSize]];
        }
    }
    return [UIFont systemFontOfSize:[UIFont systemFontSize]]; // Default font size
}

// MARK: Method Call Handling

/**
 Handles method calls received from Flutter.

 @param call The method call received from Flutter.
 @param result The result to be sent back to Flutter.
 */
- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *methodName = call.method;

    if ([methodName isEqualToString:@"loadAd"]) {
        [self loadAd:result];
    } else if ([methodName isEqualToString:@"destroyAd"]) {
        [self destroyAd:result];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

// MARK: Native Ad View Methods

/**
 Loads the native ad and informs the Flutter side upon completion.

 @param result The Flutter result callback to notify the completion of the method call.
 */
- (void)loadAd:(FlutterResult)result {
    // If the native ad is not initialized, create a new one
    if (_nativeAd == nil) {
        _nativeAd = [[[[LevelPlayNativeAdBuilder new]
                withViewController:(UIViewController *)self]
                withPlacementName:self.placement] // Replace with your placement or leave empty
                withDelegate:self]    // We implement the delegate in step 2
                .build;
    }

    // Load the native ad
    [_nativeAd loadAd];

    // Inform the Flutter side that the ad loading is complete
    result(nil);
}

/**
 Destroys the native ad and informs the Flutter side upon completion.

 @param result The Flutter result callback to notify the completion of the method call.
 */
- (void)destroyAd:(FlutterResult)result {
    // Remove any added views from the native ad
    [self removeViews];

    // Destroy the native ad
    [self.nativeAd destroyAd];

    // Set the native ad reference to nil
    self.nativeAd = nil;

    // Notify the Flutter side that the method call has completed
    result(nil);
}

// MARK: View

- (ISNativeAdView *)view
{
    return self.isNativeAdView;
}

// MARK: Deallocation

- (void)dealloc
{
    // Remove any views
    [self removeViews];
    // Destroy the ad
    [self.nativeAd destroyAd];
    self.nativeAd = nil;
    // Ensure method channel is set
    if (self.methodChannel != nil) {
        // Retain the method channel temporarily to avoid deallocation during the async block
        FlutterMethodChannel *methodChannel = self.methodChannel;
        // Set method call handler to nil on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            [methodChannel setMethodCallHandler:nil];
        });
        // Release the retained method channel after async block execution
        self.methodChannel = nil;
    }
}

/**
 Removes all the subviews associated with the native ad view.
 This method removes the title view, body view, advertiser view, call to action view, icon view, and media view if they exist.
 */
-(void) removeViews
{
    [self.isNativeAdView removeFromSuperview];
}

// MARK: LevelPlayNativeAdDelegate

/**
 Called after a native ad has been successfully loaded
 @param nativeAd Level Play native ad.
 @param adInfo The info of the ad.
 */
-(void)didLoad:(LevelPlayNativeAd *)nativeAd
    withAdInfo:(ISAdInfo *)adInfo{
    // Save native ad instance
    _nativeAd = nativeAd;

    [self.delegate bindNativeAdToView:nativeAd isNativeAdView:self.isNativeAdView];

    // Notify Flutter that the ad has been loaded
    NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys:
            [LevelPlayUtils dictionaryForNativeAd:nativeAd], @"nativeAd",
            [LevelPlayUtils dictionaryForAdInfo:adInfo], @"adInfo",
            nil];
    [self.methodChannel invokeMethod:@"onAdLoaded" arguments:args];
}

/**
 Called after a native has attempted to load an ad but failed.
 @param nativeAd Level Play native ad.
 @param error The reason for the error
 */
-(void)didFailToLoad:(LevelPlayNativeAd *)nativeAd
           withError:(NSError *)error{
    NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys:
            [LevelPlayUtils dictionaryForNativeAd:nativeAd], @"nativeAd",
            [LevelPlayUtils dictionaryForError:error], @"error",
            nil];
    [self.methodChannel invokeMethod:@"onAdLoadFailed" arguments:args];
}
/**
 Called after a native ad impression has been recorded.
 @param nativeAd Level Play native ad.
 @param adInfo The info of the ad.
 */
-(void)didRecordImpression:(LevelPlayNativeAd *)nativeAd
                withAdInfo:(ISAdInfo *)adInfo{
    NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys:
            [LevelPlayUtils dictionaryForNativeAd:nativeAd], @"nativeAd",
            [LevelPlayUtils dictionaryForAdInfo:adInfo], @"adInfo",
            nil];
    [self.methodChannel invokeMethod:@"onAdImpression" arguments:args];
}

/**
 Called after a native ad has been clicked.
 @param nativeAd Level Play native ad.
 @param adInfo The info of the ad.
 */
-(void)didClick:(LevelPlayNativeAd *)nativeAd
     withAdInfo:(ISAdInfo *)adInfo{
    NSDictionary *args = [NSDictionary dictionaryWithObjectsAndKeys:
            [LevelPlayUtils dictionaryForNativeAd:nativeAd], @"nativeAd",
            [LevelPlayUtils dictionaryForAdInfo:adInfo], @"adInfo",
            nil];
    [self.methodChannel invokeMethod:@"onAdClicked" arguments:args];
}

@end
