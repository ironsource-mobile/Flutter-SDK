import 'ironsource_error.dart';
import 'ironsource_rv_placement.dart';
import 'ironsource_ow_credit_info.dart';
import 'ironsource_impression_data.dart';

/** Init Listener ================================================================================*/

abstract class IronSourceInitializationListener {
  /// Invoked when the SDK completes the init process for the first time.
  /// - This callback is called only once per session after the first init.
  ///
  /// Native SDK Reference
  /// - Android: onInitializationComplete
  /// -     iOS: initializationDidComplete
  void onInitializationComplete();
}

/** Ad Units =====================================================================================*/

abstract class IronSourceRewardedVideoListener {
  /// Invoked when the RewardedVideo ad view has opened.
  ///
  /// Native SDK Reference
  /// - Android: onRewardedVideoAdOpened
  /// -     iOS: rewardedVideoDidOpen
  void onRewardedVideoAdOpened();

  /// Invoked when the RewardedVideo ad view is about to be closed.
  ///
  /// Native SDK Reference
  /// - Android: onRewardedVideoAdClosed
  /// -     iOS: rewardedVideoDidClose
  void onRewardedVideoAdClosed();

  /// Invoked when there is a change in the ad availability status.
  /// - [isAvailable] reflects the availability of Rewarded Video.
  /// - You can show the video by calling [showRewardedVideo] when [isAvailable] is true.
  /// - [isAvailable] would be false when no videos are available.
  ///
  /// Native SDK Reference
  /// - Android: onRewardedVideoAvailabilityChanged
  /// -     iOS: rewardedVideoHasChangedAvailability
  void onRewardedVideoAvailabilityChanged(bool isAvailable);

  /// Invoked when the user completed the video and should be rewarded.
  /// - [placement] contains the reward data.
  /// - If you are using server-to-server reward callbacks,
  /// - you may ignore this event and wait for a callback from the ironSource server.
  ///
  /// Native SDK Reference
  /// - Android: onRewardedVideoAdRewarded
  /// -     iOS: didReceiveRewardForPlacement
  void onRewardedVideoAdRewarded(IronSourceRVPlacement placement);

  /// Invoked when Rewarded Video failed to show.
  /// - You can learn about the reason by examining [error].
  ///
  /// Native SDK Reference
  /// - Android: onRewardedVideoAdShowFailed
  /// -     iOS: rewardedVideoDidFailToShowWithError
  void onRewardedVideoAdShowFailed(IronSourceError error);

  /// Invoked when the video ad is clicked.
  /// - The reward data of the clicked ad is passed as [placement].
  /// - __Note__: This event is not supported by all the networks.
  ///
  /// Native SDK Reference
  /// - Android: onRewardedVideoAdClicked
  /// -     iOS: didClickRewardedVideo
  void onRewardedVideoAdClicked(IronSourceRVPlacement placement);

  /// Invoked when the video ad starts playing.
  /// - __Note__: This event is not supported by all the networks.
  ///
  /// Native SDK Reference
  /// - Android: onRewardedVideoAdStarted
  /// -     iOS: rewardedVideoDidStart
  void onRewardedVideoAdStarted();

  /// Invoked when the video ad finishes playing.
  /// - __Note__: This event is not supported by all the networks.
  ///
  /// Native SDK Reference
  /// - Android: onRewardedVideoAdEnded
  /// -     iOS: rewardedVideoDidEnd
  void onRewardedVideoAdEnded();
}

abstract class IronSourceRewardedVideoManualListener implements IronSourceRewardedVideoListener {
  /// Invoked when the ad is ready and can be displayed on the device
  ///
  /// Native SDK Reference
  /// - Android: onRewardedVideoAdReady
  /// -     iOS: rewardedVideoDidLoad
  void onRewardedVideoAdReady();

  /// Invoked when no ad was loaded.
  /// - [error] contains the reason for the failure.
  ///
  /// Native SDK Reference
  /// - Android: onRewardedVideoAdLoadFailed
  /// -     iOS: rewardedVideoDidFailToLoadWithError
  void onRewardedVideoAdLoadFailed(IronSourceError error);
}

abstract class IronSourceInterstitialListener {
  /// Invoked when an Interstitial ad became ready to be shown
  /// as a result of the precedent [loadInterstitial] call.
  ///
  /// Native SDK Reference
  /// - Android: onInterstitialAdReady
  /// -     iOS: interstitialDidLoad
  void onInterstitialAdReady();

  /// Invoked when there is no Interstitial ad available
  /// as a result of the precedent [loadInterstitial] call.
  /// - You can learn about the reason by examining [error].
  ///
  /// Native SDK Reference
  /// - Android: onInterstitialAdLoadFailed
  /// -     iOS: interstitialDidFailToLoadWithError
  void onInterstitialAdLoadFailed(IronSourceError error);

  /// Invoked when an Interstitial ad has opened.
  ///
  /// Native SDK Reference
  /// - Android: onInterstitialAdOpened
  /// -     iOS: interstitialDidOpen
  void onInterstitialAdOpened();

  /// Invoked when the ad is closed and the user is about to return to the application.
  ///
  /// Native SDK Reference
  /// - Android: onInterstitialAdClosed
  /// -     iOS: interstitialDidClose
  void onInterstitialAdClosed();

  /// Invoked when an Interstitial screen is about to open.
  /// - __Note__: This event is not supported by all the networks.
  /// - You should NOT treat this event as an interstitial impression,
  /// but rather use [onInterstitialAdOpened].
  ///
  /// Native SDK Reference
  /// - Android: onInterstitialAdShowSucceeded
  /// -     iOS: interstitialDidShow
  void onInterstitialAdShowSucceeded();

  /// Invoked when an Interstitial ad failed to show.
  /// - You can learn about the reason by examining [error]
  ///
  /// Native SDK Reference
  /// - Android: onInterstitialAdShowFailed
  /// -     iOS: interstitialDidFailToShowWithError
  void onInterstitialAdShowFailed(IronSourceError error);

  /// Invoked when the end user clicked on the interstitial ad.
  /// - __Note__: This event is not supported by all the networks.
  ///
  /// Native SDK Reference
  /// - Android: onInterstitialAdClicked
  /// -     iOS: didClickInterstitial
  void onInterstitialAdClicked();
}

abstract class IronSourceBannerListener {
  /// Invoked once the banner has successfully loaded.
  /// 
  /// Native SDK Reference
  /// - Android: onBannerAdLoaded
  /// -     iOS: bannerDidLoad
  void onBannerAdLoaded();

  /// Invoked when the banner loading process has failed.
  /// - You can learn about the reason by examining [error]
  /// 
  /// Native SDK Reference
  /// - Android: onBannerAdLoadFailed
  /// -     iOS: bannerDidFailToLoadWithError
  void onBannerAdLoadFailed(IronSourceError error);

  /// Invoked when a user clicks on the banner ad.
  ///
  /// Native SDK Reference
  /// - Android: onBannerAdClicked
  /// -     iOS: didClickBanner
  void onBannerAdClicked();

  /// Notifies the presentation of a full screen content following a user-click.
  /// 
  /// Native SDK Reference
  /// - Android: onBannerAdScreenPresented
  /// -     iOS: bannerWillPresentScreen
  void onBannerAdScreenPresented();

  /// Invoked when the presented screen has been dismissed.
  /// 
  /// Native SDK Reference
  /// - Android: onBannerAdScreenDismissed
  /// -     iOS: bannerDidDismissScreen
  void onBannerAdScreenDismissed();

  /// Invoked when a user is leaving the app.
  ///
  /// Native SDK Reference
  /// - Android: onBannerAdLeftApplication
  /// -     iOS: bannerWillLeaveApplication
  void onBannerAdLeftApplication();
}

abstract class IronSourceOfferwallListener {
  /// Invoked when there is a change in the Offerwall availability status.
  /// - [isAvailable] reflects the availability of Offerwall.
  /// - You can show the Offerwall by calling [showOfferwall] when [isAvailable] is true.
  /// - [isAvailable] would be false when Offerwall is not available.
  ///
  /// Native SDK Reference
  /// - Android: onOfferwallAvailabilityChanged
  /// -     iOS: offerwallHasChangedAvailability
  void onOfferwallAvailabilityChanged(bool isAvailable);

  /// Invoked when the Offerwall successfully loads for the user,
  /// after calling the [showOfferwall] function.
  ///
  /// Native SDK Reference
  /// - Android: onOfferwallOpened
  /// -     iOS: offerwallDidShow
  void onOfferwallOpened();

  /// Invoked when [showOfferWall] was called and the OfferWall failed to load.
  /// - [error] represents the reason for the [showOfferwall] failure.
  ///
  /// Native SDK Reference
  /// - Android: onOfferwallShowFailed
  /// -     iOS: offerwallDidFailToShowWithError
  void onOfferwallShowFailed(IronSourceError error);

  /// Invoked each time the user completes an offer or as a result of [getOfferwallCredits].
  /// - Award the user with the credit amount based on the [creditInfo].
  ///
  /// [creditInfo] is an instance of [IronSourceOWCreditInfo] with following fields:
  /// - [credits] represents the number of credits the user has earned.
  /// - [totalCredits] is the total number of credits ever earned by the user.
  /// - [totalCreditsFlag] becomes true in cases where we are not able to provide the exact amount
  ///  of credits since the last event (specifically after the user clears the app data).
  ///  In such case, [credits] will be equal to [totalCredits].
  ///
  /// Native SDK Reference
  /// - Android: onOfferwallAdCredited
  /// -     iOS: didReceiveOfferwallCredits
  void onOfferwallAdCredited(IronSourceOWCreditInfo creditInfo);

  /// Invoked when [getOfferWallCredits] fails to retrieve the user's credit balance info.
  /// - [error] represents the reason of [getOfferwallCredits] failure.
  ///
  /// Native SDK Reference
  /// - Android: onGetOfferwallCreditsFailed
  /// -     iOS: didFailToReceiveOfferwallCreditsWithError
  void onGetOfferwallCreditsFailed(IronSourceError error);

  /// Invoked when the user is about to return to the application after closing the Offerwall.
  /// 
  /// Native SDK Reference
  /// - Android: onOfferwallClosed
  /// -     iOS: offerwallDidClose
  void onOfferwallClosed();
}

/** ILR Data =====================================================================================*/

abstract class IronSourceImpressionDataListener {
  /// Native SDK Reference
  /// - Android: onImpressionSuccess
  /// -     iOS: impressionDataDidSucceed
  void onImpressionSuccess(IronSourceImpressionData? impressionData);
}

/** iOS ConsentView ==============================================================================*/

abstract class IronSourceConsentViewListener {
  /// Reference
  /// - iOS: consentViewDidLoadSuccess
  void consentViewDidLoadSuccess(String consentViewType);

  /// Reference
  /// - iOS: consentViewDidFailToLoadWithError
  void consentViewDidFailToLoad(IronSourceConsentViewError error);

  /// Reference
  /// - iOS: consentViewDidShowSuccess
  void consentViewDidShowSuccess(String consentViewType);

  /// Reference
  /// - iOS: consentViewDidFailToShowWithError
  void consentViewDidFailToShow(IronSourceConsentViewError error);

  /// Reference
  /// - iOS: consentViewDidAccept
  void consentViewDidAccept(String consentViewType);
}
