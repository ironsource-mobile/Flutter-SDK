import './level_play_rewarded_video_base_listener.dart';
import '../ironsource_ad_info.dart';

/// LevelPlay Listener for Rewarded Video
abstract class LevelPlayRewardedVideoListener implements LevelPlayRewardedVideoBaseListener {
  /// Indicates that there's an available ad.
  /// - [adInfo] includes information about the ad that was loaded successfully
  /// - Use this callback instead of [onRewardedVideoAvailabilityChanged]
  ///
  /// Native SDK Reference
  /// - Android: onAdAvailable
  /// -     iOS: hasAdAvailableWithAdInfo
  void onAdAvailable(IronSourceAdInfo adInfo);

  /// Indicates that no ads are available to be displayed.
  /// - Use this callback instead of [onRewardedVideoAvailabilityChanged]
  ///
  /// Native SDK Reference
  /// - Android: onAdUnavailable
  /// -     iOS: hasNoAvailableAd
  void onAdUnavailable(); 
}