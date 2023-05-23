import 'package:flutter/services.dart';
import './ironsource_constants.dart';
import './parsers/incoming_value_parser.dart';
import './models/models.dart';

/// Handles listener method calls from the native platform.
class IronSourceMethodCallHandler {
  /// Init listener
  static IronSourceInitializationListener? _initializationListener;
  static void setInitListener(IronSourceInitializationListener? listener) {
    _initializationListener = listener;
  }

  // RV listener
  static IronSourceRewardedVideoListener? _rewardedVideoListener;
  static void setRewardedVideoListener(
      IronSourceRewardedVideoListener? listener) {
    _rewardedVideoListener = listener;
  }

  static void setRVListener(IronSourceRewardedVideoListener? listener) {
    _rewardedVideoListener = listener;
  }

  // RewardedVideo Manual Load mode listener
  static IronSourceRewardedVideoManualListener? _rewardedVideoManualListener;
  static void setRewardedVideoManualListener(
      IronSourceRewardedVideoManualListener? listener) {
    _rewardedVideoManualListener = listener;
  }

  // Interstitial listener
  static IronSourceInterstitialListener? _interstitialListener;
  static void setInterstitialListener(
      IronSourceInterstitialListener? listener) {
    _interstitialListener = listener;
  }

  static void setISListener(IronSourceInterstitialListener? listener) {
    _interstitialListener = listener;
  }

  // Banner listener
  static IronSourceBannerListener? _bannerListener;
  static void setBannerListener(IronSourceBannerListener? listener) {
    _bannerListener = listener;
  }

  static void setBNListener(IronSourceBannerListener? listener) {
    _bannerListener = listener;
  }

  // OfferWall listener
  static IronSourceOfferwallListener? _offerwallListener;
  static void setOfferWallListener(IronSourceOfferwallListener? listener) {
    _offerwallListener = listener;
  }

  static void setOWListener(IronSourceOfferwallListener? listener) {
    _offerwallListener = listener;
  }

  // ILR listener
  static IronSourceImpressionDataListener? _impressionDataListener;
  static void setImpressionDataListener(
      IronSourceImpressionDataListener? listener) {
    _impressionDataListener = listener;
  }

  // iOS Consent View listener
  static IronSourceConsentViewListener? _consentViewListener;
  static void setConsentViewListener(IronSourceConsentViewListener? listener) {
    _consentViewListener = listener;
  }

  // LevelPlay RewardedVideo
  static LevelPlayRewardedVideoListener? _levelPlayRewardedVideoListener;
  static void setLevelPlayRewardedVideoListener(
      LevelPlayRewardedVideoListener? listener) {
    _levelPlayRewardedVideoListener = listener;
  }

  // LevelPlay Manual Load RewardedVideo
  static LevelPlayRewardedVideoManualListener?
      _levelPlayRewardedVideoManualListener;
  static void setLevelPlayRewardedVideoManualListener(
      LevelPlayRewardedVideoManualListener? listener) {
    _levelPlayRewardedVideoManualListener = listener;
  }

  // LevelPlay Interstitial
  static LevelPlayInterstitialListener? _levelPlayInterstitialListener;
  static void setLevelPlayInterstitialListener(
      LevelPlayInterstitialListener? listener) {
    _levelPlayInterstitialListener = listener;
  }

  // LevelPlay Banner
  static LevelPlayBannerListener? _levelPlayBannerListener;
  static void setLevelPlayBannerListener(LevelPlayBannerListener? listener) {
    _levelPlayBannerListener = listener;
  }

  // Triggers corresponding listener functions.
  static Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {

      // Init completion ///////////////////////////////////////////////////////////////////////////
      case 'onInitializationComplete':
        return _initializationListener?.onInitializationComplete();

      // RewardedVideo events /////////////////////////////////////////////////////////////////////////////////
      case 'onRewardedVideoAdOpened':
        _rewardedVideoListener?.onRewardedVideoAdOpened();
        _rewardedVideoManualListener?.onRewardedVideoAdOpened();
        return;
      case 'onRewardedVideoAdClosed':
        _rewardedVideoListener?.onRewardedVideoAdClosed();
        _rewardedVideoManualListener?.onRewardedVideoAdClosed();
        return;
      case 'onRewardedVideoAvailabilityChanged':
        final isAvailable =
            IncomingValueParser.getAvailabilityBool(call.arguments);
        _rewardedVideoListener?.onRewardedVideoAvailabilityChanged(isAvailable);
        _rewardedVideoManualListener
            ?.onRewardedVideoAvailabilityChanged(isAvailable);
        return;
      case 'onRewardedVideoAdRewarded':
        final rewardedvideoPlacement =
            IncomingValueParser.getRewardedVideoPlacement(call.arguments);
        _rewardedVideoListener
            ?.onRewardedVideoAdRewarded(rewardedvideoPlacement);
        _rewardedVideoManualListener
            ?.onRewardedVideoAdRewarded(rewardedvideoPlacement);
        return;
      case 'onRewardedVideoAdShowFailed':
        final error = IncomingValueParser.getIronSourceError(call.arguments);
        _rewardedVideoListener?.onRewardedVideoAdShowFailed(error);
        _rewardedVideoManualListener?.onRewardedVideoAdShowFailed(error);
        return;
      case 'onRewardedVideoAdClicked':
        final rewardedvideoPlacement =
            IncomingValueParser.getRewardedVideoPlacement(call.arguments);
        _rewardedVideoListener
            ?.onRewardedVideoAdClicked(rewardedvideoPlacement);
        _rewardedVideoManualListener
            ?.onRewardedVideoAdClicked(rewardedvideoPlacement);
        return;
      case 'onRewardedVideoAdStarted':
        _rewardedVideoListener?.onRewardedVideoAdStarted();
        _rewardedVideoManualListener?.onRewardedVideoAdStarted();
        return;
      case 'onRewardedVideoAdEnded':
        _rewardedVideoListener?.onRewardedVideoAdEnded();
        _rewardedVideoManualListener?.onRewardedVideoAdEnded();
        return;

      // Manual Load RewardedVideo events
      case 'onRewardedVideoAdReady':
        return _rewardedVideoManualListener?.onRewardedVideoAdReady();
      case 'onRewardedVideoAdLoadFailed':
        final error = IncomingValueParser.getIronSourceError(call.arguments);
        return _rewardedVideoManualListener?.onRewardedVideoAdLoadFailed(error);

      // Interstitial Events
      case 'onInterstitialAdReady':
        return _interstitialListener?.onInterstitialAdReady();
      case 'onInterstitialAdLoadFailed':
        final error = IncomingValueParser.getIronSourceError(call.arguments);
        return _interstitialListener?.onInterstitialAdLoadFailed(error);
      case 'onInterstitialAdOpened':
        return _interstitialListener?.onInterstitialAdOpened();
      case 'onInterstitialAdClosed':
        return _interstitialListener?.onInterstitialAdClosed();
      case 'onInterstitialAdShowSucceeded':
        return _interstitialListener?.onInterstitialAdShowSucceeded();
      case 'onInterstitialAdShowFailed':
        final error = IncomingValueParser.getIronSourceError(call.arguments);
        return _interstitialListener?.onInterstitialAdShowFailed(error);
      case 'onInterstitialAdClicked':
        return _interstitialListener?.onInterstitialAdClicked();

      // Banner Events
      case 'onBannerAdLoaded':
        return _bannerListener?.onBannerAdLoaded();
      case 'onBannerAdLoadFailed':
        final error = IncomingValueParser.getIronSourceError(call.arguments);
        return _bannerListener?.onBannerAdLoadFailed(error);
      case 'onBannerAdClicked':
        return _bannerListener?.onBannerAdClicked();
      case 'onBannerAdScreenPresented':
        return _bannerListener?.onBannerAdScreenPresented();
      case 'onBannerAdScreenDismissed':
        return _bannerListener?.onBannerAdScreenDismissed();
      case 'onBannerAdLeftApplication':
        return _bannerListener?.onBannerAdLeftApplication();

      // OfferWall Events
      case 'onOfferwallAvailabilityChanged':
        final isAvailable =
            IncomingValueParser.getAvailabilityBool(call.arguments);
        return _offerwallListener?.onOfferwallAvailabilityChanged(isAvailable);
      case 'onOfferwallOpened':
        return _offerwallListener?.onOfferwallOpened();
      case 'onOfferwallShowFailed':
        final error = IncomingValueParser.getIronSourceError(call.arguments);
        return _offerwallListener?.onOfferwallShowFailed(error);
      case 'onOfferwallAdCredited':
        final creditInfo =
            IncomingValueParser.getOfferWallCreditInfo(call.arguments);
        return _offerwallListener?.onOfferwallAdCredited(creditInfo);
      case 'onGetOfferwallCreditsFailed':
        final error = IncomingValueParser.getIronSourceError(call.arguments);
        return _offerwallListener?.onGetOfferwallCreditsFailed(error);
      case 'onOfferwallClosed':
        return _offerwallListener?.onOfferwallClosed();

      // ImpressionData Event
      case 'onImpressionSuccess':
        final impressionData =
            IncomingValueParser.getImpressionData(call.arguments);
        return _impressionDataListener?.onImpressionSuccess(impressionData);

      // iOS14 ConsentView Event
      case 'consentViewDidLoadSuccess':
        final consentViewType =
            IncomingValueParser.getConsentViewTypeString(call.arguments);
        return _consentViewListener?.consentViewDidLoadSuccess(consentViewType);
      case 'consentViewDidFailToLoad':
        final error = IncomingValueParser.getConsentViewError(call.arguments);
        return _consentViewListener?.consentViewDidFailToLoad(error);
      case 'consentViewDidShowSuccess':
        final consentViewType =
            IncomingValueParser.getConsentViewTypeString(call.arguments);
        return _consentViewListener?.consentViewDidShowSuccess(consentViewType);
      case 'consentViewDidFailToShow':
        final error = IncomingValueParser.getConsentViewError(call.arguments);
        return _consentViewListener?.consentViewDidFailToShow(error);
      case 'consentViewDidAccept':
        final consentViewType =
            IncomingValueParser.getConsentViewTypeString(call.arguments);
        return _consentViewListener?.consentViewDidAccept(consentViewType);

      // LevelPlay Listeners
      // Auto RewardedVideo
      case 'LevelPlay_RewardedVideo:onAdAvailable':
        final adInfo = IncomingValueParser.getAdInfo(call.arguments);
        return _levelPlayRewardedVideoListener?.onAdAvailable(adInfo);
      case 'LevelPlay_RewardedVideo:onAdUnavailable':
        return _levelPlayRewardedVideoListener?.onAdUnavailable();
      // RewardedVideo common
      case 'LevelPlay_RewardedVideo:onAdOpened':
        final adInfo = IncomingValueParser.getAdInfo(call.arguments);
        _levelPlayRewardedVideoListener?.onAdOpened(adInfo);
        _levelPlayRewardedVideoManualListener?.onAdOpened(adInfo);
        return;
      case 'LevelPlay_RewardedVideo:onAdClosed':
        final adInfo = IncomingValueParser.getAdInfo(call.arguments);
        _levelPlayRewardedVideoListener?.onAdClosed(adInfo);
        _levelPlayRewardedVideoManualListener?.onAdClosed(adInfo);
        return;
      case 'LevelPlay_RewardedVideo:onAdRewarded':
        final rewardedvideoPlacement =
            IncomingValueParser.getRewardedVideoPlacement(
                IncomingValueParser.getValueForKey(
                    IronConstKey.PLACEMENT, call.arguments));
        final adInfo = IncomingValueParser.getAdInfo(
            IncomingValueParser.getValueForKey(
                IronConstKey.AD_INFO, call.arguments));
        _levelPlayRewardedVideoListener?.onAdRewarded(
            rewardedvideoPlacement, adInfo);
        _levelPlayRewardedVideoManualListener?.onAdRewarded(
            rewardedvideoPlacement, adInfo);
        return;
      case 'LevelPlay_RewardedVideo:onAdShowFailed':
        final error = IncomingValueParser.getIronSourceError(
            IncomingValueParser.getValueForKey(
                IronConstKey.ERROR, call.arguments));
        final adInfo = IncomingValueParser.getAdInfo(
            IncomingValueParser.getValueForKey(
                IronConstKey.AD_INFO, call.arguments));
        _levelPlayRewardedVideoListener?.onAdShowFailed(error, adInfo);
        _levelPlayRewardedVideoManualListener?.onAdShowFailed(error, adInfo);
        return;
      case 'LevelPlay_RewardedVideo:onAdClicked':
        final rewardedvideoPlacement =
            IncomingValueParser.getRewardedVideoPlacement(
                IncomingValueParser.getValueForKey(
                    IronConstKey.PLACEMENT, call.arguments));
        final adInfo = IncomingValueParser.getAdInfo(
            IncomingValueParser.getValueForKey(
                IronConstKey.AD_INFO, call.arguments));
        _levelPlayRewardedVideoListener?.onAdClicked(
            rewardedvideoPlacement, adInfo);
        _levelPlayRewardedVideoManualListener?.onAdClicked(
            rewardedvideoPlacement, adInfo);
        return;
      // Manual RewardedVideo
      case 'LevelPlay_RewardedVideo:onAdReady':
        final adInfo = IncomingValueParser.getAdInfo(call.arguments);
        return _levelPlayRewardedVideoManualListener?.onAdReady(adInfo);
      case 'LevelPlay_RewardedVideo:onAdLoadFailed':
        final error = IncomingValueParser.getIronSourceError(call.arguments);
        return _levelPlayRewardedVideoManualListener?.onAdLoadFailed(error);

      // LevelPlay Interstitial
      case 'LevelPlay_Interstitial:onAdReady':
        final adInfo = IncomingValueParser.getAdInfo(call.arguments);
        return _levelPlayInterstitialListener?.onAdReady(adInfo);
      case 'LevelPlay_Interstitial:onAdLoadFailed':
        final error = IncomingValueParser.getIronSourceError(call.arguments);
        return _levelPlayInterstitialListener?.onAdLoadFailed(error);
      case 'LevelPlay_Interstitial:onAdOpened':
        final adInfo = IncomingValueParser.getAdInfo(call.arguments);
        return _levelPlayInterstitialListener?.onAdOpened(adInfo);
      case 'LevelPlay_Interstitial:onAdClosed':
        final adInfo = IncomingValueParser.getAdInfo(call.arguments);
        return _levelPlayInterstitialListener?.onAdClosed(adInfo);
      case 'LevelPlay_Interstitial:onAdShowFailed':
        final error = IncomingValueParser.getIronSourceError(
            IncomingValueParser.getValueForKey(
                IronConstKey.ERROR, call.arguments));
        final adInfo = IncomingValueParser.getAdInfo(
            IncomingValueParser.getValueForKey(
                IronConstKey.AD_INFO, call.arguments));
        return _levelPlayInterstitialListener?.onAdShowFailed(error, adInfo);
      case 'LevelPlay_Interstitial:onAdClicked':
        final adInfo = IncomingValueParser.getAdInfo(call.arguments);
        return _levelPlayInterstitialListener?.onAdClicked(adInfo);
      case 'LevelPlay_Interstitial:onAdShowSucceeded':
        final adInfo = IncomingValueParser.getAdInfo(call.arguments);
        return _levelPlayInterstitialListener?.onAdShowSucceeded(adInfo);

      // LevelPlay Banner
      case 'LevelPlay_Banner:onAdLoaded':
        final adInfo = IncomingValueParser.getAdInfo(call.arguments);
        return _levelPlayBannerListener?.onAdLoaded(adInfo);
      case 'LevelPlay_Banner:onAdLoadFailed':
        final error = IncomingValueParser.getIronSourceError(call.arguments);
        return _levelPlayBannerListener?.onAdLoadFailed(error);
      case 'LevelPlay_Banner:onAdClicked':
        final adInfo = IncomingValueParser.getAdInfo(call.arguments);
        return _levelPlayBannerListener?.onAdClicked(adInfo);
      case 'LevelPlay_Banner:onAdScreenPresented':
        final adInfo = IncomingValueParser.getAdInfo(call.arguments);
        return _levelPlayBannerListener?.onAdScreenPresented(adInfo);
      case 'LevelPlay_Banner:onAdScreenDismissed':
        final adInfo = IncomingValueParser.getAdInfo(call.arguments);
        return _levelPlayBannerListener?.onAdScreenDismissed(adInfo);
      case 'LevelPlay_Banner:onAdLeftApplication':
        final adInfo = IncomingValueParser.getAdInfo(call.arguments);
        return _levelPlayBannerListener?.onAdLeftApplication(adInfo);

      default:
        throw UnimplementedError("Method not implemented: ${call.method}");
    }
  }
}
