import 'package:flutter/services.dart';
import './level_play_ad_object_manager.dart';
import './ironsource_constants.dart';
import './incoming_value_parser.dart';
import '../models/models.dart';

/// Handles listener method calls from the native platform.
class IronSourceMethodCallHandler {
  static final LevelPlayAdObjectManager _levelPlayAdObjectManager = LevelPlayAdObjectManager();

  // Init listener
  static IronSourceInitializationListener? _initializationListener;
  static void setInitListener(IronSourceInitializationListener? listener) {
    _initializationListener = listener;
  }

  // ILR listener
  static IronSourceImpressionDataListener? _ironSourceImpressionDataListener;
  static void setImpressionDataListener(IronSourceImpressionDataListener? listener) {
    _ironSourceImpressionDataListener = listener;
  }
  static ImpressionDataListener? _impressionDataListener;
  static void addImpressionDataListener(ImpressionDataListener? listener) {
    _impressionDataListener = listener;
  }

  // iOS Consent View listener
  @Deprecated("This Listener will be removed in 4.0.0 version.")
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
  static LevelPlayRewardedVideoManualListener? _levelPlayRewardedVideoManualListener;
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
  @Deprecated("This method will be removed in future versions. Please use LevelPlayBannerAdView instead.")
  static void setLevelPlayBannerListener(LevelPlayBannerListener? listener) {
    _levelPlayBannerListener = listener;
  }

  // LevelPlay ImpressionData listener
  static LevelPlayImpressionDataListener? _levelPlayImpressionDataListener;
  static void addLevelPlayImpressionDataListener(LevelPlayImpressionDataListener? listener) {
    _levelPlayImpressionDataListener = listener;
  }

  // LevelPlay Init
  static LevelPlayInitListener? _levelPlayInitListener;
  static void setLevelPlayInitListener(LevelPlayInitListener listener) {
    _levelPlayInitListener = listener;
  }

  // Triggers corresponding listener functions.
  static Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {

      // Init completion ///////////////////////////////////////////////////////////////////////////
      case 'onInitializationComplete':
        return _initializationListener?.onInitializationComplete();

      // ImpressionData Event
      case 'onImpressionSuccess':
        if (_ironSourceImpressionDataListener != null) { // Deprecated is set
          final ironSourceImpressionData = IncomingValueParser.getIronSourceImpressionData(call.arguments);
          return _ironSourceImpressionDataListener?.onImpressionSuccess(ironSourceImpressionData);
        }
        // New is set
        final impressionData = ImpressionData.fromMap(call.arguments);
        return _impressionDataListener?.onImpressionSuccess(impressionData);

      // iOS14 ConsentView Event
      case 'consentViewDidLoadSuccess':
        final consentViewType = IncomingValueParser.getConsentViewTypeString(call.arguments);
        return _consentViewListener?.consentViewDidLoadSuccess(consentViewType);
      case 'consentViewDidFailToLoad':
        final error = IncomingValueParser.getConsentViewError(call.arguments);
        return _consentViewListener?.consentViewDidFailToLoad(error);
      case 'consentViewDidShowSuccess':
        final consentViewType = IncomingValueParser.getConsentViewTypeString(call.arguments);
        return _consentViewListener?.consentViewDidShowSuccess(consentViewType);
      case 'consentViewDidFailToShow':
        final error = IncomingValueParser.getConsentViewError(call.arguments);
        return _consentViewListener?.consentViewDidFailToShow(error);
      case 'consentViewDidAccept':
        final consentViewType = IncomingValueParser.getConsentViewTypeString(call.arguments);
        return _consentViewListener?.consentViewDidAccept(consentViewType);

      // LevelPlay Listeners
      // Auto RewardedVideo
      case 'LevelPlay_RewardedVideo:onAdAvailable':
        final adInfo = IncomingValueParser.getIronSourceAdInfo(call.arguments);
        return _levelPlayRewardedVideoListener?.onAdAvailable(adInfo);
      case 'LevelPlay_RewardedVideo:onAdUnavailable':
        return _levelPlayRewardedVideoListener?.onAdUnavailable();
      // RewardedVideo common
      case 'LevelPlay_RewardedVideo:onAdOpened':
        final adInfo = IncomingValueParser.getIronSourceAdInfo(call.arguments);
        _levelPlayRewardedVideoListener?.onAdOpened(adInfo);
        _levelPlayRewardedVideoManualListener?.onAdOpened(adInfo);
        return;
      case 'LevelPlay_RewardedVideo:onAdClosed':
        final adInfo = IncomingValueParser.getIronSourceAdInfo(call.arguments);
        _levelPlayRewardedVideoListener?.onAdClosed(adInfo);
        _levelPlayRewardedVideoManualListener?.onAdClosed(adInfo);
        return;
      case 'LevelPlay_RewardedVideo:onAdRewarded':
        final rewardedvideoPlacement = IncomingValueParser.getRewardedVideoPlacement(IncomingValueParser.getValueForKey(IronConstKey.PLACEMENT, call.arguments));
        final adInfo = IncomingValueParser.getIronSourceAdInfo(IncomingValueParser.getValueForKey(IronConstKey.AD_INFO, call.arguments));
        _levelPlayRewardedVideoListener?.onAdRewarded(rewardedvideoPlacement, adInfo);
        _levelPlayRewardedVideoManualListener?.onAdRewarded(rewardedvideoPlacement, adInfo);
        return;
      case 'LevelPlay_RewardedVideo:onAdShowFailed':
        final error = IncomingValueParser.getIronSourceError(IncomingValueParser.getValueForKey(IronConstKey.ERROR, call.arguments));
        final adInfo = IncomingValueParser.getIronSourceAdInfo(IncomingValueParser.getValueForKey(IronConstKey.AD_INFO, call.arguments));
        _levelPlayRewardedVideoListener?.onAdShowFailed(error, adInfo);
        _levelPlayRewardedVideoManualListener?.onAdShowFailed(error, adInfo);
        return;
      case 'LevelPlay_RewardedVideo:onAdClicked':
        final rewardedvideoPlacement = IncomingValueParser.getRewardedVideoPlacement(IncomingValueParser.getValueForKey(IronConstKey.PLACEMENT, call.arguments));
        final adInfo = IncomingValueParser.getIronSourceAdInfo(IncomingValueParser.getValueForKey(IronConstKey.AD_INFO, call.arguments));
        _levelPlayRewardedVideoListener?.onAdClicked(rewardedvideoPlacement, adInfo);
        _levelPlayRewardedVideoManualListener?.onAdClicked(rewardedvideoPlacement, adInfo);
        return;
      // Manual RewardedVideo
      case 'LevelPlay_RewardedVideo:onAdReady':
        final adInfo = IncomingValueParser.getIronSourceAdInfo(call.arguments);
        return _levelPlayRewardedVideoManualListener?.onAdReady(adInfo);
      case 'LevelPlay_RewardedVideo:onAdLoadFailed':
        final error = IncomingValueParser.getIronSourceError(call.arguments);
        return _levelPlayRewardedVideoManualListener?.onAdLoadFailed(error);

      // LevelPlay Interstitial
      case 'LevelPlay_Interstitial:onAdReady':
        final adInfo = IncomingValueParser.getIronSourceAdInfo(call.arguments);
        return _levelPlayInterstitialListener?.onAdReady(adInfo);
      case 'LevelPlay_Interstitial:onAdLoadFailed':
        final error = IncomingValueParser.getIronSourceError(call.arguments);
        return _levelPlayInterstitialListener?.onAdLoadFailed(error);
      case 'LevelPlay_Interstitial:onAdOpened':
        final adInfo = IncomingValueParser.getIronSourceAdInfo(call.arguments);
        return _levelPlayInterstitialListener?.onAdOpened(adInfo);
      case 'LevelPlay_Interstitial:onAdClosed':
        final adInfo = IncomingValueParser.getIronSourceAdInfo(call.arguments);
        return _levelPlayInterstitialListener?.onAdClosed(adInfo);
      case 'LevelPlay_Interstitial:onAdShowFailed':
        final error = IncomingValueParser.getIronSourceError(IncomingValueParser.getValueForKey(IronConstKey.ERROR, call.arguments));
        final adInfo = IncomingValueParser.getIronSourceAdInfo(IncomingValueParser.getValueForKey(IronConstKey.AD_INFO, call.arguments));
        return _levelPlayInterstitialListener?.onAdShowFailed(error, adInfo);
      case 'LevelPlay_Interstitial:onAdClicked':
        final adInfo = IncomingValueParser.getIronSourceAdInfo(call.arguments);
        return _levelPlayInterstitialListener?.onAdClicked(adInfo);
      case 'LevelPlay_Interstitial:onAdShowSucceeded':
        final adInfo = IncomingValueParser.getIronSourceAdInfo(call.arguments);
        return _levelPlayInterstitialListener?.onAdShowSucceeded(adInfo);

      // LevelPlay Banner
      case 'LevelPlay_Banner:onAdLoaded':
        final adInfo = IncomingValueParser.getIronSourceAdInfo(call.arguments);
        return _levelPlayBannerListener?.onAdLoaded(adInfo);
      case 'LevelPlay_Banner:onAdLoadFailed':
        final error = IncomingValueParser.getIronSourceError(call.arguments);
        return _levelPlayBannerListener?.onAdLoadFailed(error);
      case 'LevelPlay_Banner:onAdClicked':
        final adInfo = IncomingValueParser.getIronSourceAdInfo(call.arguments);
        return _levelPlayBannerListener?.onAdClicked(adInfo);
      case 'LevelPlay_Banner:onAdScreenPresented':
        final adInfo = IncomingValueParser.getIronSourceAdInfo(call.arguments);
        return _levelPlayBannerListener?.onAdScreenPresented(adInfo);
      case 'LevelPlay_Banner:onAdScreenDismissed':
        final adInfo = IncomingValueParser.getIronSourceAdInfo(call.arguments);
        return _levelPlayBannerListener?.onAdScreenDismissed(adInfo);
      case 'LevelPlay_Banner:onAdLeftApplication':
        final adInfo = IncomingValueParser.getIronSourceAdInfo(call.arguments);
        return _levelPlayBannerListener?.onAdLeftApplication(adInfo);

      // LevelPlay ImpressionData
      case 'onLevelPlayImpressionSuccess':
        final impressionData = LevelPlayImpressionData.fromMap(call.arguments);
        return _levelPlayImpressionDataListener?.onImpressionSuccess(impressionData);

      // LevelPlay Init
      case 'onInitFailed':
        final error = LevelPlayInitError.fromMap(call.arguments);
        return _levelPlayInitListener?.onInitFailed(error);
      case 'onInitSuccess':
        final configuration = LevelPlayConfiguration.fromMap(call.arguments);
        return _levelPlayInitListener?.onInitSuccess(configuration);

      // LevelPlay Rewarded Ad
      case 'onRewardedAdLoaded':
        final adId = call.arguments["adId"] as String;
        final adInfo = LevelPlayAdInfo.fromMap(call.arguments[IronConstKey.AD_INFO]);
        final rewardedAdObject = _levelPlayAdObjectManager.rewardedAdsMap[adId] as LevelPlayRewardedAd?;
        rewardedAdObject?.getListener()?.onAdLoaded(adInfo);
        break;
      case 'onRewardedAdLoadFailed':
        final adId = call.arguments["adId"] as String;
        final error = LevelPlayAdError.fromMap(call.arguments[IronConstKey.ERROR]);
        final rewardedAdObject = _levelPlayAdObjectManager.rewardedAdsMap[adId] as LevelPlayRewardedAd?;
        rewardedAdObject?.getListener()?.onAdLoadFailed(error);
        break;
      case 'onRewardedAdInfoChanged':
        final adId = call.arguments["adId"] as String;
        final adInfo = LevelPlayAdInfo.fromMap(call.arguments[IronConstKey.AD_INFO]);
        final rewardedAdObject = _levelPlayAdObjectManager.rewardedAdsMap[adId] as LevelPlayRewardedAd?;
        rewardedAdObject?.getListener()?.onAdInfoChanged(adInfo);
        break;
      case 'onRewardedAdDisplayed':
        final adId = call.arguments["adId"] as String;
        final adInfo = LevelPlayAdInfo.fromMap(call.arguments[IronConstKey.AD_INFO]);
        final rewardedAdObject = _levelPlayAdObjectManager.rewardedAdsMap[adId] as LevelPlayRewardedAd?;
        rewardedAdObject?.getListener()?.onAdDisplayed(adInfo);
        break;
      case 'onRewardedAdDisplayFailed':
        final adId = call.arguments["adId"] as String;
        final error = LevelPlayAdError.fromMap(call.arguments[IronConstKey.ERROR]);
        final adInfo = LevelPlayAdInfo.fromMap(call.arguments[IronConstKey.AD_INFO]);
        final rewardedAdObject = _levelPlayAdObjectManager.rewardedAdsMap[adId] as LevelPlayRewardedAd?;
        rewardedAdObject?.getListener()?.onAdDisplayFailed(error, adInfo);
        break;
      case 'onRewardedAdClicked':
        final adId = call.arguments["adId"] as String;
        final adInfo = LevelPlayAdInfo.fromMap(call.arguments[IronConstKey.AD_INFO]);
        final rewardedAdObject = _levelPlayAdObjectManager.rewardedAdsMap[adId] as LevelPlayRewardedAd?;
        rewardedAdObject?.getListener()?.onAdClicked(adInfo);
        break;
      case 'onRewardedAdClosed':
        final adId = call.arguments["adId"] as String;
        final adInfo = LevelPlayAdInfo.fromMap(call.arguments[IronConstKey.AD_INFO]);
        final rewardedAdObject = _levelPlayAdObjectManager.rewardedAdsMap[adId] as LevelPlayRewardedAd?;
        rewardedAdObject?.getListener()?.onAdClosed(adInfo);
        break;
      case 'onRewardedAdRewarded':
        final adId = call.arguments["adId"] as String;
        final adInfo = LevelPlayAdInfo.fromMap(call.arguments[IronConstKey.AD_INFO]);
        final reward = LevelPlayReward.fromMap(call.arguments[IronConstKey.REWARD]);
        final rewardedAdObject = _levelPlayAdObjectManager.rewardedAdsMap[adId] as LevelPlayRewardedAd?;
        rewardedAdObject?.getListener()?.onAdRewarded(reward, adInfo);
        break;

    // LevelPlay Interstitial Ad
      case 'onInterstitialAdLoaded':
        final adId = call.arguments["adId"] as String;
        final adInfo = LevelPlayAdInfo.fromMap(call.arguments[IronConstKey.AD_INFO]);
        final interstitialAdObject = _levelPlayAdObjectManager.interstitialAdsMap[adId] as LevelPlayInterstitialAd?;
        interstitialAdObject?.getListener()?.onAdLoaded(adInfo);
        break;
      case 'onInterstitialAdLoadFailed':
        final adId = call.arguments["adId"] as String;
        final error = LevelPlayAdError.fromMap(call.arguments[IronConstKey.ERROR]);
        final interstitialAdObject = _levelPlayAdObjectManager.interstitialAdsMap[adId] as LevelPlayInterstitialAd?;
        interstitialAdObject?.getListener()?.onAdLoadFailed(error);
        break;
      case 'onInterstitialAdInfoChanged':
        final adId = call.arguments["adId"] as String;
        final adInfo = LevelPlayAdInfo.fromMap(call.arguments[IronConstKey.AD_INFO]);
        final interstitialAdObject = _levelPlayAdObjectManager.interstitialAdsMap[adId] as LevelPlayInterstitialAd?;
        interstitialAdObject?.getListener()?.onAdInfoChanged(adInfo);
        break;
      case 'onInterstitialAdDisplayed':
        final adId = call.arguments["adId"] as String;
        final adInfo = LevelPlayAdInfo.fromMap(call.arguments[IronConstKey.AD_INFO]);
        final interstitialAdObject = _levelPlayAdObjectManager.interstitialAdsMap[adId] as LevelPlayInterstitialAd?;
        interstitialAdObject?.getListener()?.onAdDisplayed(adInfo);
        break;
      case 'onInterstitialAdDisplayFailed':
        final adId = call.arguments["adId"] as String;
        final error = LevelPlayAdError.fromMap(call.arguments[IronConstKey.ERROR]);
        final adInfo = LevelPlayAdInfo.fromMap(call.arguments[IronConstKey.AD_INFO]);
        final interstitialAdObject = _levelPlayAdObjectManager.interstitialAdsMap[adId] as LevelPlayInterstitialAd?;
        interstitialAdObject?.getListener()?.onAdDisplayFailed(error, adInfo);
        break;
      case 'onInterstitialAdClicked':
        final adId = call.arguments["adId"] as String;
        final adInfo = LevelPlayAdInfo.fromMap(call.arguments[IronConstKey.AD_INFO]);
        final interstitialAdObject = _levelPlayAdObjectManager.interstitialAdsMap[adId] as LevelPlayInterstitialAd?;
        interstitialAdObject?.getListener()?.onAdClicked(adInfo);
        break;
      case 'onInterstitialAdClosed':
        final adId = call.arguments["adId"] as String;
        final adInfo = LevelPlayAdInfo.fromMap(call.arguments[IronConstKey.AD_INFO]);
        final interstitialAdObject = _levelPlayAdObjectManager.interstitialAdsMap[adId] as LevelPlayInterstitialAd?;
        interstitialAdObject?.getListener()?.onAdClosed(adInfo);
        break;
      default:
        throw UnimplementedError("Method not implemented: ${call.method}");
    }
  }
}
