#import <Flutter/Flutter.h>
#import <Foundation/Foundation.h>
#import <IronSource/IronSource.h>

@interface LevelPlayUtils : NSObject

+ (NSDictionary *)dictionaryForNativeAd:(LevelPlayNativeAd *)nativeAd;
+ (NSDictionary *)dictionaryForAdInfo:(ISAdInfo *)adInfo;
+ (NSDictionary *)dictionaryForError:(NSError *)error;
+ (NSData *)dataFromImage:(UIImage *)image;
+ (ISAdUnit *)getAdUnit:(NSString *)adUnitString;

@end
