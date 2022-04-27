# ironSource Flutter Plugin

A bridge plugin for ironSource SDKs.

- [ironSource Knowledge Center](TODO:)
- [Android SDK](https://developers.ironsrc.com/ironsource-mobile/android/android-sdk/)
- [iOS SDK](https://developers.ironsrc.com/ironsource-mobile/ios/ios-sdk/)

# Getting Started

## Installation

```
flutter pub get ironsource_mediation
```

## Android Configuration

- The ironSource SDK dependency is included in the plugin, so you do not have to add manually to your build.gradle.

### Gradle Dependencies Required

- Play Services dependencies must be added to PROJECT_ROOT/android/app/build.gradle.

```groovy
// PROJECT_ROOT/android/app/build.gradle
dependencies {
  ...
  implementation 'com.google.android.gms:play-services-ads-identifier:18.0.0'
  implementation 'com.google.android.gms:play-services-basement:18.0.0'
  implementation 'com.google.android.gms:play-services-appset:16.0.1'
}
```

### AndroidManifest.xml

After adding the plugin to the pubspec.yml, Android build fails with the error below:

```
Attribute application@label value=(your_app_label) from AndroidManifest.xml:11:9-40
  is also present at [com.ironsource.sdk:mediationsdk:7.2.1] AndroidManifest.xml:15:9-41 value=(@string/app_name).
```

To prevent this, do the following:

- Add `xmls:tools` to AndroidManifest.xml of your project.
- Add `tools:replace="android:label"` to the `application` tag.

## iOS Configuration

- The ironSource SDK pod is included in the plugin, so you do not have to add it to your Podfile.

### <ins>SKAdNetwork Support</ins>

Add the SKAN ID of ironSource Network on info.plist

```xml
<key>SKAdNetworkItems</key>
<array>
   <dict>
      <key>SKAdNetworkIdentifier</key>
      <string>su67r6k2v3.skadnetwork</string>
   </dict>
</array>
```

### <ins>App Transport Security Settings</ins>

Set [NSAllowsArbitraryLoads](https://developer.apple.com/documentation/bundleresources/information_property_list/nsapptransportsecurity/nsallowsarbitraryloads): `true` on info.plist to allow http as some mediated networks require http calls. (Note: ironSource Network calls are all encrypted.)

Note:

- Make sure that your info.plist does not contain other ATS exceptions such as [NSAllowsArbitraryLoadsInWebContent](https://developer.apple.com/documentation/bundleresources/information_property_list/nsapptransportsecurity/nsallowsarbitraryloadsinwebcontent).

```xml
<key>NSAppTransportSecurity</key>
<dict>
  <key>NSAllowsArbitraryLoads</key>
  <true/>
</dict>
```

### <ins>App Tracking Transparency (ATT) Prompt</ins>

<b>TODO: Remove or keep this?</b>

Implement the ATT prompt to request user authorization for app-related data.

- Note: This is not part of ironSource SDK but a bridge for `AppTrackingTransparency ATTrackingManager`.
- You have to add `NSUserTrackingUsageDescription` to your info.plist if you intend to call this API.

```dart
Future<void> checkATT() async {
  final currentStatus = await ATTrackingManager.getTrackingAuthorizationStatus();
  if (currentStatus == ATTStatus.NotDetermined) {
    final returnedStatus = await ATTrackingManager.requestTrackingAuthorization();
    print('ATTStatus returned: $returnedStatus');
  }
  return;
}
```

Read more about Apple's ATT and user privacy guideline [here](https://developer.apple.com/app-store/user-privacy-and-data-use/).

## General Usage

### Implement Listeners

```dart
class YourDartClass with IronSourceRewardedVideoListener {
  /// RV listener
  @override
  void onRewardedVideoAdClicked(IronSourceRVPlacement placement) {
    print('onRewardedVideoAdClicked Placement:$placement');
  }

  @override
  void onRewardedVideoAdClosed() {
    print("onRewardedVideoAdClosed");
  }

  @override
  void onRewardedVideoAdEnded() {
    print("onRewardedVideoAdClosed");
  }

  @override
  void onRewardedVideoAdOpened() {
    print("onRewardedVideoAdOpened");
  }

  @override
  void onRewardedVideoAdRewarded(IronSourceRVPlacement placement) {
    print("onRewardedVideoAdRewarded Placement: $placement");
  }

  @override
  void onRewardedVideoAdShowFailed(IronSourceError error) {
    print("onRewardedVideoAdShowFailed Error:$error");
  }

  @override
  void onRewardedVideoAdStarted() {
    print("onRewardedVideoAdStarted");
  }

  @override
  void onRewardedVideoAvailabilityChanged(bool isAvailable) {
    print('onRewardedVideoAvailabilityChanged: $isAvailable');
    // Change the RV show button active state here
    setState((){
      _isRVAvailable = isAvailable;
    })
  }
}
```

### Initialize the plugin

```dart
Future<void> initIronSource() async {
  final appKey = Platform.isAndroid
      ? ANDROID_APP_KEY
      : Platform.isIOS
          ? IOS_APP_KEY
          : throw Exception("Unsupported Platform");
  try {
    IronSource.setFlutterVersion('2.8.1'); // must be called before init
    IronSource.validateIntegration();
    IronSource.setRVListener(this);
    await IronSource.setAdaptersDebug(true);
    await IronSource.shouldTrackNetworkState(true);

    // Do not use GAID or IDFA for this.
    await IronSource.setUserId("unique-application-user-id");
    await IronSource.init(appKey: appKey, adUnits: [IronSourceAdUnit.RewardedVideo]);
  } on PlatformException catch (e) {
    print(e);
  }
}
```

### Show Ads

```dart
Future<void> _showRVOnClick() async {
  if (await IronSource.isRewardedVideoAvailable()) {
    IronSource.showRewardedVideo();
  }
}
```

Refer to the [example app](./example) for the more detailed implementation sample.

Note:

- Make sure to read the official documents at [ironSource Knowledge Center](TODO: replace with the real KC link) for proper usage.
- Some configurations must be done before `IronSource.init`.

### Banner Positioning

For the native SDKs, a banner view must be implemented directly to the UI component.
This bridge takes care of native level view implementation. Therefore, positioning parameters are provided as below:

#### Position

```dart
enum IronSourceBannerPosition {
  Top,
  Center,
  Bottom,
}
```

#### Offset

This parameter represents the vertical offset of the banner:

- Negative values: Upward offset
- Positive values: Downward offset

Unit:

- Android: dp
- iOS: point

Note:

- Offset in the same direction of the position will be ignored. e.g. Bottom & 50, Top & -50
- However, the offsets in the opposite direction or both directions on the Center position can go beyond the screen boundaries. e.g. Bottom & -10000
- Make sure that a banner presented will be visible

```dart
IronSource.loadBanner(
  size: IronSourceBannerSize.BANNER,
  position: IronSourceBannerPosition.Bottom,
  verticalOffset: -50, // adding 50dp/50point margin bottom
  placementName: 'YOUR_PLACEMENT');
```

# Mediation

- You can use the ironSource LevelPlay's mediation feature by adding adapters/SDKs to your project.
- Some networks require additional configurations.
- Make sure to use the compatible adapter versions.

## Android

Make sure to follow [ironSource Knowledge Center](https://developers.ironsrc.com/ironsource-mobile/android/mediation-networks-android/) document for additional setup.

- Add dependencies to `YOUR_PROJECT/android/app/build.gradle`
- Add required settings to `YOUR_PROJECT/android/app/src/main/AndroidManifest.xml`

## iOS

Make sure to follow [ironSource Knowledge Center](https://developers.ironsrc.com/ironsource-mobile/ios/mediation-networks-ios/) document for additional setup.

- Add pod dependencies to `YOUR_PROJECT/ios/Podfile: target 'Runner'`
- Add required settings to `YOUR_PROJECT/ios/Runner/info.plist`

Note:

- For Podfile, [transitive dependencies error](https://github.com/flutter/flutter/issues/20045) will be thrown with `use_frameworks!`. The workaround is to add the code below to Podfile:

```ruby
use_frameworks! :linkage => :static
```
