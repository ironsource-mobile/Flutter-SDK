import '../ironsource_error.dart';
import '../ironsource_ad_info.dart';

abstract class LevelPlayBannerListener {
  /// Invoked each time a banner was loaded. Either on refresh, or manual load.\
  /// - [adInfo] includes information about the loaded ad
  ///
  /// Native SDK Reference
  /// - Android: onAdLoaded
  /// -     iOS: didLoad
  void onAdLoaded(IronSourceAdInfo adInfo);

  /// Invoked when the banner loading process has failed.\
  /// This callback will be sent both for manual load and refreshed banner failures.
  ///
  /// Native SDK Reference
  /// - Android: onAdLoadFailed
  /// -     iOS: didFailToLoadWithError
  void onAdLoadFailed(IronSourceError error);

  /// Invoked when end user clicks on the banner ad.
  ///
  /// Native SDK Reference
  /// - Android: onAdClicked
  /// -     iOS: didClickWithAdInfo
  void onAdClicked(IronSourceAdInfo adInfo);

  /// Notifies the presentation of a full screen content following user click.
  ///
  /// Native SDK Reference
  /// - Android: onAdScreenPresented
  /// -     iOS: didPresentScreenWithAdInfo
  void onAdScreenPresented(IronSourceAdInfo adInfo);

  /// Notifies the presented screen has been dismissed.
  ///
  /// Native SDK Reference
  /// - Android: onAdScreenDismissed
  /// -     iOS: didDismissScreenWithAdInfo
  void onAdScreenDismissed(IronSourceAdInfo adInfo);

  /// Invoked when the user left the app.
  ///
  /// Native SDK Reference
  /// - Android: onAdLeftApplication
  /// -     iOS: didLeaveApplicationWithAdInfo
  void onAdLeftApplication(IronSourceAdInfo adInfo);
}
