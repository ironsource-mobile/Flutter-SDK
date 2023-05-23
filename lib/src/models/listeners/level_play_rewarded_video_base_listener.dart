import '../ironsource_rewardedvideo_placement.dart';
import '../ironsource_error.dart';
import '../ironsource_ad_info.dart';
import '../ironsource_rv_placement.dart';

abstract class LevelPlayRewardedVideoBaseListener {
  /// The Rewarded Video ad view has opened.
  ///
  /// Native SDK Reference
  /// - Android: onAdOpened
  /// -     iOS: didOpenWithAdInfo
  void onAdOpened(IronSourceAdInfo adInfo);

  /// The Rewarded Video ad view is about to be closed.
  ///
  /// Native SDK Reference
  /// - Android: onAdClosed
  /// -     iOS: didCloseWithAdInfo
  void onAdClosed(IronSourceAdInfo adInfo);

  /// The user completed to watch the video, and should be rewarded.
  /// - [placement] will include the reward data.
  /// - When using server-to-server callbacks,
  /// you may ignore this event and wait for the ironSource server callback.
  ///
  /// Native SDK Reference
  /// - Android: onAdRewarded
  /// -     iOS: didReceiveRewardForPlacement
  void onAdRewarded(
      IronSourceRewardedVideoPlacement placement, IronSourceAdInfo adInfo);

  /// The rewarded video ad failed to show.
  ///
  /// Native SDK Reference
  /// - Android: onAdShowFailed
  /// -     iOS: didFailToShowWithError
  void onAdShowFailed(IronSourceError error, IronSourceAdInfo adInfo);

  /// Invoked when the video ad was clicked.
  /// - This callback is not supported by all networks, and we recommend using it
  /// only if it's supported by all networks you included in your build.
  ///
  /// Native SDK Reference
  /// - Android: onAdClicked
  /// -     iOS: didClick
  void onAdClicked(
      IronSourceRewardedVideoPlacement placement, IronSourceAdInfo adInfo);
}
