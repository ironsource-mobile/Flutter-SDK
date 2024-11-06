#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <IronSource/IronSource.h>

@interface LevelPlayBannerAdViewFactory : NSObject<FlutterPlatformViewFactory>

- (instancetype)initWithMessenger:(id<FlutterBinaryMessenger>)levelPlayBinaryMessenger;
@end
