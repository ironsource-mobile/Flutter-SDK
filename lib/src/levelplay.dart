import 'dart:async';
import 'package:flutter/services.dart';

import './utils/level_play_method_channel.dart';
import './utils/level_play_ad_object_manager.dart';
import './utils/levelplay_constants.dart';
import './models/models.dart';

class LevelPlay {
  static final _channel = LevelPlayMethodChannel().channel;
  static String? _flutterVersion;
  
  // Method call handler properties
  static final LevelPlayAdObjectManager _levelPlayAdObjectManager = LevelPlayAdObjectManager();
  
  // LevelPlay Init
  static LevelPlayInitListener? _levelPlayInitListener;
  
  // LevelPlay ImpressionData listener
  static LevelPlayImpressionDataListener? _levelPlayImpressionDataListener;

  /** Utils ======================================================================================*/

  /// Returns the plugin version.
  static String getPluginVersion() { return LevelPlayConstants.PLUGIN_VERSION; }

  /// Returns the native SDK version for [platform].
  /// - [platform] should be either 'android' or 'ios'.
  static String getNativeSDKVersion(String platform) {
    return platform == 'android' ? LevelPlayConstants.ANDROID_SDK_VERSION : platform == 'ios' ? LevelPlayConstants.IOS_SDK_VERSION : '';
  }

  /// Pass the Flutter [version] used for app build.
  /// - __Note__: Must be called before [init].
  static void setFlutterVersion(String version) {
    _flutterVersion = version;
  }

  /** Base API ===================================================================================*/

  /// Calls LevelPlay.validateIntegration to validate adapter integration.
  ///
  /// Native SDK Reference
  /// - Android: validateIntegration
  /// -     iOS: validateIntegration
  static Future<void> validateIntegration() async {
    return _channel.invokeMethod('validateIntegration');
  }

  /// Sets a dynamic user ID for tracking purposes.
  ///
  /// Native SDK Reference
  /// - Android: setDynamicUserId
  /// -     iOS: setDynamicUserId
  static Future<void> setDynamicUserId(String dynamicUserId) async {
    return _channel.invokeMethod('setDynamicUserId', {'userId': dynamicUserId});
  }

  /// Enables debug logging on adapters/SDKs when [isEnabled] is true.
  ///
  /// Native SDK Reference
  /// - Android: setAdaptersDebug
  /// -     iOS: setAdaptersDebug
  static Future<void> setAdaptersDebug(bool isEnabled) async {
    return _channel.invokeMethod('setAdaptersDebug', {'isEnabled': isEnabled});
  }

  /// Sets [isConsent] as the GDPR setting.
  /// - __Note__: Must be called before [init].
  ///
  /// Native SDK Reference
  /// - Android: setConsent
  /// -     iOS: setConsent
  static Future<void> setConsent(bool isConsent) async {
    return _channel.invokeMethod('setConsent', {'isConsent': isConsent});
  }

  /// Sets metadata with key-value pairs for custom configurations.
  ///
  /// Native SDK Reference
  /// - Android: setMetaData
  /// -     iOS: setMetaDataWithKey
  static Future<void> setMetaData(Map<String, List<String>> metaData) async {
    return _channel.invokeMethod('setMetaData', {'metaData': metaData});
  }

  /// Configures a user segment with specific attributes for targeting purposes.
  ///
  /// Native SDK Reference
  /// - Android: setSegment
  /// -     iOS: setSegment
  static Future<void> setSegment(LevelPlaySegment segment) async {
    return _channel.invokeMethod('setSegment', {'segment': segment.toMap()});
  }

  /// Launches the LevelPlay Test Suite for debugging and validation.
  ///
  /// Native SDK Reference
  /// - Android: launchTestSuite
  /// -     iOS: launchTestSuite
  static Future<void> launchTestSuite() {
    return _channel.invokeMethod('launchTestSuite');
  }

  /** SDK Init API ===============================================================================*/

  /// Sets the addImpressionDataListener to handle impression data events.
  static void addImpressionDataListener(LevelPlayImpressionDataListener? listener) {
    _addLevelPlayImpressionDataListener(listener);
    _channel.invokeMethod('addImpressionDataListener');
  }

  /// Initializes the LevelPlay SDK with [LevelPlayInitRequest] and [LevelPlayInitListener].
  ///
  /// Native SDK Reference
  /// - Android: init
  /// -     iOS: initWith
  static Future<void> init({required LevelPlayInitRequest initRequest, required LevelPlayInitListener initListener}) async {
    /// set the plugin data first
    final pluginData = {
      'pluginType': LevelPlayConstants.PLUGIN_TYPE,
      'pluginVersion': LevelPlayConstants.PLUGIN_VERSION,
    };
    if (_flutterVersion != null) {
      pluginData['pluginFrameworkVersion'] = _flutterVersion!;
    }
    await _channel.invokeMethod('setPluginData', pluginData);

    _setLevelPlayInitListener(initListener);
    return _channel.invokeMethod('init', initRequest.toMap());
  }

  /** Method Call Handler ====================================================================*/
  
  static void _setLevelPlayInitListener(LevelPlayInitListener listener) {
    _levelPlayInitListener = listener;
  }

  static void _addLevelPlayImpressionDataListener(LevelPlayImpressionDataListener? listener) {
    _levelPlayImpressionDataListener = listener;
  }

  /// Handles listener method calls from the native platform.
  static Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      // LevelPlay Init
      case 'onInitFailed':
        final error = LevelPlayInitError.fromMap(call.arguments);
        return _levelPlayInitListener?.onInitFailed(error);
      case 'onInitSuccess':
        final configuration = LevelPlayConfiguration.fromMap(call.arguments);
        return _levelPlayInitListener?.onInitSuccess(configuration);

      // LevelPlay ImpressionData
      case 'onImpressionSuccess':
        final impressionData = LevelPlayImpressionData.fromMap(call.arguments);
        return _levelPlayImpressionDataListener?.onImpressionSuccess(impressionData);

      // LevelPlay Rewarded Ad
      case 'onRewardedAdLoaded':
        final adId = call.arguments["adId"] as String;
        final adInfo = LevelPlayAdInfo.fromMap(call.arguments['adInfo']);
        final rewardedAdObject = _levelPlayAdObjectManager.rewardedAdsMap[adId];
        rewardedAdObject?.getListener()?.onAdLoaded(adInfo);
        break;
      case 'onRewardedAdLoadFailed':
        final adId = call.arguments["adId"] as String;
        final error = LevelPlayAdError.fromMap(call.arguments['error']);
        final rewardedAdObject = _levelPlayAdObjectManager.rewardedAdsMap[adId];
        rewardedAdObject?.getListener()?.onAdLoadFailed(error);
        break;
      case 'onRewardedAdInfoChanged':
        final adId = call.arguments["adId"] as String;
        final adInfo = LevelPlayAdInfo.fromMap(call.arguments['adInfo']);
        final rewardedAdObject = _levelPlayAdObjectManager.rewardedAdsMap[adId];
        rewardedAdObject?.getListener()?.onAdInfoChanged(adInfo);
        break;
      case 'onRewardedAdDisplayed':
        final adId = call.arguments["adId"] as String;
        final adInfo = LevelPlayAdInfo.fromMap(call.arguments['adInfo']);
        final rewardedAdObject = _levelPlayAdObjectManager.rewardedAdsMap[adId];
        rewardedAdObject?.getListener()?.onAdDisplayed(adInfo);
        break;
      case 'onRewardedAdDisplayFailed':
        final adId = call.arguments["adId"] as String;
        final error = LevelPlayAdError.fromMap(call.arguments['error']);
        final adInfo = LevelPlayAdInfo.fromMap(call.arguments['adInfo']);
        final rewardedAdObject = _levelPlayAdObjectManager.rewardedAdsMap[adId];
        rewardedAdObject?.getListener()?.onAdDisplayFailed(error, adInfo);
        break;
      case 'onRewardedAdClicked':
        final adId = call.arguments["adId"] as String;
        final adInfo = LevelPlayAdInfo.fromMap(call.arguments['adInfo']);
        final rewardedAdObject = _levelPlayAdObjectManager.rewardedAdsMap[adId];
        rewardedAdObject?.getListener()?.onAdClicked(adInfo);
        break;
      case 'onRewardedAdClosed':
        final adId = call.arguments["adId"] as String;
        final adInfo = LevelPlayAdInfo.fromMap(call.arguments['adInfo']);
        final rewardedAdObject = _levelPlayAdObjectManager.rewardedAdsMap[adId];
        rewardedAdObject?.getListener()?.onAdClosed(adInfo);
        break;
      case 'onRewardedAdRewarded':
        final adId = call.arguments["adId"] as String;
        final adInfo = LevelPlayAdInfo.fromMap(call.arguments['adInfo']);
        final reward = LevelPlayReward.fromMap(call.arguments['reward']);
        final rewardedAdObject = _levelPlayAdObjectManager.rewardedAdsMap[adId];
        rewardedAdObject?.getListener()?.onAdRewarded(reward, adInfo);
        break;

    // LevelPlay Interstitial Ad
      case 'onInterstitialAdLoaded':
        final adId = call.arguments["adId"] as String;
        final adInfo = LevelPlayAdInfo.fromMap(call.arguments['adInfo']);
        final interstitialAdObject = _levelPlayAdObjectManager.interstitialAdsMap[adId];
        interstitialAdObject?.getListener()?.onAdLoaded(adInfo);
        break;
      case 'onInterstitialAdLoadFailed':
        final adId = call.arguments["adId"] as String;
        final error = LevelPlayAdError.fromMap(call.arguments['error']);
        final interstitialAdObject = _levelPlayAdObjectManager.interstitialAdsMap[adId];
        interstitialAdObject?.getListener()?.onAdLoadFailed(error);
        break;
      case 'onInterstitialAdInfoChanged':
        final adId = call.arguments["adId"] as String;
        final adInfo = LevelPlayAdInfo.fromMap(call.arguments['adInfo']);
        final interstitialAdObject = _levelPlayAdObjectManager.interstitialAdsMap[adId];
        interstitialAdObject?.getListener()?.onAdInfoChanged(adInfo);
        break;
      case 'onInterstitialAdDisplayed':
        final adId = call.arguments["adId"] as String;
        final adInfo = LevelPlayAdInfo.fromMap(call.arguments['adInfo']);
        final interstitialAdObject = _levelPlayAdObjectManager.interstitialAdsMap[adId];
        interstitialAdObject?.getListener()?.onAdDisplayed(adInfo);
        break;
      case 'onInterstitialAdDisplayFailed':
        final adId = call.arguments["adId"] as String;
        final error = LevelPlayAdError.fromMap(call.arguments['error']);
        final adInfo = LevelPlayAdInfo.fromMap(call.arguments['adInfo']);
        final interstitialAdObject = _levelPlayAdObjectManager.interstitialAdsMap[adId];
        interstitialAdObject?.getListener()?.onAdDisplayFailed(error, adInfo);
        break;
      case 'onInterstitialAdClicked':
        final adId = call.arguments["adId"] as String;
        final adInfo = LevelPlayAdInfo.fromMap(call.arguments['adInfo']);
        final interstitialAdObject = _levelPlayAdObjectManager.interstitialAdsMap[adId];
        interstitialAdObject?.getListener()?.onAdClicked(adInfo);
        break;
      case 'onInterstitialAdClosed':
        final adId = call.arguments["adId"] as String;
        final adInfo = LevelPlayAdInfo.fromMap(call.arguments['adInfo']);
        final interstitialAdObject = _levelPlayAdObjectManager.interstitialAdsMap[adId];
        interstitialAdObject?.getListener()?.onAdClosed(adInfo);
        break;
      default:
        throw UnimplementedError("Method not implemented: ${call.method}");
    }
  }
}
