#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <IronSource/IronSource.h>
#import "LevelPlayBannerAdViewFactory.h"

NS_ASSUME_NONNULL_BEGIN

@interface LevelPlayBannerAdView : NSObject<FlutterPlatformView>

- (instancetype _Nullable )initWithFrame:(CGRect)frame
                                  viewId:(int64_t)viewId
                levelPlayBinaryMessenger:(id<FlutterBinaryMessenger>_Nonnull)levelPlayBinaryMessenger
                                  bannerAdView:(LPMBannerAdView *)bannerAdView
                                viewType:(NSString *)viewType;

@end

NS_ASSUME_NONNULL_END