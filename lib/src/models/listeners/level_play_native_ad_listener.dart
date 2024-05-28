import '../ironsource_error.dart';
import '../ironsource_ad_info.dart';
import '../level_play_native_ad.dart';

/// LevelPlay Listener for Native Ad
abstract class LevelPlayNativeAdListener {
  /// Invoked when end user clicked on the native ad
  ///
  /// Native SDK Reference
  /// - Android: onAdClicked
  /// -     iOS: didClick
  void onAdClicked(LevelPlayNativeAd? nativeAd, IronSourceAdInfo? adInfo);

  /// Invoked after a native ad impression has ben recorded.
  ///
  /// Native SDK Reference
  /// - Android: onAdImpression
  /// -     iOS: didRecordImpression
  void onAdImpression(LevelPlayNativeAd? nativeAd, IronSourceAdInfo? adInfo);

  /// Indicates that the ad failed to be loaded
  ///
  /// Native SDK Reference
  /// - Android: onAdLoadFailed
  /// -     iOS: didFailToLoad
  void onAdLoadFailed(LevelPlayNativeAd? nativeAd, IronSourceError? error);

  /// Indicates that the native ad was loaded successfully.
  /// - [adInfo] includes information about the loaded ad.
  /// - [nativeAd] includes the loaded native ad object.
  ///
  /// Native SDK Reference
  /// - Android: onAdLoaded
  /// -     iOS: didLoad
  void onAdLoaded(LevelPlayNativeAd? nativeAd, IronSourceAdInfo? adInfo);
}