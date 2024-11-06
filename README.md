# ironSource Flutter Plugin

A bridge plugin for ironSource SDKs.

- [ironSource Knowledge Center](https://developers.is.com/)
- [Android SDK](https://developers.ironsrc.com/ironsource-mobile/android/android-sdk/)
- [iOS SDK](https://developers.ironsrc.com/ironsource-mobile/ios/ios-sdk/)
- [Flutter Plugin](https://developers.is.com/ironsource-mobile/flutter/flutter-plugin/)

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
    // Indicates that there's an available ad. 
  }

  @override
  void onAdUnavailable() {
    // Indicates that no ads are available to be displayed 
  }

  @override
  void onAdOpened(IronSourceAdInfo? adInfo) {
    // The Rewarded Video ad view has opened. Your activity will loose focus
  }
  
  @override
  void onAdClosed(IronSourceAdInfo? adInfo) {
    // The Rewarded Video ad view is about to be closed. Your activity will regain its focus
  }


  @override
  void onAdRewarded(IronSourceRewardedVideoPlacement? placement, IronSourceAdInfo? adInfo) {
    // The user completed to watch the video, and should be rewarded. 
    // The placement parameter will include the reward data.
    // When using server-to-server callbacks, you may ignore this event and wait for the ironSource server callback
  }

  @override
  void onAdShowFailed(IronSourceError? error, IronSourceAdInfo? adInfo) {
    // The rewarded video ad was failed to show
  }

  @override
  void onAdClicked(IronSourceRewardedVideoPlacement? placement, IronSourceAdInfo? adInfo) {
    // Invoked when the video ad was clicked. 
    // This callback is not supported by all networks, and we recommend using it 
    // only if it's supported by all networks you included in your build
  }
}
```

#### LevelPlayInterstitialAdListener
```dart
class LevelPlayInterstitialAdListenerClass with LevelPlayInterstitialAdListener {
  @override
  void onAdLoaded(LevelPlayAdInfo adInfo) {
    // Provided when the ad is successfully loaded
  }

  @override
  void onAdLoadFailed(LevelPlayAdError error) {
    // Provided when the ad fails to load. Ad Unit information is included
  }

  @override
  void onAdDisplayed(LevelPlayAdInfo adInfo) {
    // Provided when the ad is displayed. This is equivalent to an impression
  }

  @override
  void onAdDisplayFailed(LevelPlayAdError error, LevelPlayAdInfo adInfo) {
    // Provided when the ad fails to be displayed
  }
  
  @override
  void onAdClicked(LevelPlayAdInfo adInfo) {
    // Provided when the user clicks on the ad
  }

  @override
  void onAdClosed(LevelPlayAdInfo adInfo) {
    // Provided when the ad is closed
  }

  @override
  void onAdInfoChanged(LevelPlayAdInfo adInfo) {
    // Provided when the ad info is updated. Available when another ad has loaded, and includes a higher CPM/Rate
  }
}
```

#### LevelPlayBannerAdViewListener
```dart
class LevelPlayBannerAdViewListenerClass with LevelPlayBannerAdViewListener {
  @override
  void onAdLoaded(LevelPlayAdInfo adInfo) {
    // Ad was loaded successfully 
  }

  @override
  void onAdLoadFailed(LevelPlayAdError error) {
    // Ad load failed
  }

  @override
  void onAdDisplayed(LevelPlayAdInfo adInfo) {
    // Ad was displayed and visible on screen
  }

  @override
  void onAdDisplayFailed(LevelPlayAdInfo adInfo, LevelPlayAdError error) {
    // Ad failed to be displayed on screen
  }
  
  @override
  void onAdClicked(LevelPlayAdInfo adInfo) {
    // Ad was clicked
  }

  @override
  void onAdExpanded(LevelPlayAdInfo adInfo) {
    // Ad is opened on full screen
  }

  @override
  void onAdCollapsed(LevelPlayAdInfo adInfo) {
    // Ad is restored to its original size
  }

  @override
  void onAdLeftApplication(LevelPlayAdInfo adInfo) {
    // User pressed on the ad and was navigated out of the app 
  }
}
```

#### LevelPlayNativeAdListener
```dart
class LevelPlayNativeAdListenerClass with LevelPlayNativeAdListener {
  @override
  void onAdLoaded(LevelPlayNativeAd? nativeAd, IronSourceAdInfo? adInfo) {
    // Invoked each time a native ad was loaded.
  }

  @override
  void onAdLoadFailed(LevelPlayNativeAd? nativeAd, IronSourceError? error) {
    // Invoked when the native ad loading process has failed.
  }

  @override
  void onAdImpression(LevelPlayNativeAd? nativeAd, IronSourceAdInfo? adInfo) {
    // Invoked each time the first pixel is visible on the screen
  }
  
  @override
  void onAdClicked(LevelPlayNativeAd? nativeAd, IronSourceAdInfo? adInfo) {
    // Invoked when end user clicked on the native ad
  }
}
```

### Initialize the plugin 

```dart
Future<void> init() async {
  final appKey = '[YOUR_APP_KEY]';
  try {
    List<AdFormat> legacyAdFormats = [AdFormat.BANNER, AdFormat.REWARDED, AdFormat.INTERSTITIAL, AdFormat.NATIVE_AD];
    final initRequest = LevelPlayInitRequest(appKey: appKey, legacyAdFormats: legacyAdFormats);
    await LevelPlay.init(initRequest: initRequest, initListener: this);
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
LevelPlayInterstitialAd? _interstitialAd;

@override
void initState() {
  super.initState();
  _createInterstitialAd();
}

void _createInterstitialAd() {
  _intersitialAd = LevelPlayInterstitialAd(adUnitId: [YOUR_AD_UNIT]);
  _interstitialAd!.setListener([YOUR_LISTENER]);
}

void _loadInterstitial() {
  _interstitialAd?.loadAd();
}

Future<void> _showInterstitial() async {
  if (await __interstitialAd?.isAdReady()) {
    _interstitialAd?.showAd(placement: [YOUR_PLACEMENT]);
  }
}
```

#### LevelPlayBanner

```dart
LevelPlayBannerAdView? _bannerAdView;

@override
void initState() {
  super.initState();
  _createBannerAdView();
}

void _createBannerAdView() {
  final _bannerkey = GlobalKey<LevelPlayBannerAdViewState>();
  _bannerAdView = LevelPlayBannerAdView(
      key: _bannerKey,
      adUnitId: [YOUR_AD_UNIT_ID],
      adSize:[YOUR_AD_SIZE],
      listener: [YOUR_LISTENER],
      placementName: [YOUR_PLACEMENT],
      onPlatformViewCreated: _loadBanner
  );
}

void _loadBanner() {
  _bannerAdView?.loadAd();
  // or store and use key - _bannerKey.currentState?.loadAd();
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
      key: GlobalKey(),
      // Unique key to force recreation of widget
      height: 150,
      // Your chosen height
      width: double.infinity,
      // Your chosen width
      nativeAd: _nativeAd,
      // Native ad object
      templateType: LevelPlayTemplateType.SMALL,
      // Built-in native ad template(not required when implementing custom template)
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
}
```

Refer to the [example app](./example) for the more detailed implementation sample.

Note:

- Make sure to read the official documents at [ironSource Knowledge Center](TODO: replace with the real KC link) for proper usage.
- Some configurations must be done before initialization.
- LevelPlayBannerListener is deprecated - Please use LevelPlayBannerAdViewListener with LevelPlayBannerAdView instead.


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
