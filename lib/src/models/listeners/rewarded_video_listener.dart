import '../ironsource_error.dart';
import '../ironsource_rewardedvideo_placement.dart';
import '../ironsource_rv_placement.dart';

/// Rewarded Video
@Deprecated(
    "This class has been deprecated as of SDK 7.3.0. Please use LevelPlayRewardedVideoListener instead.")
abstract class IronSourceRewardedVideoListener {
  /// Invoked when the RewardedVideo ad view has opened.
  ///
  /// Native SDK Reference
  /// - Android: onRewardedVideoAdOpened
  /// -     iOS: rewardedVideoDidOpen
  @Deprecated(
      "This API has been deprecated as of SDK 7.3.0. Please use the alternate API in LevelPlayRewardedVideoDelegate listener instead.")
  void onRewardedVideoAdOpened();

  /// Invoked when the RewardedVideo ad view is about to be closed.
  ///
  /// Native SDK Reference
  /// - Android: onRewardedVideoAdClosed
  /// -     iOS: rewardedVideoDidClose
  @Deprecated(
      "This API has been deprecated as of SDK 7.3.0. Please use the alternate API in LevelPlayRewardedVideoDelegate listener instead.")
  void onRewardedVideoAdClosed();

  /// Invoked when there is a change in the ad availability status.
  /// - [isAvailable] reflects the availability of Rewarded Video.
  /// - You can show the video by calling [showRewardedVideo] when [isAvailable] is true.
  /// - [isAvailable] would be false when no videos are available.
  ///
  /// Native SDK Reference
  /// - Android: onRewardedVideoAvailabilityChanged
  /// -     iOS: rewardedVideoHasChangedAvailability
  @Deprecated(
      "This API has been deprecated as of SDK 7.3.0. Please use the alternate API in LevelPlayRewardedVideoDelegate listener instead.")
  void onRewardedVideoAvailabilityChanged(bool isAvailable);

  /// Invoked when the user completed the video and should be rewarded.
  /// - [placement] contains the reward data.
  /// - If you are using server-to-server reward callbacks,
  /// - you may ignore this event and wait for a callback from the ironSource server.
  ///
  /// Native SDK Reference
  /// - Android: onRewardedVideoAdRewarded
  /// -     iOS: didReceiveRewardForPlacement
  @Deprecated(
      "This API has been deprecated as of SDK 7.3.0. Please use the alternate API in LevelPlayRewardedVideoDelegate listener instead.")
  void onRewardedVideoAdRewarded(IronSourceRewardedVideoPlacement placement);

  /// Invoked when Rewarded Video failed to show.
  /// - You can learn about the reason by examining [error].
  ///
  /// Native SDK Reference
  /// - Android: onRewardedVideoAdShowFailed
  /// -     iOS: rewardedVideoDidFailToShowWithError
  @Deprecated(
      "This API has been deprecated as of SDK 7.3.0. Please use the alternate API in LevelPlayRewardedVideoDelegate listener instead.")
  void onRewardedVideoAdShowFailed(IronSourceError error);

  /// Invoked when the video ad is clicked.
  /// - The reward data of the clicked ad is passed as [placement].
  /// - __Note__: This event is not supported by all the networks.
  ///
  /// Native SDK Reference
  /// - Android: onRewardedVideoAdClicked
  /// -     iOS: didClickRewardedVideo
  @Deprecated(
      "This API has been deprecated as of SDK 7.3.0. Please use the alternate API in LevelPlayRewardedVideoDelegate listener instead.")
  void onRewardedVideoAdClicked(IronSourceRewardedVideoPlacement placement);

  /// Invoked when the video ad starts playing.
  /// - __Note__: This event is not supported by all the networks.
  ///
  /// Native SDK Reference
  /// - Android: onRewardedVideoAdStarted
  /// -     iOS: rewardedVideoDidStart
  @Deprecated(
      "This API has been deprecated as of SDK 7.3.0. Please use the alternate API in LevelPlayRewardedVideoDelegate listener instead.")
  void onRewardedVideoAdStarted();

  /// Invoked when the video ad finishes playing.
  /// - __Note__: This event is not supported by all the networks.
  ///
  /// Native SDK Reference
  /// - Android: onRewardedVideoAdEnded
  /// -     iOS: rewardedVideoDidEnd
  @Deprecated(
      "This API has been deprecated as of SDK 7.3.0. Please use the alternate API in LevelPlayRewardedVideoDelegate listener instead.")
  void onRewardedVideoAdEnded();
}
