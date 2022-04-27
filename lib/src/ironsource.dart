import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './ironsource_constants.dart';
import './ironsource_arg_parser.dart';
import './models/models.dart';

class IronSource {
  static final MethodChannel _channel = const MethodChannel(IronConst.METHOD_CHANNEL)
    ..setMethodCallHandler(handleMethodCall);
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
    final args = IronSourceArgParser.shouldTrackNetworkState(isEnabled);
    return _channel.invokeMethod('shouldTrackNetworkState', args);
  }

  /// Enables debug logging on adapters/SDKs when [isEnabled] is true.
  ///
  /// Native SDK Reference
  /// - Android: setAdaptersDebug
  /// -     iOS: setAdaptersDebug
  static Future<void> setAdaptersDebug(bool isEnabled) async {
    final args = IronSourceArgParser.setAdaptersDebug(isEnabled);
    return _channel.invokeMethod('setAdaptersDebug', args);
  }

  /// For RV server-to-server callbacks.
  /// - [dynamicUserId] must be set before [showRewardedVideo].
  ///
  /// Native SDK Reference
  /// - Android: setDynamicUserId
  /// -     iOS: setDynamicUserId
  static Future<void> setDynamicUserId(String dynamicUserId) async {
    final args = IronSourceArgParser.setDynamicUserId(dynamicUserId);
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
    final args = IronSourceArgParser.setConsent(isConsent);
    return _channel.invokeMethod('setConsent', args);
  }

  /// Registers [segment] data.
  ///
  /// Native SDK Reference
  /// - Android: setSegment
  /// -     iOS: setSegment
  static Future<void> setSegment(IronSourceSegment segment) async {
    final args = IronSourceArgParser.setSegment(segment);
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
    final args = IronSourceArgParser.setMetaData(metaData);
    return _channel.invokeMethod('setMetaData', args);
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
    final args = IronSourceArgParser.setUserId(userId);
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
    final pluginData = IronSourceArgParser.setPluginData(
        IronConst.PLUGIN_TYPE, IronConst.PLUGIN_VERSION, _flutterVersion);
    await _channel.invokeMethod('setPluginData', pluginData);

    if (initListener != null) {
      initializationListener = initListener;
    }

    // init
    final args = IronSourceArgParser.init(appKey: appKey, adUnits: adUnits);
    return _channel.invokeMethod('init', args);
  }

  /** RV API =====================================================================================*/

  /// Shows an Rewarded Video ad.
  /// - The Ad Placement could be specified by [placementName].
  ///
  /// Native SDK Reference
  /// - Android: showRewardedVideo
  /// -     iOS: showRewardedVideoWithViewController
  static Future<void> showRewardedVideo({String? placementName}) async {
    return _channel.invokeMethod(
        'showRewardedVideo', IronSourceArgParser.showRewardedVideo(placementName));
  }

  /// Returns an [IronSourceRVPlacement] instance if [placementName] matches.
  /// - Falls back to a Default placement when [placementName] matched with none.
  /// - Returns null if called before init finishes.
  ///
  /// Native SDK Reference
  /// - Android: getRewardedVideoPlacementInfo
  /// -     iOS: rewardedVideoPlacementInfo
  static Future<IronSourceRVPlacement?> getRewardedVideoPlacementInfo(
      {required String placementName}) async {
    final args = IronSourceArgParser.getRewardedVideoPlacementInfo(placementName);
    final placementInfo = await _channel.invokeMethod('getRewardedVideoPlacementInfo', args);
    return placementInfo != null ? ParserUtil.getRVPlacementFromArguments(placementInfo) : null;
  }

  /// Returns the RV availability.
  ///
  /// Native SDK Reference
  /// - Android: isRewardedVideoAvailable
  /// -     iOS: hasRewardedVideo
  static Future<bool> isRewardedVideoAvailable() async {
    final bool isAvailable = await _channel.invokeMethod('isRewardedVideoAvailable');
    return isAvailable;
  }

  /// Returns the capping state of an ad placement named [placementName].
  ///
  /// Native SDK Reference
  /// - Android: isRewardedVideoPlacementCapped
  /// -     iOS: isRewardedVideoCappedForPlacement
  static Future<bool> isRewardedVideoPlacementCapped({required String placementName}) async {
    final args = IronSourceArgParser.isRewardedVideoPlacementCapped(placementName);
    final bool isCapped = await _channel.invokeMethod('isRewardedVideoPlacementCapped', args);
    return isCapped;
  }

  /// Sets the custom [parameters] that will be passed in RV server-to-server callbacks.
  /// - Can be called multiple times per session.
  /// - __Note__: Must be called before [showRewardedVideo].
  ///
  /// Native SDK Reference
  /// - Android: setRewardedVideoServerParameters
  /// -     iOS: setRewardedVideoServerParameters
  static Future<void> setRewardedVideoServerParams(Map<String, String> parameters) async {
    final args = IronSourceArgParser.setRewardedVideoServerParams(parameters);
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

  /// Sets the RV Manual Load mode.
  /// - [listener] will receive ad load status updates.
  /// - __Note__: Must be called before [init].
  ///
  /// Native SDK Reference
  /// - Android: setManualLoadRewardedVideo
  /// -     iOS: setRewardedVideoManualDelegate
  static Future<void> setManualLoadRewardedVideo(
      IronSourceRewardedVideoManualListener listener) async {
    rewardedVideoManualListener = listener;
    return _channel.invokeMethod('setManualLoadRewardedVideo');
  }

  /// Starts the RV load process.
  /// - The RV Manual Load mode must be enabled via [setManualLoadRewardedVideo].
  ///
  /// Native SDK Reference
  /// - Android: loadRewardedVideo
  /// -     iOS: loadRewardedVideo
  static Future<void> loadRewardedVideo() async {
    return _channel.invokeMethod('loadRewardedVideo');
  }

  /** IS API =====================================================================================*/

  /// Starts the IS load process.
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
    final args = IronSourceArgParser.showInterstitial(placementName);
    return _channel.invokeMethod('showInterstitial', args);
  }

  /// Returns the IS availability.
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
  static Future<bool> isInterstitialPlacementCapped({required String placementName}) async {
    final args = IronSourceArgParser.isInterstitialPlacementCapped(placementName);
    final bool isCapped = await _channel.invokeMethod('isInterstitialPlacementCapped', args);
    return isCapped;
  }

  /** BN API =====================================================================================*/

  /// Starts the BN load process for [size] and [position].
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
    final args = IronSourceArgParser.loadBanner(size, position,
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
    final args = IronSourceArgParser.isBannerPlacementCapped(placementName);
    final bool isCapped = await _channel.invokeMethod('isBannerPlacementCapped', args);
    return isCapped;
  }

  /** OW API =====================================================================================*/

  /// Shows an Offerwall.
  /// - The Placement could be specified by [placementName].
  ///
  /// Native SDK Reference
  /// - Android: showOfferwall
  /// -     iOS: showOfferwallWithViewController
  static Future<void> showOfferwall({String? placementName}) async {
    final args = IronSourceArgParser.showOfferwall(placementName);
    return _channel.invokeMethod('showOfferwall', args);
  }

  /// Start fetching the current OW credits.
  /// - The fetched credit info will be passed to [IronSourceOfferwallListener]
  ///
  /// Native SDK Reference
  /// - Android: getOfferwallCredits
  /// -     iOS: offerwallCredits
  static Future<void> getOfferwallCredits() async {
    return _channel.invokeMethod('getOfferwallCredits');
  }

  /// Returns the OW availability.
  ///
  /// Native SDK Reference
  /// - Android: isOfferwallAvailable
  /// -     iOS: hasOfferwall
  static Future<bool> isOfferwallAvailable() async {
    final bool isAvailable = await _channel.invokeMethod('isOfferwallAvailable');
    return isAvailable;
  }

  /** OW Config API ==============================================================================*/

  /// Sets the OW client side automatic polling mode.
  /// - __Note__: Must be called before [init].
  ///
  /// Native SDK Reference
  /// - Android: setClientSideCallbacks
  /// -     iOS: setUseClientSideCallbacks
  static Future<void> setClientSideCallbacks(bool isEnabled) async {
    final args = IronSourceArgParser.setClientSideCallbacks(isEnabled);
    return _channel.invokeMethod('setClientSideCallbacks', args);
  }

  /// Registers the custom [parameters] that will be passed in OW server-to-server callbacks.
  /// - __Note__: Must be called before [init].
  ///
  /// Native SDK Reference
  /// - Android: setOfferwallCustomParams
  /// -     iOS: setOfferwallCustomParameters
  static Future<void> setOfferwallCustomParams(Map<String, String> parameters) async {
    final args = IronSourceArgParser.setOfferwallCustomParams(parameters);
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
    final int? conversionValue = await _channel.invokeMethod('getConversionValue');
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
    final args = IronSourceArgParser.loadConsentViewWithType(consentViewType);
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
    final args = IronSourceArgParser.showConsentViewWithType(consentViewType);
    return _channel.invokeMethod('showConsentViewWithType', args);
  }

  /** ---------------------------------------------------------------------------------------------/
   - Listeners and MethodCall handling                                                             /
   -----------------------------------------------------------------------------------------------*/

  /// Init listener
  @visibleForTesting
  static IronSourceInitializationListener? initializationListener;

  /// RV listener
  static IronSourceRewardedVideoListener? _rewardedVideoListener;

  static void setRVListener(IronSourceRewardedVideoListener? listener) {
    _rewardedVideoListener = listener;
  }

  /// RV Manual Load mode listener
  @visibleForTesting
  static IronSourceRewardedVideoManualListener? rewardedVideoManualListener;

  /// IS listener
  static IronSourceInterstitialListener? _interstitialListener;

  static void setISListener(IronSourceInterstitialListener? listener) {
    _interstitialListener = listener;
  }

  /// BN listener
  static IronSourceBannerListener? _bannerListener;

  static void setBNListener(IronSourceBannerListener? listener) {
    _bannerListener = listener;
  }

  /// OW listener
  static IronSourceOfferwallListener? _offerwallListener;

  static void setOWListener(IronSourceOfferwallListener? listener) {
    _offerwallListener = listener;
  }

  /// ILR listener
  static IronSourceImpressionDataListener? _impressionDataListener;

  static void setImpressionDataListener(IronSourceImpressionDataListener? listener) {
    _impressionDataListener = listener;
  }

  /// iOS Consent View listener
  static IronSourceConsentViewListener? _consentViewListener;

  static void setConsentViewListener(IronSourceConsentViewListener? listener) {
    _consentViewListener = listener;
  }

  /// Handles method calls from the native platform.
  /// - Triggers corresponding listener functions.
  @visibleForTesting
  static Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      /** Init completion ========================================================================*/
      case 'onInitializationComplete':
        return initializationListener?.onInitializationComplete();

      /** RV events ==============================================================================*/
      case 'onRewardedVideoAdOpened':
        _rewardedVideoListener?.onRewardedVideoAdOpened();
        rewardedVideoManualListener?.onRewardedVideoAdOpened();
        return;
      case 'onRewardedVideoAdClosed':
        _rewardedVideoListener?.onRewardedVideoAdClosed();
        rewardedVideoManualListener?.onRewardedVideoAdClosed();
        return;
      case 'onRewardedVideoAvailabilityChanged':
        _rewardedVideoListener?.onRewardedVideoAvailabilityChanged(
            IronSourceArgParser.onRewardedVideoAvailabilityChanged(call.arguments));
        rewardedVideoManualListener?.onRewardedVideoAvailabilityChanged(
            IronSourceArgParser.onRewardedVideoAvailabilityChanged(call.arguments));
        return;
      case 'onRewardedVideoAdRewarded':
        _rewardedVideoListener?.onRewardedVideoAdRewarded(
            IronSourceArgParser.onRewardedVideoAdRewarded(call.arguments));
        rewardedVideoManualListener?.onRewardedVideoAdRewarded(
            IronSourceArgParser.onRewardedVideoAdRewarded(call.arguments));
        return;
      case 'onRewardedVideoAdShowFailed':
        _rewardedVideoListener?.onRewardedVideoAdShowFailed(
            IronSourceArgParser.onRewardedVideoAdShowFailed(call.arguments));
        rewardedVideoManualListener?.onRewardedVideoAdShowFailed(
            IronSourceArgParser.onRewardedVideoAdShowFailed(call.arguments));
        return;
      case 'onRewardedVideoAdClicked':
        _rewardedVideoListener?.onRewardedVideoAdClicked(
            IronSourceArgParser.onRewardedVideoAdClicked(call.arguments));
        rewardedVideoManualListener?.onRewardedVideoAdClicked(
            IronSourceArgParser.onRewardedVideoAdClicked(call.arguments));
        return;
      case 'onRewardedVideoAdStarted':
        _rewardedVideoListener?.onRewardedVideoAdStarted();
        rewardedVideoManualListener?.onRewardedVideoAdStarted();
        return;
      case 'onRewardedVideoAdEnded':
        _rewardedVideoListener?.onRewardedVideoAdEnded();
        rewardedVideoManualListener?.onRewardedVideoAdEnded();
        return;

      /** Manual Load RV events ==================================================================*/
      case 'onRewardedVideoAdReady':
        return rewardedVideoManualListener?.onRewardedVideoAdReady();
      case 'onRewardedVideoAdLoadFailed':
        return rewardedVideoManualListener?.onRewardedVideoAdLoadFailed(
            IronSourceArgParser.onRewardedVideoAdLoadFailed(call.arguments));

      /** IS Events ==============================================================================*/
      case 'onInterstitialAdReady':
        return _interstitialListener?.onInterstitialAdReady();
      case 'onInterstitialAdLoadFailed':
        return _interstitialListener?.onInterstitialAdLoadFailed(
            IronSourceArgParser.onInterstitialAdLoadFailed(call.arguments));
      case 'onInterstitialAdOpened':
        return _interstitialListener?.onInterstitialAdOpened();
      case 'onInterstitialAdClosed':
        return _interstitialListener?.onInterstitialAdClosed();
      case 'onInterstitialAdShowSucceeded':
        return _interstitialListener?.onInterstitialAdShowSucceeded();
      case 'onInterstitialAdShowFailed':
        return _interstitialListener?.onInterstitialAdShowFailed(
            IronSourceArgParser.onInterstitialAdShowFailed(call.arguments));
      case 'onInterstitialAdClicked':
        return _interstitialListener?.onInterstitialAdClicked();

      /** BN Events ==============================================================================*/
      case 'onBannerAdLoaded':
        return _bannerListener?.onBannerAdLoaded();
      case 'onBannerAdLoadFailed':
        return _bannerListener
            ?.onBannerAdLoadFailed(IronSourceArgParser.onBannerAdLoadFailed(call.arguments));
      case 'onBannerAdClicked':
        return _bannerListener?.onBannerAdClicked();
      case 'onBannerAdScreenPresented':
        return _bannerListener?.onBannerAdScreenPresented();
      case 'onBannerAdScreenDismissed':
        return _bannerListener?.onBannerAdScreenDismissed();
      case 'onBannerAdLeftApplication':
        return _bannerListener?.onBannerAdLeftApplication();

      /** OW Events ==============================================================================*/
      case 'onOfferwallAvailabilityChanged':
        return _offerwallListener?.onOfferwallAvailabilityChanged(
            IronSourceArgParser.onOfferwallAvailabilityChanged(call.arguments));
      case 'onOfferwallOpened':
        return _offerwallListener?.onOfferwallOpened();
      case 'onOfferwallShowFailed':
        return _offerwallListener
            ?.onOfferwallShowFailed(IronSourceArgParser.onOfferwallShowFailed(call.arguments));
      case 'onOfferwallAdCredited':
        return _offerwallListener
            ?.onOfferwallAdCredited(IronSourceArgParser.onOfferwallAdCredited(call.arguments));
      case 'onGetOfferwallCreditsFailed':
        return _offerwallListener?.onGetOfferwallCreditsFailed(
            IronSourceArgParser.onGetOfferwallCreditsFailed(call.arguments));
      case 'onOfferwallClosed':
        return _offerwallListener?.onOfferwallClosed();

      /** ImpressionData Event ===================================================================*/
      case 'onImpressionSuccess':
        return _impressionDataListener
            ?.onImpressionSuccess(IronSourceArgParser.onImpressionSuccess(call.arguments));

      /** iOS14 ConsentView Event ================================================================*/
      case 'consentViewDidLoadSuccess':
        return _consentViewListener?.consentViewDidLoadSuccess(
            IronSourceArgParser.consentViewDidLoadSuccess(call.arguments));
      case 'consentViewDidFailToLoad':
        return _consentViewListener?.consentViewDidFailToLoad(
            IronSourceArgParser.consentViewDidFailToLoad(call.arguments));
      case 'consentViewDidShowSuccess':
        return _consentViewListener?.consentViewDidShowSuccess(
            IronSourceArgParser.consentViewDidShowSuccess(call.arguments));
      case 'consentViewDidFailToShow':
        return _consentViewListener?.consentViewDidFailToShow(
            IronSourceArgParser.consentViewDidFailToShow(call.arguments));
      case 'consentViewDidAccept':
        return _consentViewListener
            ?.consentViewDidAccept(IronSourceArgParser.consentViewDidAccept(call.arguments));

      default:
        throw UnimplementedError("Method not implemented: ${call.method}");
    }
  }
}
