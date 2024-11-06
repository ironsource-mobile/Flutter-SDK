import '../level_play_ad_error.dart';
import '../level_play_ad_info.dart';

abstract class LevelPlayInterstitialAdListener {
  /// Triggered when an interstitial ad is successfully loaded.
  /// - [adInfo] includes information about the loaded ad
  ///
  /// Native SDK Reference
  /// - Android: onAdLoaded
  /// -     iOS: didLoad
  void onAdLoaded(LevelPlayAdInfo adInfo);

  /// Triggered when an interstitial ad fails to load.
  ///
  /// Native SDK Reference
  /// - Android: onAdLoadFailed
  /// -     iOS: didFailToLoadAdWithAdUnitId
  void onAdLoadFailed(LevelPlayAdError error);

  /// Triggered when ad was reloaded and ad info updated.
  /// - [adInfo] includes information about the loaded ad
  ///
  /// Native SDK Reference
  /// - Android: onAdInfoChanged
  /// -     iOS: didChangeAdInfo
  void onAdInfoChanged(LevelPlayAdInfo adInfo);

  /// Triggered when an interstitial ad is displayed.
  /// - [adInfo] includes information about the loaded ad
  ///
  /// Native SDK Reference
  /// - Android: onAdDisplayed
  /// -     iOS: didDisplayAdWithAdInfo
  void onAdDisplayed(LevelPlayAdInfo adInfo);

  /// Triggered when an interstitial ad fails to show.
  /// - [adInfo] includes information about the ad
  /// - [error] includes information about the error
  ///
  /// Native SDK Reference
  /// - Android: onAdDisplayFailed
  /// -     iOS: didFailToDisplayAdWithAdInfo
  void onAdDisplayFailed(LevelPlayAdError error, LevelPlayAdInfo adInfo);

  /// Triggered when an interstitial ad is clicked.
  /// - [adInfo] includes information about the loaded ad
  ///
  /// Native SDK Reference
  /// - Android: onAdClicked
  /// -     iOS: didClickAdWithAdInfo
  void onAdClicked(LevelPlayAdInfo adInfo);

  /// Triggered when an interstitial ad is closed.
  /// - [adInfo] includes information about the loaded ad
  ///
  /// Native SDK Reference
  /// - Android: onAdClosed
  /// -     iOS: didCloseAdWithAdInfo
  void onAdClosed(LevelPlayAdInfo adInfo);
}
