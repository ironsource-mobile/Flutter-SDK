import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import './utils/level_play_method_channel.dart';
import './utils/ironsource_method_call_handler.dart';
import './utils/incoming_value_parser.dart';
import './utils/outgoing_value_parser.dart';
import './utils/ironsource_constants.dart';
import './models/models.dart';

class IronSource {
  static final MethodChannel _channel = LevelPlayMethodChannel().channel;
  static String? _flutterVersion;

  /** Utils ======================================================================================*/

  /// Returns the plugin version.
  static String getPluginVersion() {
    return IronConst.PLUGIN_VERSION;
  }

  /// Returns the native SDK version for [platform].
  /// - [platform] should be either 'android' or 'ios'.
  static String getNativeSDKVersion(String platform) {
    return platform == 'android'
        ? IronConst.ANDROID_SDK_VERSION
        : platform == 'ios'
            ? IronConst.IOS_SDK_VERSION
            : '';
  }

  /// Pass the Flutter [version] used for app build.
  /// - __Note__: Must be called before [init].
  static void setFlutterVersion(String version) {
    _flutterVersion = version;
  }

  /** Base API ===================================================================================*/

  /// Calls IntegrationHelper.validateIntegration to validate adapter integration.
  ///
  /// Native SDK Reference
  /// - Android: validateIntegration
  /// -     iOS: validateIntegration
  static Future<void> validateIntegration() async {
    return _channel.invokeMethod('validateIntegration');
  }

  /// Track the device's network connection state and dynamically changes ad availability
  /// when [isEnabled] is true.
  ///
  /// Native SDK Reference
  /// - Android: shouldTrackNetworkState
  /// -     iOS: shouldTrackReachability
  @Deprecated("This method will be removed in 4.0.0 version.")
  static Future<void> shouldTrackNetworkState(bool isEnabled) async {
    final args = OutgoingValueParser.shouldTrackNetworkState(isEnabled);
    return _channel.invokeMethod('shouldTrackNetworkState', args);
  }

  /// Enables debug logging on adapters/SDKs when [isEnabled] is true.
  ///
  /// Native SDK Reference
  /// - Android: setAdaptersDebug
  /// -     iOS: setAdaptersDebug
  static Future<void> setAdaptersDebug(bool isEnabled) async {
    final args = OutgoingValueParser.setAdaptersDebug(isEnabled);
    return _channel.invokeMethod('setAdaptersDebug', args);
  }

  /// For RV server-to-server callbacks.
  /// - [dynamicUserId] must be set before [showRewardedVideo].
  ///
  /// Native SDK Reference
  /// - Android: setDynamicUserId
  /// -     iOS: setDynamicUserId
  static Future<void> setDynamicUserId(String dynamicUserId) async {
    final args = OutgoingValueParser.setDynamicUserId(dynamicUserId);
    return _channel.invokeMethod('setDynamicUserId', args);
  }

  /// Returns GAID/IDFA (or an empty String if not available).
  ///
  /// Native SDK Reference
  /// - Android: getAdvertiserId
  /// -     iOS: advertiserId
  @Deprecated("This method will be removed in 4.0.0 version.")
  static Future<String> getAdvertiserId() async {
    final id = await _channel.invokeMethod<String>('getAdvertiserId');
    return id ?? "";
  }

  /// Sets [isConsent] as the GDPR setting.
  /// - __Note__: Must be called before [init].
  ///
  /// Native SDK Reference
  /// - Android: setConsent
  /// -     iOS: setConsent
  static Future<void> setConsent(bool isConsent) async {
    final args = OutgoingValueParser.setConsent(isConsent);
    return _channel.invokeMethod('setConsent', args);
  }

  /// Registers [segment] data.
  ///
  /// Native SDK Reference
  /// - Android: setSegment
  /// -     iOS: setSegment
  static Future<void> setSegment(IronSourceSegment segment) async {
    final args = OutgoingValueParser.setSegment(segment);
    return _channel.invokeMethod('setSegment', args);
  }

  /// Registers [metaData].
  /// - Can be used for regulation settings, mediated networks' config, etc.
  /// - Read more at: https://developers.is.com/ironsource-mobile/android/regulation-advanced-settings/
  ///
  /// Native SDK Reference
  /// - Android: setMetaData
  /// -     iOS: setMetaDataWithKey
  static Future<void> setMetaData(Map<String, List<String>> metaData) async {
    final args = OutgoingValueParser.setMetaData(metaData);
    return _channel.invokeMethod('setMetaData', args);
  }

  /// Launches the test suite.
  ///
  /// Native SDK Reference
  /// - Android: launchTestSuite
  /// -     iOS: launchTestSuite
  static Future<void> launchTestSuite() {
    return _channel.invokeMethod('launchTestSuite');
  }

  /// Registers [waterfallConfiguration].
  /// - Can be used for regulation settings, mediated networks' config, etc.
  /// - Read more at: https://developers.is.com/ironsource-mobile/android/regulation-advanced-settings/
  ///
  /// Native SDK Reference
  /// - Android: setWaterfallConfiguration
  /// -     iOS: setWaterfallConfiguration
  static Future<void> setWaterfallConfiguration(WaterfallConfiguration waterfallConfiguration, IronSourceAdUnit adUnit) async {
    final args = OutgoingValueParser.setWaterfallConfiguration(waterfallConfiguration, adUnit);
    return _channel.invokeMethod('setWaterfallConfiguration', args);
  }

  /** SDK Init API ===============================================================================*/

  /// Registers the [userId] for the session.
  /// - Do not use GAID/IDFA for [userId].
  /// - __Note__: Must be called before [init].
  ///
  /// Native SDK Reference
  /// - Android: setUserId
  /// -     iOS: setUserId
  @Deprecated("This method will be removed in 4.0.0 version.")
  static Future<void> setUserId(String userId) async {
    final args = OutgoingValueParser.setUserId(userId);
    return _channel.invokeMethod('setUserId', args);
  }

  /// Initializes the ironSource SDK with [appKey] for [adUnits].
  /// - It will initialize all [IronSourceAdUnit] if [adUnits] was not passed.
  /// - Multiple calls for the same [adUnits] are not allowed.
  /// - The [initListener] callback is called only for the first init completion.
  ///
  /// Native SDK Reference
  /// - Android: init
  /// -     iOS: initWithAppKey
  @Deprecated("This method will be removed in 4.0.0 version. Please use LevelPlay.init instead.")
  static Future<void> init(
      {required String appKey,
      List<IronSourceAdUnit>? adUnits,
      IronSourceInitializationListener? initListener}) async {
    /// set the plugin data first
    final pluginData = OutgoingValueParser.setPluginData(
        IronConst.PLUGIN_TYPE, IronConst.PLUGIN_VERSION, _flutterVersion);
    await _channel.invokeMethod('setPluginData', pluginData);

    if (initListener != null) {
      IronSourceMethodCallHandler.setInitListener(initListener);
    }

    // init
    final args = OutgoingValueParser.init(appKey: appKey, adUnits: adUnits);
    return _channel.invokeMethod('init', args);
  }

  /** RewardedVideo API =====================================================================================*/

  /// Shows an Rewarded Video ad.
  /// - The Ad Placement could be specified by [placementName].
  ///
  /// Native SDK Reference
  /// - Android: showRewardedVideo
  /// -     iOS: showRewardedVideoWithViewController
  @Deprecated("This method will be removed in 4.0.0 version. Please use LevelPlayRewardedAd instead.")
  static Future<void> showRewardedVideo({String? placementName}) async {
    return _channel.invokeMethod('showRewardedVideo',
        OutgoingValueParser.showRewardedVideo(placementName));
  }

  /// Returns an IronSourceRewardedVideoPlacement instance if [placementName] matches.
  /// - Falls back to a Default placement when [placementName] matched with none.
  /// - Returns null if called before init finishes.
  ///
  /// Native SDK Reference
  /// - Android: getRewardedVideoPlacementInfo
  /// -     iOS: rewardedVideoPlacementInfo
  @Deprecated("This method will be removed in 4.0.0 version.")
  static Future<IronSourceRewardedVideoPlacement?>
      getRewardedVideoPlacementInfo({required String placementName}) async {
    final args =
        OutgoingValueParser.getRewardedVideoPlacementInfo(placementName);
    final placementInfo =
        await _channel.invokeMethod('getRewardedVideoPlacementInfo', args);
    return placementInfo != null
        ? IncomingValueParser.getRewardedVideoPlacement(placementInfo)
        : null;
  }

  /// Returns the RewardedVideo availability.
  ///
  /// Native SDK Reference
  /// - Android: isRewardedVideoAvailable
  /// -     iOS: hasRewardedVideo
  @Deprecated("This method will be removed in 4.0.0 version. Use the alternate API LevelPlayRewardedAd#isAdReady() instead.")
  static Future<bool> isRewardedVideoAvailable() async {
    final bool isAvailable =
        await _channel.invokeMethod('isRewardedVideoAvailable');
    return isAvailable;
  }

  /// Returns the capping state of an ad placement named [placementName].
  ///
  /// Native SDK Reference
  /// - Android: isRewardedVideoPlacementCapped
  /// -     iOS: isRewardedVideoCappedForPlacement
  @Deprecated("This method will be removed in 4.0.0 version. Use the alternate API LevelPlayRewardedAd#isPlacementCapped(placementName) instead.")
  static Future<bool> isRewardedVideoPlacementCapped(
      {required String placementName}) async {
    final args =
        OutgoingValueParser.isRewardedVideoPlacementCapped(placementName);
    final bool isCapped =
        await _channel.invokeMethod('isRewardedVideoPlacementCapped', args);
    return isCapped;
  }

  /// Sets the custom [parameters] that will be passed in RV server-to-server callbacks.
  /// - Can be called multiple times per session.
  /// - __Note__: Must be called before [showRewardedVideo].
  ///
  /// Native SDK Reference
  /// - Android: setRewardedVideoServerParameters
  /// -     iOS: setRewardedVideoServerParameters
  @Deprecated("This method will be removed in 4.0.0 version.")
  static Future<void> setRewardedVideoServerParams(
      Map<String, String> parameters) async {
    final args = OutgoingValueParser.setRewardedVideoServerParams(parameters);
    return _channel.invokeMethod('setRewardedVideoServerParams', args);
  }

  /// Clears the custom parameters currently registered for RV server-to-server callbacks.
  ///
  /// Native SDK Reference
  /// - Android: clearRewardedVideoServerParameters
  /// -     iOS: clearRewardedVideoServerParameters
  @Deprecated("This method will be removed in 4.0.0 version.")
  static Future<void> clearRewardedVideoServerParams() async {
    return _channel.invokeMethod('clearRewardedVideoServerParams');
  }

  /// Sets the LevelPlay RewardedVideo Manual Load mode.
  /// - [listener] will receive ad load status updates.
  /// - __Note__: Must be called before [init].
  ///
  /// Native SDK Reference
  /// - Android: setLevelPlayRewardedVideoManualListener
  /// -     iOS: setLevelPlayRewardedVideoManualDelegate
  @Deprecated("This method will be removed in 4.0.0 version. Use the alternate API LevelPlayRewardedAd#setListener(LevelPlayRewardedAdListener) instead.")
  static Future<void> setLevelPlayRewardedVideoManualListener(
      LevelPlayRewardedVideoManualListener? listener) async {
    IronSourceMethodCallHandler.setLevelPlayRewardedVideoManualListener(listener);
    return _channel.invokeMethod('setLevelPlayRewardedVideoManual');
  }

  /// Starts the RewardedVideo load process.
  /// - The RV Manual Load mode must be enabled via [setLevelPlayRewardedVideoManualListener].
  ///
  /// Native SDK Reference
  /// - Android: loadRewardedVideo
  /// -     iOS: loadRewardedVideo
  @Deprecated("This method will be removed in 4.0.0 version. Use the alternate API LevelPlayRewardedAd#loadAd() instead.")
  static Future<void> loadRewardedVideo() async {
    return _channel.invokeMethod('loadRewardedVideo');
  }

  /** Interstitial API =====================================================================================*/

  /// Starts the Interstitial load process.
  /// - Load status updates will be notified to [LevelPlayInterstitialListener]
  ///
  /// Native SDK Reference
  /// - Android: loadInterstitial
  /// -     iOS: loadInterstitial
  @Deprecated("This method will be removed in 4.0.0 version. Use the alternate API LevelPlayInterstitialAd#loadAd() instead.")
  static Future<void> loadInterstitial() async {
    return _channel.invokeMethod('loadInterstitial');
  }

  /// Shows an Interstitial ad.
  /// - The Ad Placement could be specified by [placementName].
  ///
  /// Native SDK Reference
  /// - Android: showInterstitial
  /// -     iOS: showInterstitialWithViewController
  @Deprecated("This method will be removed in 4.0.0 version. Use the alternate API LevelPlayInterstitialAd#showAd() instead.")
  static Future<void> showInterstitial({String? placementName}) async {
    final args = OutgoingValueParser.showInterstitial(placementName);
    return _channel.invokeMethod('showInterstitial', args);
  }

  /// Returns the Interstitial availability.
  ///
  /// Native SDK Reference
  /// - Android: isInterstitialReady
  /// -     iOS: hasInterstitial
  @Deprecated("This method will be removed in 4.0.0 version. Use the alternate API LevelPlayInterstitialAd#isAdReady() instead.")
  static Future<bool> isInterstitialReady() async {
    final bool isISReady = await _channel.invokeMethod('isInterstitialReady');
    return isISReady;
  }

  /// Returns the capping state of an ad placement named [placementName].
  ///
  /// Native SDK Reference
  /// - Android: isInterstitialPlacementCapped
  /// -     iOS: isInterstitialCappedForPlacement
  @Deprecated("This method will be removed in 4.0.0 version. Use the alternate API LevelPlayInterstitialAd#isPlacementCapped(placementName) instead.")
  static Future<bool> isInterstitialPlacementCapped(
      {required String placementName}) async {
    final args =
        OutgoingValueParser.isInterstitialPlacementCapped(placementName);
    final bool isCapped =
        await _channel.invokeMethod('isInterstitialPlacementCapped', args);
    return isCapped;
  }

  /** Banner API =====================================================================================*/

  /// Starts the Banner load process for [size] and [position].
  /// - Once it's successfully loaded, it keeps reloading until getting explicitly destroyed.
  /// - [verticalOffset] could be configured as Upward < 0 < Downward in Android:dp and iOS:point.
  /// - An ad placement could be specified with [placementName].
  /// - Load status updates will be notified to [LevelPlayBannerListener].
  ///
  /// Native SDK Reference
  /// - Android: loadBanner
  /// -     iOS: loadBannerWithViewController
  @Deprecated("This method will be removed in 4.0.0 version. Use the alternate API LevelPlayBannerAdView#loadAd() instead.")
  static Future<void> loadBanner({
    required IronSourceBannerSize size,
    required IronSourceBannerPosition position,
    int? verticalOffset,
    String? placementName,
  }) async {
    final args = OutgoingValueParser.loadBanner(size, position,
        offset: verticalOffset, placementName: placementName);
    return _channel.invokeMethod('loadBanner', args);
  }

  /// Destroys the currently loaded Banner.
  ///
  /// Native SDK Reference
  /// - Android: destroyBanner
  /// -     iOS: destroyBanner
  @Deprecated("This method will be removed in 4.0.0 version. Use the alternate API LevelPlayBannerAdView#destroy() instead.")
  static Future<void> destroyBanner() async {
    return _channel.invokeMethod('destroyBanner');
  }

  /// Changes the visibility of loaded Banner to visible.
  @Deprecated("This method will be removed in 4.0.0 version.")
  static Future<void> displayBanner() async {
    return _channel.invokeMethod('displayBanner');
  }

  /// Changes the visibility of loaded Banner to invisible.
  /// - Reloading does not take place while it's hidden.
  @Deprecated("This method will be removed in 4.0.0 version.")
  static Future<void> hideBanner() async {
    return _channel.invokeMethod('hideBanner');
  }

  /// Returns the capping state of an ad placement named [placementName].
  ///
  /// Native SDK Reference
  /// - Android: isBannerPlacementCapped
  /// -     iOS: isBannerCappedForPlacement
  @Deprecated("Capping for banners are no longer supported.")
  static Future<bool> isBannerPlacementCapped(String placementName) async {
    final args = OutgoingValueParser.isBannerPlacementCapped(placementName);
    final bool isCapped =
        await _channel.invokeMethod('isBannerPlacementCapped', args);
    return isCapped;
  }

  /// Returns the maximal adaptive height of given width.
  ///
  /// Native SDK Reference
  /// - Android: getMaximalAdaptiveHeight
  /// -     iOS: getMaximalAdaptiveHeight
  @Deprecated("This method will be removed in 4.0.0 version.")
  static Future<int> getMaximalAdaptiveHeight(int width) async {
    final args = OutgoingValueParser.getMaximalAdaptiveHeight(width);
    final int adaptiveHeight = await _channel.invokeMethod('getMaximalAdaptiveHeight', args);
    return adaptiveHeight;
  }

  /** Config API ==============================================================================*/

  /// Sets the OW client side automatic polling mode.
  /// - __Note__: Must be called before [init].
  ///
  /// Native SDK Reference
  /// - Android: setClientSideCallbacks
  /// -     iOS: setUseClientSideCallbacks
  @Deprecated("This method will be removed in 4.0.0 version.")
  static Future<void> setClientSideCallbacks(bool isEnabled) async {
    final args = OutgoingValueParser.setClientSideCallbacks(isEnabled);
    return _channel.invokeMethod('setClientSideCallbacks', args);
  }

  /** iOS ConversionValue API ====================================================================*/

  /// Returns the current conversion value.
  /// - Returns null if the current platform is Android.
  ///
  /// Native SDK Reference
  /// - iOS: getConversionValue
  @Deprecated("This method will be removed in 4.0.0 version.")
  static Future<int?> getConversionValue() async {
    if (!Platform.isIOS) {
      return null;
    }
    final int? conversionValue =
        await _channel.invokeMethod('getConversionValue');
    return conversionValue;
  }

  /** iOS ConsentView API ========================================================================*/

  /// Starts the consent view load process for [consentViewType].
  /// - Load status updates will be notified to [IronSourceConsentViewListener]
  ///
  /// Native SDK Reference
  /// - iOS: loadConsentViewWithType
  @Deprecated("This method will be removed in 4.0.0 version.")
  static Future<void> loadConsentViewWithType(String consentViewType) async {
    if (!Platform.isIOS) {
      return;
    }
    final args = OutgoingValueParser.loadConsentViewWithType(consentViewType);
    return _channel.invokeMethod('loadConsentViewWithType', args);
  }

  /// Shows the loaded consent view for [consentViewType].
  /// - Show status updates will be notified to [IronSourceConsentViewListener]
  ///
  /// Native SDK Reference
  /// - iOS: showConsentViewWithViewController
  @Deprecated("This method will be removed in 4.0.0 version.")
  static Future<void> showConsentViewWithType(String consentViewType) async {
    if (!Platform.isIOS) {
      return;
    }
    final args = OutgoingValueParser.showConsentViewWithType(consentViewType);
    return _channel.invokeMethod('showConsentViewWithType', args);
  }

  // Listener setters

  @Deprecated("This method will be removed in 4.0.0 version. Please use addImpressionDataListener instead.")
  static void setImpressionDataListener(IronSourceImpressionDataListener? listener) {
    IronSourceMethodCallHandler.addImpressionDataListener(null); // Make sure only one listener is set
    IronSourceMethodCallHandler.setImpressionDataListener(listener);
  }

  static void addImpressionDataListener(ImpressionDataListener? listener) {
    IronSourceMethodCallHandler.setImpressionDataListener(null); // Make sure only one listener is set
    IronSourceMethodCallHandler.addImpressionDataListener(listener);
  }

  @Deprecated("This method will be removed in 4.0.0 version.")
  static void setConsentViewListener(IronSourceConsentViewListener? listener) {
    IronSourceMethodCallHandler.setConsentViewListener(listener);
  }

  @Deprecated("This method will be removed in 4.0.0 version. Use the alternate API LevelPlayRewardedAd#setListener(LevelPlayRewardedAdListener) instead.")
  static void setLevelPlayRewardedVideoListener(
      LevelPlayRewardedVideoListener? listener) {
    IronSourceMethodCallHandler.setLevelPlayRewardedVideoListener(listener);
  }

  @Deprecated("This method will be removed in 4.0.0 version. Use the alternate API LevelPlayInterstitialAd#setListener(LevelPlayInterstitialAdListener) instead.")
  static void setLevelPlayInterstitialListener(
      LevelPlayInterstitialListener? listener) {
    IronSourceMethodCallHandler.setLevelPlayInterstitialListener(listener);
  }

  @Deprecated("Use the alternate API LevelPlayBannerAdView with LevelPlayBannerAdViewListener instead.")
  static void setLevelPlayBannerListener(LevelPlayBannerListener? listener) {
    IronSourceMethodCallHandler.setLevelPlayBannerListener(listener);
  }
}
