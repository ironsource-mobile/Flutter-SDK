import '../ironsource_error.dart';
import '../ironsource_ad_info.dart';

abstract class LevelPlayInterstitialListener {
  /// Indicates that the interstitial ad was loaded successfully.
  /// - [adInfo] includes information about the loaded ad.
  ///
  /// Native SDK Reference
  /// - Android: onAdReady
  /// -     iOS: didLoadWithAdInfo
  void onAdReady(IronSourceAdInfo adInfo);

  /// Indicates that the ad failed to be loaded
  ///
  /// Native SDK Reference
  /// - Android: onAdLoadFailed
  /// -     iOS: didFailToLoadWithError
  void onAdLoadFailed(IronSourceError error);

  /// Invoked when the Interstitial Ad Unit has opened, and user left the application screen.
  /// - This is the impression indication.
  ///
  /// Native SDK Reference
  /// - Android: onAdOpened
  /// -     iOS: didOpenWithAdInfo
  void onAdOpened(IronSourceAdInfo adInfo);

  /// Invoked when the interstitial ad closed and the user went back to the application screen.
  ///
  /// Native SDK Reference
  /// - Android: onAdClosed
  /// -     iOS: didCloseWithAdInfo
  void onAdClosed(IronSourceAdInfo adInfo);

  /// The interstitial ad failed to show.
  ///
  /// Native SDK Reference
  /// - Android: onAdShowFailed
  /// -     iOS: didFailToShowWithError
  void onAdShowFailed(IronSourceError error, IronSourceAdInfo adInfo);

  /// Invoked when end user clicked on the interstitial ad
  ///
  /// Native SDK Reference
  /// - Android: onAdClicked
  /// -     iOS: didClickWithAdInfo
  void onAdClicked(IronSourceAdInfo adInfo);

    /// Invoked before the interstitial ad was opened, and before the InterstitialOnAdOpenedEvent is reported.
  /// This callback is not supported by all networks, and we recommend using it only if
  /// it's supported by all networks you included in your build.
  /// 
  /// Native SDK Reference
  /// - Android: onAdShowSucceeded
  /// -     iOS: didShowWithAdInfo
  void onAdShowSucceeded(IronSourceAdInfo adInfo);
}
