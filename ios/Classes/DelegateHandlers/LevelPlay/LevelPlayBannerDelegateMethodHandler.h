#import "MethodInvoker.h"
#import <IronSource/IronSource.h>

NS_ASSUME_NONNULL_BEGIN

@interface LevelPlayBannerDelegateMethodHandler : MethodInvoker<LevelPlayBannerDelegate>

@property (nonatomic, copy) void (^onDidLoadLevelPlayBanner)(ISBannerView *bannerView, ISAdInfo *adInfo);

- (instancetype)initWithChannel:(FlutterMethodChannel*)channel onDidLoadLevelPlayBanner:(void (^)(ISBannerView *bannerView, ISAdInfo *adInfo))onDidLoadLevelPlayBanner;

@end

NS_ASSUME_NONNULL_END
