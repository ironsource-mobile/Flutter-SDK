#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "NativeAdViewFactoryExample.h"
#import "IronSourceMediationPlugin.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];

  UIViewController *rootViewController = self.window.rootViewController;

  // Check if the root view controller is a FlutterViewController
  if ([rootViewController isKindOfClass:[FlutterViewController class]]) {
    // Cast the root view controller to FlutterViewController
    FlutterViewController *flutterViewController = (FlutterViewController *)rootViewController;
    NativeAdViewFactoryExample *nativeAdViewFactoryExample = [[NativeAdViewFactoryExample alloc] initWithMessenger: flutterViewController.binaryMessenger layoutName: @"MyCustomNativeAdViewTemplate"];

    // Custom native ad view template must be registered here
    [IronSourceMediationPlugin registerNativeAdViewFactory:self
                                                  viewTypeId:@"ExampleViewType"
                                         nativeAdViewFactory:nativeAdViewFactoryExample];
  }



  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

@end
