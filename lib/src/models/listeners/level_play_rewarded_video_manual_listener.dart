import '../ironsource_ad_info.dart';
import './level_play_rewarded_video_base_listener.dart';
import '../ironsource_error.dart';

/// LevelPlay Listener for Manual Load RV
abstract class LevelPlayRewardedVideoManualListener implements LevelPlayRewardedVideoBaseListener {
  /// Indicates that the Rewarded video ad was loaded successfully.
  /// - [adInfo] includes information about the loaded ad.
  ///
  /// Native SDK Reference
  /// - Android: onAdReady
  /// -     iOS: didLoadWithAdInfo
  void onAdReady(IronSourceAdInfo adInfo);

  /// Invoked when the rewarded video failed to load.
  ///
  /// Native SDK Reference
  /// - Android: onAdLoadFailed
  /// -     iOS: didFailToLoadWithError
  void onAdLoadFailed(IronSourceError error);
}
