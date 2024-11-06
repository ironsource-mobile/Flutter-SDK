import '../level_play_ad_error.dart';
import '../level_play_ad_info.dart';

abstract class LevelPlayBannerAdViewListener {
  /// Invoked each time a banner was loaded. Either on refresh, or manual load.
  /// - [adInfo] includes information about the loaded ad
  ///
  /// Native SDK Reference
  /// - Android: onAdLoaded
  /// -     iOS: didLoad
  void onAdLoaded(LevelPlayAdInfo adInfo);

  /// Invoked when the banner loading process has failed.\
  /// This callback will be sent both for manual load and refreshed banner failures.
  ///
  /// Native SDK Reference
  /// - Android: onAdLoadFailed
  /// -     iOS: didFailToLoadWithError
  void onAdLoadFailed(LevelPlayAdError error);

  /// Notifies the screen is displayed.
  ///
  /// Native SDK Reference
  /// - Android: onAdDisplayed
  /// -     iOS: didDisplayAdWithAdInfo
  void onAdDisplayed(LevelPlayAdInfo adInfo);

  /// Notifies the screen failed to display.
  ///
  /// Native SDK Reference
  /// - Android: onAdDisplayFailed
  /// -     iOS: didFailToDisplayAdWithAdInfo
  void onAdDisplayFailed(LevelPlayAdInfo adInfo, LevelPlayAdError error);

  /// Invoked when end user clicks on the banner ad.
  ///
  /// Native SDK Reference
  /// - Android: onAdClicked
  /// -     iOS: didClickWithAdInfo
  void onAdClicked(LevelPlayAdInfo adInfo);

  /// Ad is opened on full screen
  ///
  /// Native SDK Reference
  /// - Android: onAdExpanded
  /// -     iOS: didExpandAdWithAdInfo
  void onAdExpanded(LevelPlayAdInfo adInfo);

  /// Ad is restored to its original size
  ///
  /// Native SDK Reference
  /// - Android: onAdCollapsed
  /// -     iOS: didCollapseAdWithAdInfo
  void onAdCollapsed(LevelPlayAdInfo adInfo);

  /// User pressed on the ad and was navigated out of the app
  ///
  /// Native SDK Reference
  /// - Android: onAdLeftApplication
  /// -     iOS: didLeaveAppWithAdInfo
  void onAdLeftApplication(LevelPlayAdInfo adInfo);
}
