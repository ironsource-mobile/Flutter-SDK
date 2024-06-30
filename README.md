# ironSource Flutter Plugin

A bridge plugin for ironSource SDKs.

- [ironSource Knowledge Center](https://developers.is.com/developer-docs/flutter/)
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
    implementation 'com.google.android.gms:play-services-appset:16.0.2'
    implementation 'com.google.android.gms:play-services-ads-identifier:18.0.1'
    implementation 'com.google.android.gms:play-services-basement:18.3.0'
}
```

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

#### LevelPlayRewardedVideoListener
```dart
class LevelPlayRewardedVideoListenerClass with LevelPlayRewardedVideoListener {
  @override
  void onAdAvailable(IronSourceAdInfo? adInfo) {
    // TODO: implement onAdAvailable
  }

  @override
  void onAdClicked(IronSourceRewardedVideoPlacement? placement, IronSourceAdInfo? adInfo) {
    // TODO: implement onAdClicked
  }

  @override
  void onAdClosed(IronSourceAdInfo? adInfo) {
    // TODO: implement onAdClosed
  }

  @override
  void onAdOpened(IronSourceAdInfo? adInfo) {
    // TODO: implement onAdOpened
  }

  @override
  void onAdRewarded(IronSourceRewardedVideoPlacement? placement, IronSourceAdInfo? adInfo) {
    // TODO: implement onAdRewarded
  }

  @override
  void onAdShowFailed(IronSourceError? error, IronSourceAdInfo? adInfo) {
    // TODO: implement onAdShowFailed
  }

  @override
  void onAdUnavailable() {
    // TODO: implement onAdUnavailable
  }
}
```

#### LevelPlayInterstitialListener
```dart
class LevelPlayInterstitialListenerClass with LevelPlayInterstitialListener {
  @override
  void onAdClicked(IronSourceAdInfo? adInfo) {
    // TODO: implement onAdClicked
  }

  @override
  void onAdClosed(IronSourceAdInfo? adInfo) {
    // TODO: implement onAdClosed
  }

  @override
  void onAdLoadFailed(IronSourceError? error) {
    // TODO: implement onAdLoadFailed
  }

  @override
  void onAdOpened(IronSourceAdInfo? adInfo) {
    // TODO: implement onAdOpened
  }

  @override
  void onAdReady(IronSourceAdInfo? adInfo) {
    // TODO: implement onAdReady
  }

  @override
  void onAdShowFailed(IronSourceError? error, IronSourceAdInfo? adInfo) {
    // TODO: implement onAdShowFailed
  }

  @override
  void onAdShowSucceeded(IronSourceAdInfo? adInfo) {
    // TODO: implement onAdShowSucceeded
  }
}
```

#### LevelPlayBannerListener
```dart
class LevelPlayBannerListenerClass with LevelPlayBannerListener {

  @override
  void onAdClicked(IronSourceAdInfo? adInfo) {
    // TODO: implement onAdClicked
  }

  @override
  void onAdLeftApplication(IronSourceAdInfo? adInfo) {
    // TODO: implement onAdLeftApplication
  }

  @override
  void onAdLoadFailed(IronSourceError? error) {
    // TODO: implement onAdLoadFailed
  }

  @override
  void onAdLoaded(IronSourceAdInfo? adInfo) {
    // TODO: implement onAdLoaded
  }

  @override
  void onAdScreenDismissed(IronSourceAdInfo? adInfo) {
    // TODO: implement onAdScreenDismissed
  }

  @override
  void onAdScreenPresented(IronSourceAdInfo? adInfo) {
    // TODO: implement onAdScreenPresented
  }
}
```

#### LevelPlayNativeAdListener
```dart
class LevelPlayNativeAdListenerClass with LevelPlayNativeAdListener {
  @override
  void onAdClicked(LevelPlayNativeAd? nativeAd, IronSourceAdInfo? adInfo) {
    // TODO: implement onAdClicked
  }

  @override
  void onAdImpression(LevelPlayNativeAd? nativeAd, IronSourceAdInfo? adInfo) {
    // TODO: implement onAdImpression
  }

  @override
  void onAdLoadFailed(LevelPlayNativeAd? nativeAd, IronSourceError? error) {
    // TODO: implement onAdLoadFailed
  }

  @override
  void onAdLoaded(LevelPlayNativeAd? nativeAd, IronSourceAdInfo? adInfo) {
    // TODO: implement onAdLoaded
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
    IronSource.setFlutterVersion('YOUR_FLUTTER_VERSION'); // must be called before init
    IronSource.validateIntegration();
    // Set listeners
    IronSource.setLevelPlayRewardedVideoListener(LevelPlayRewardedVideoListenerClass());
    IronSource.setLevelPlayInterstitialListener(LevelPlayInterstitialListenerClass());
    IronSource.setLevelPlayBannerListener(LevelPlayBannerListenerClass());
    
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

### Show Ads Example

#### LevelPlayRewardedVideo
```dart
Future<void> _showRewardedVideoOnClick() async {
  if (await IronSource.isRewardedVideoAvailable()) {
    IronSource.showRewardedVideo();
  }
}
```

#### LevelPlayInterstitial
```dart
void _loadInterstitialOnClick() {
  IronSource.loadInterstitial();
}

Future<void> _showInterstitialOnClick() async {
  if (await IronSource.isInterstitialReady()) {
    IronSource.showInterstitial();
  }
}
```

#### LevelPlayBanner
```dart
Future<void> _loadBanner() async { // load will automatically show the ad
  await IronSource.loadBanner(
      size: size,
      position: IronSourceBannerPosition.Bottom,
      verticalOffset: -50,
      placementName: 'YOUR_PLACEMENT');
}
```

#### LevelPlayNativeAd
```dart
class _LevelPlayNativeAdsSection extends State<LevelPlayNativeAdsSection> with LevelPlayNativeAdListener {
  LevelPlayNativeAd? _nativeAd;
  LevelPlayNativeAdView? _nativeAdView;

  @override
  void initState() {
    super.initState();
    _createNativeAd();
    _createNativeAdView();
  }

  /// Initialize native ad object
  void _createNativeAd() {
    _nativeAd = LevelPlayNativeAd.builder()
        .withPlacementName('YOUR_PLACEMENT_NAME') // Your placement name string
        .withListener(LevelPlayNativeAdListenerClass()) // Your level play native ad listener
        .build();
  }

  /// Initialize native ad view widget with native ad
  void _createNativeAdView() {
    _nativeAdView = LevelPlayNativeAdView(
      key: GlobalKey(), // Unique key to force recreation of widget
      height: 150, // Your chosen height
      width: double.infinity, // Your chosen width
      nativeAd: _nativeAd, // Native ad object
      templateType: LevelPlayTemplateType.SMALL, // Built-in native ad template(not required when implementing custom template)
      templateStyle: LevelPlayNativeAdTemplateStyle( // Level play native ad styling(optional)
          callToActionStyle: LevelPlayNativeAdElementStyle(
              backgroundColor: Colors.white,
              textColor: Colors.lightBlue
          )
      ),
    );
  }

  /// Load native ad
  void _loadAd() {
    _nativeAd?.loadAd();
  }
  
  // Rest of the class
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

## Version History
You can find a summary of the ironSouce SDK version history [here](https://developers.is.com/ironsource-mobile/flutter/sdk-change-log/)

## Contact US
For any question please contact us [here](https://ironsrc.formtitan.com/knowledge-center#/)

## License
The license can be viewed [here](https://github.com/ironsource-mobile/Flutter-SDK/blob/master/LICENSE)