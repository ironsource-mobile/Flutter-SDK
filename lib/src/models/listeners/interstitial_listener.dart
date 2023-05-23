import '../ironsource_error.dart';

/// Interstitial
@Deprecated(
    "This class has been deprecated as of SDK 7.3.0. Please use LevelPlayInterstitialListener instead.")
abstract class IronSourceInterstitialListener {
  /// Invoked when an Interstitial ad became ready to be shown
  /// as a result of the precedent [loadInterstitial] call.
  ///
  /// Native SDK Reference
  /// - Android: onInterstitialAdReady
  /// -     iOS: interstitialDidLoad
  @Deprecated(
      "This API has been deprecated as of SDK 7.3.0. Please use the alternate API in LevelPlayInterstitialListener listener instead.")
  void onInterstitialAdReady();

  /// Invoked when there is no Interstitial ad available
  /// as a result of the precedent [loadInterstitial] call.
  /// - You can learn about the reason by examining [error].
  ///
  /// Native SDK Reference
  /// - Android: onInterstitialAdLoadFailed
  /// -     iOS: interstitialDidFailToLoadWithError
  @Deprecated(
      "This API has been deprecated as of SDK 7.3.0. Please use the alternate API in LevelPlayInterstitialListener listener instead.")
  void onInterstitialAdLoadFailed(IronSourceError error);

  /// Invoked when an Interstitial ad has opened.
  ///
  /// Native SDK Reference
  /// - Android: onInterstitialAdOpened
  /// -     iOS: interstitialDidOpen
  @Deprecated(
      "This API has been deprecated as of SDK 7.3.0. Please use the alternate API in LevelPlayInterstitialListener listener instead.")
  void onInterstitialAdOpened();

  /// Invoked when the ad is closed and the user is about to return to the application.
  ///
  /// Native SDK Reference
  /// - Android: onInterstitialAdClosed
  /// -     iOS: interstitialDidClose
  @Deprecated(
      "This API has been deprecated as of SDK 7.3.0. Please use the alternate API in LevelPlayInterstitialListener listener instead.")
  void onInterstitialAdClosed();

  /// Invoked when an Interstitial screen is about to open.
  /// - __Note__: This event is not supported by all the networks.
  /// - You should NOT treat this event as an interstitial impression,
  /// but rather use [onInterstitialAdOpened].
  ///
  /// Native SDK Reference
  /// - Android: onInterstitialAdShowSucceeded
  /// -     iOS: interstitialDidShow
  @Deprecated(
      "This API has been deprecated as of SDK 7.3.0. Please use the alternate API in LevelPlayInterstitialListener listener instead.")
  void onInterstitialAdShowSucceeded();

  /// Invoked when an Interstitial ad failed to show.
  /// - You can learn about the reason by examining [error]
  ///
  /// Native SDK Reference
  /// - Android: onInterstitialAdShowFailed
  /// -     iOS: interstitialDidFailToShowWithError
  @Deprecated(
      "This API has been deprecated as of SDK 7.3.0. Please use the alternate API in LevelPlayInterstitialListener listener instead.")
  void onInterstitialAdShowFailed(IronSourceError error);

  /// Invoked when the end user clicked on the interstitial ad.
  /// - __Note__: This event is not supported by all the networks.
  ///
  /// Native SDK Reference
  /// - Android: onInterstitialAdClicked
  /// -     iOS: didClickInterstitial
  @Deprecated(
      "This API has been deprecated as of SDK 7.3.0. Please use the alternate API in LevelPlayInterstitialListener listener instead.")
  void onInterstitialAdClicked();
}
