import '../ironsource_error.dart';
import './rewarded_video_listener.dart';

/// Manual Load RV
@Deprecated(
    "This class has been deprecated as of SDK 7.3.0. Please use LevelPlayRewardedVideoManualListener instead. ")
abstract class IronSourceRewardedVideoManualListener
    implements IronSourceRewardedVideoListener {
  /// Invoked when the ad is ready and can be displayed on the device
  ///
  /// Native SDK Reference
  /// - Android: onRewardedVideoAdReady
  /// -     iOS: rewardedVideoDidLoad
  @Deprecated(
      "This API has been deprecated as of SDK 7.3.0. Please use the alternate API in LevelPlayRewardedVideoManualListener listener instead.")
  void onRewardedVideoAdReady();

  /// Invoked when no ad was loaded.
  /// - [error] contains the reason for the failure.
  ///
  /// Native SDK Reference
  /// - Android: onRewardedVideoAdLoadFailed
  /// -     iOS: rewardedVideoDidFailToLoadWithError
  @Deprecated(
      "This API has been deprecated as of SDK 7.3.0. Please use the alternate API in LevelPlayRewardedVideoManualListener listener instead.")
  void onRewardedVideoAdLoadFailed(IronSourceError error);
}
