#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <IronSource/IronSource.h>
#import "LevelPlayNativeAdViewFactory.h"

@interface LevelPlayNativeAdViewFactoryTemplate : LevelPlayNativeAdViewFactory <LevelPlayNativeAdViewFactoryDelegate>

- (instancetype)initWithMessenger:(id<FlutterBinaryMessenger>)levelPlayBinaryMessenger;

@end
