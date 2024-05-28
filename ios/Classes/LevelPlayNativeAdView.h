#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <IronSource/IronSource.h>
#import "LevelPlayNativeAdTemplateStyle.h"
#import "LevelPlayNativeAdViewFactory.h"

@interface LevelPlayNativeAdView : NSObject<FlutterPlatformView>

@property (nonatomic, weak) id<LevelPlayNativeAdViewFactoryDelegate> delegate;

- (instancetype _Nullable )initWithFrame:(CGRect)frame
                                  viewId:(int64_t)viewId
                               placement:(nullable NSString *)placement
        levelPlayBinaryMessenger:(id<FlutterBinaryMessenger>_Nonnull)levelPlayBinaryMessenger
        templateType:(nullable NSString *)templateType
        templateStyle:(nullable LevelPlayNativeAdTemplateStyle *)templateStyle
        isNativeAdView:(ISNativeAdView *)isNativeAdView
        viewType:(nullable NSString *)viewType;

@end
