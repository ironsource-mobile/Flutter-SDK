#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>
#import <IronSource/IronSource.h>
#import "LevelPlayNativeAdViewFactory.h"

/**
 * This class is an example of how to implement custom native ad.
 * The Class must receive BinaryMessenger and the layoutId of the
 * native ad layout that the developer wants to load. It also
 * must extend the LevelPlayNativeAdViewFactory and override the
 * method bindNativeAdToView in order to fill the view with the
 * loaded native ad.
 */
@interface NativeAdViewFactoryExample : LevelPlayNativeAdViewFactory <LevelPlayNativeAdViewFactoryDelegate>

- (instancetype)initWithMessenger:(id<FlutterBinaryMessenger>)levelPlayBinaryMessenger layoutName:(nullable NSString *)layoutName;

@end
