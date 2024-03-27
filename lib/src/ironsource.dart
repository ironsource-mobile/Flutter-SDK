import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import './ironsource_method_call_handler.dart';
import './parsers/incoming_value_parser.dart';
import './parsers/outgoing_value_parser.dart';
import './ironsource_constants.dart';
import './models/models.dart';

class IronSource {
  static final MethodChannel _channel =
      const MethodChannel(IronConst.METHOD_CHANNEL)
        ..setMethodCallHandler(IronSourceMethodCallHandler.handleMethodCall);
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

  /// Registers [waterfallConfiguration].
  /// - Can be used for regulation settings, mediated networks' config, etc.
  /// - Read more at: https://developers.is.com/ironsource-mobile/android/regulation-advanced-settings/
  ///
  /// Native SDK Reference
  /// - Android: setWaterfallConfiguration
  /// -     iOS: setWaterfallConfiguration
  static Future<void> setWaterfallConfiguration(double? ceiling, double? floor, IronSourceAdUnit adUnit) async {
    final args = OutgoingValueParser.setWaterfallConfiguration(ceiling, floor, adUnit);
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

  static Future<void> launchTestSuite() {
    return _channel.invokeMethod('launchTestSuite');
  }

  /** RewardedVideo API =====================================================================================*/

  /// Shows an Rewarded Video ad.
  /// - The Ad Placement could be specified by [placementName].
  ///
  /// Native SDK Reference
  /// - Android: showRewardedVideo
  /// -     iOS: showRewardedVideoWithViewController
  static Future<void> showRewardedVideo({String? placementName}) async {
    return _channel.invokeMethod('showRewardedVideo',
        OutgoingValueParser.showRewardedVideo(placementName));
  }

  /// Returns an [IronSourceRVPlacement] instance if [placementName] matches.
  /// - Falls back to a Default placement when [placementName] matched with none.
  /// - Returns null if called before init finishes.
  ///
  /// Native SDK Reference
  /// - Android: getRewardedVideoPlacementInfo
  /// -     iOS: rewardedVideoPlacementInfo
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
  static Future<void> clearRewardedVideoServerParams() async {
    return _channel.invokeMethod('clearRewardedVideoServerParams');
  }

  /// Sets the RewardedVideo Manual Load mode.
  /// - [listener] will receive ad load status updates.
  /// - __Note__: Must be called before [init].
  ///
  /// Native SDK Reference
  /// - Android: setManualLoadRewardedVideo
  /// -     iOS: setRewardedVideoManualDelegate
  static Future<void> setManualLoadRewardedVideo(
      IronSourceRewardedVideoManualListener? listener) async {
    IronSourceMethodCallHandler.setRewardedVideoManualListener(listener);
    return _channel.invokeMethod('setManualLoadRewardedVideo');
  }

  /// Starts the RewardedVideo load process.
  /// - The RV Manual Load mode must be enabled via [setManualLoadRewardedVideo].
  ///
  /// Native SDK Reference
  /// - Android: loadRewardedVideo
  /// -     iOS: loadRewardedVideo
  static Future<void> loadRewardedVideo() async {
    return _channel.invokeMethod('loadRewardedVideo');
  }

  /** Interstitial API =====================================================================================*/

  /// Starts the Iinterstitial load process.
  /// - Load status updates will be notified to [IronSourceInterstitialListener]
  ///
  /// Native SDK Reference
  /// - Android: loadInterstitial
  /// -     iOS: loadInterstitial
  static Future<void> loadInterstitial() async {
    return _channel.invokeMethod('loadInterstitial');
  }

  /// Shows an Interstitial ad.
  /// - The Ad Placement could be specified by [placementName].
  ///
  /// Native SDK Reference
  /// - Android: showInterstitial
  /// -     iOS: showInterstitialWithViewController
  static Future<void> showInterstitial({String? placementName}) async {
    final args = OutgoingValueParser.showInterstitial(placementName);
    return _channel.invokeMethod('showInterstitial', args);
  }

  /// Returns the Interstitial availability.
  ///
  /// Native SDK Reference
  /// - Android: isInterstitialReady
  /// -     iOS: hasInterstitial
  static Future<bool> isInterstitialReady() async {
    final bool isISReady = await _channel.invokeMethod('isInterstitialReady');
    return isISReady;
  }

  /// Returns the capping state of an ad placement named [placementName].
  ///
  /// Native SDK Reference
  /// - Android: isInterstitialPlacementCapped
  /// -     iOS: isInterstitialCappedForPlacement
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
  /// - Load status updates will be notified to [IronSourceBannerListener].
  ///
  /// Native SDK Reference
  /// - Android: loadBanner
  /// -     iOS: loadBannerWithViewController
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
  static Future<void> destroyBanner() async {
    return _channel.invokeMethod('destroyBanner');
  }

  /// Changes the visibility of loaded Banner to visible.
  static Future<void> displayBanner() async {
    return _channel.invokeMethod('displayBanner');
  }

  /// Changes the visibility of loaded Banner to invisible.
  /// - Reloading does not take place while it's hidden.
  static Future<void> hideBanner() async {
    return _channel.invokeMethod('hideBanner');
  }

  /// Returns the capping state of an ad placement named [placementName].
  ///
  /// Native SDK Reference
  /// - Android: isBannerPlacementCapped
  /// -     iOS: isBannerCappedForPlacement
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
  static Future<double> getMaximalAdaptiveHeight(int width) async {
    final args = OutgoingValueParser.getMaximalAdaptiveHeight(width);
    final double adaptiveHeight = await _channel.invokeMethod('getMaximalAdaptiveHeight', args);
    return adaptiveHeight;
  }

  /** OfferWall API =====================================================================================*/

  /// Shows an Offerwall.
  /// - The Placement could be specified by [placementName].
  ///
  /// Native SDK Reference
  /// - Android: showOfferwall
  /// -     iOS: showOfferwallWithViewController
  static Future<void> showOfferwall({String? placementName}) async {
    final args = OutgoingValueParser.showOfferwall(placementName);
    return _channel.invokeMethod('showOfferwall', args);
  }

  /// Start fetching the current OfferWall credits.
  /// - The fetched credit info will be passed to [IronSourceOfferwallListener]
  ///
  /// Native SDK Reference
  /// - Android: getOfferwallCredits
  /// -     iOS: offerwallCredits
  static Future<void> getOfferwallCredits() async {
    return _channel.invokeMethod('getOfferwallCredits');
  }

  /// Returns the OfferWall availability.
  ///
  /// Native SDK Reference
  /// - Android: isOfferwallAvailable
  /// -     iOS: hasOfferwall
  static Future<bool> isOfferwallAvailable() async {
    final bool isAvailable =
        await _channel.invokeMethod('isOfferwallAvailable');
    return isAvailable;
  }

  /** OfferWall Config API ==============================================================================*/

  /// Sets the OW client side automatic polling mode.
  /// - __Note__: Must be called before [init].
  ///
  /// Native SDK Reference
  /// - Android: setClientSideCallbacks
  /// -     iOS: setUseClientSideCallbacks
  static Future<void> setClientSideCallbacks(bool isEnabled) async {
    final args = OutgoingValueParser.setClientSideCallbacks(isEnabled);
    return _channel.invokeMethod('setClientSideCallbacks', args);
  }

  /// Registers the custom [parameters] that will be passed in OfferWall server-to-server callbacks.
  /// - __Note__: Must be called before [init].
  ///
  /// Native SDK Reference
  /// - Android: setOfferwallCustomParams
  /// -     iOS: setOfferwallCustomParameters
  static Future<void> setOfferwallCustomParams(
      Map<String, String> parameters) async {
    final args = OutgoingValueParser.setOfferwallCustomParams(parameters);
    return _channel.invokeMethod('setOfferwallCustomParams', args);
  }

  /** iOS ConversionValue API ====================================================================*/

  /// Returns the current conversion value.
  /// - Returns null if the current platform is Android.
  ///
  /// Native SDK Reference
  /// - iOS: getConversionValue
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
  static Future<void> showConsentViewWithType(String consentViewType) async {
    if (!Platform.isIOS) {
      return;
    }
    final args = OutgoingValueParser.showConsentViewWithType(consentViewType);
    return _channel.invokeMethod('showConsentViewWithType', args);
  }

  // Listener setters

  static void setRewardedVideoListener(
      IronSourceRewardedVideoListener? listener) {
    IronSourceMethodCallHandler.setRewardedVideoListener(listener);
  }

  @Deprecated(
      "'setRVListener' is deprecated and shouldn't be used. This API has been deprecated as of SDK 7.3.0. Please use setLevelPlayRewardedVideoListener instead")
  static void setRVListener(IronSourceRewardedVideoListener? listener) {
    IronSourceMethodCallHandler.setRVListener(listener);
  }

  static void setInterstitialListener(
      IronSourceInterstitialListener? listener) {
    IronSourceMethodCallHandler.setInterstitialListener(listener);
  }

  @Deprecated(
      "'setISListener' is deprecated and shouldn't be used. This API has been deprecated as of SDK 7.3.0. Please use setLevelPlayInterstitialListener instead")
  static void setISListener(IronSourceInterstitialListener? listener) {
    IronSourceMethodCallHandler.setISListener(listener);
  }

  static void setBannerListener(IronSourceBannerListener? listener) {
    IronSourceMethodCallHandler.setBannerListener(listener);
  }

  @Deprecated(
      "'setBNListener' is deprecated and shouldn't be used. This API has been deprecated as of SDK 7.3.0. Please use setLevelPlayBannerListener instead")
  static void setBNListener(IronSourceBannerListener? listener) {
    IronSourceMethodCallHandler.setBNListener(listener);
  }

  static void setOfferWallListener(IronSourceOfferwallListener? listener) {
    IronSourceMethodCallHandler.setOfferWallListener(listener);
  }

  @Deprecated(
      "'setOWListener' is deprecated and shouldn't be used. This API has been deprecated as of SDK 7.3.0. Please use setLevelPlayOfferWallListener instead")
  static void setOWListener(IronSourceOfferwallListener? listener) {
    IronSourceMethodCallHandler.setOWListener(listener);
  }

  static void setImpressionDataListener(
      IronSourceImpressionDataListener? listener) {
    IronSourceMethodCallHandler.setImpressionDataListener(listener);
  }

  static void setConsentViewListener(IronSourceConsentViewListener? listener) {
    IronSourceMethodCallHandler.setConsentViewListener(listener);
  }

  static void setLevelPlayRewardedVideoListener(
      LevelPlayRewardedVideoListener? listener) {
    IronSourceMethodCallHandler.setLevelPlayRewardedVideoListener(listener);
  }

  static void setLevelPlayRewardedVideoManualListener(
      LevelPlayRewardedVideoManualListener? listener) {
    IronSourceMethodCallHandler.setLevelPlayRewardedVideoManualListener(
        listener);
  }

  static void setLevelPlayInterstitialListener(
      LevelPlayInterstitialListener? listener) {
    IronSourceMethodCallHandler.setLevelPlayInterstitialListener(listener);
  }

  static void setLevelPlayBannerListener(LevelPlayBannerListener? listener) {
    IronSourceMethodCallHandler.setLevelPlayBannerListener(listener);
  }
}
