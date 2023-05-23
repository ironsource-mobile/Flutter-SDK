import '../ironsource_error.dart';

/// Banner
@Deprecated(
    "This class has been deprecated as of SDK 7.3.0. Please use LevelPlayBannerListener instead.")
abstract class IronSourceBannerListener {
  /// Invoked once the banner has successfully loaded.
  ///
  /// Native SDK Reference
  /// - Android: onBannerAdLoaded
  /// -     iOS: bannerDidLoad
  @Deprecated(
      "This API has been deprecated as of SDK 7.3.0. Please use the alternate API in LevelPlayBannerListener listener instead.")
  void onBannerAdLoaded();

  /// Invoked when the banner loading process has failed.
  /// - You can learn about the reason by examining [error]
  ///
  /// Native SDK Reference
  /// - Android: onBannerAdLoadFailed
  /// -     iOS: bannerDidFailToLoadWithError
  @Deprecated(
      "This API has been deprecated as of SDK 7.3.0. Please use the alternate API in LevelPlayBannerListener listener instead.")
  void onBannerAdLoadFailed(IronSourceError error);

  /// Invoked when a user clicks on the banner ad.
  ///
  /// Native SDK Reference
  /// - Android: onBannerAdClicked
  /// -     iOS: didClickBanner
  @Deprecated(
      "This API has been deprecated as of SDK 7.3.0. Please use the alternate API in LevelPlayBannerListener listener instead.")
  void onBannerAdClicked();

  /// Notifies the presentation of a full screen content following a user-click.
  ///
  /// Native SDK Reference
  /// - Android: onBannerAdScreenPresented
  /// -     iOS: bannerWillPresentScreen
  @Deprecated(
      "This API has been deprecated as of SDK 7.3.0. Please use the alternate API in LevelPlayBannerListener listener instead.")
  void onBannerAdScreenPresented();

  /// Invoked when the presented screen has been dismissed.
  ///
  /// Native SDK Reference
  /// - Android: onBannerAdScreenDismissed
  /// -     iOS: bannerDidDismissScreen
  @Deprecated(
      "This API has been deprecated as of SDK 7.3.0. Please use the alternate API in LevelPlayBannerListener listener instead.")
  void onBannerAdScreenDismissed();

  /// Invoked when a user is leaving the app.
  ///
  /// Native SDK Reference
  /// - Android: onBannerAdLeftApplication
  /// -     iOS: bannerWillLeaveApplication
  @Deprecated(
      "This API has been deprecated as of SDK 7.3.0. Please use the alternate API in LevelPlayBannerListener listener instead.")
  void onBannerAdLeftApplication();
}
