#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import "LevelPlayNativeAdTemplateStyle.h"
#import "LevelPlayNativeAdElementStyle.h"
#import <IronSource/IronSource.h>

@protocol LevelPlayNativeAdViewFactoryDelegate <NSObject>
- (void)bindNativeAdToView:(LevelPlayNativeAd *)nativeAd isNativeAdView:(ISNativeAdView *)isNativeAdView;
@end

@interface LevelPlayNativeAdViewFactory : NSObject<FlutterPlatformViewFactory>
@property (nonatomic, strong) NSString *layoutName;

@property (nonatomic, weak) id<LevelPlayNativeAdViewFactoryDelegate> delegate;

- (instancetype)initWithMessenger:(id<FlutterBinaryMessenger>)levelPlayBinaryMessenger
                         delegate:(id<LevelPlayNativeAdViewFactoryDelegate>)delegate
                         layoutName:(nullable NSString *)layoutName;
@end
