import './ironsource_constants.dart';
import './models/models.dart';

typedef ValueGetter<O, T> = T Function(O obj);

/// Handles argument parsing for MethodChannel calls
class IronSourceArgParser {
  /** Base API ===================================================================================*/

  /// Maps [isEnabled] to the key and returns the [Map].
  /// ```
  /// { 'isEnabled': bool }
  /// ```
  static Map<String, dynamic> shouldTrackNetworkState(bool isEnabled) {
    return {IronConstKey.IS_ENABLED: isEnabled};
  }

  /// Maps [isEnabled] to the key and returns the [Map].
  /// ```
  /// { 'isEnabled': bool }
  /// ```
  static Map<String, dynamic> setAdaptersDebug(bool isEnabled) {
    return {IronConstKey.IS_ENABLED: isEnabled};
  }

  /// Maps [dynamicUserId] to the key and returns the [Map].
  /// ```
  /// { 'userId': String }
  /// ```
  static Map<String, dynamic> setDynamicUserId(String dynamicUserId) {
    return {IronConstKey.USER_ID: dynamicUserId};
  }

  /// Maps [isConsent] to the key and returns the [Map].
  /// ```
  /// { 'isConsent': bool }
  /// ```
  static Map<String, dynamic> setConsent(bool isConsent) {
    return {IronConstKey.IS_CONSENT: isConsent};
  }

  /// Parses [segment] and maps to the key and returns the [Map].
  /// ```
  /// { 'segment': Map<String, dynamic> }
  /// ```
  static Map<String, dynamic> setSegment(IronSourceSegment segment) {
    return {IronConstKey.SEGMENT: segment.toMap()};
  }

  /// Maps [metaData] to the key and returns the [Map].
  /// ```
  /// { 'metaData': Map<String, List<String>> }
  /// ```
  static Map<String, dynamic> setMetaData(Map<String, List<String>> metaData) {
    return {IronConstKey.META_DATA: metaData};
  }

  /** Init API ===================================================================================*/

  /// Maps [appKey] and [adUnits] to the keys and returns the [Map].
  /// ```
  /// { 'appKey': String, 'adUnits': List<String>? }
  /// ```
  static Map<String, dynamic> init({required String appKey, List<IronSourceAdUnit>? adUnits}) {
    final Map<String, dynamic> args = {IronConstKey.APP_KEY: appKey};
    if (adUnits != null && adUnits.isNotEmpty) {
      args[IronConstKey.AD_UNITS] = adUnits.map((unit) => unit.parse()).toList();
    }
    return args;
  }

  /// Maps [userId] to the key and returns the [Map].
  /// ```
  /// { 'userId': String }
  /// ```
  static Map<String, dynamic> setUserId(String userId) {
    return {IronConstKey.USER_ID: userId};
  }

  /** RV API =====================================================================================*/

  /// Maps [placementName] to the key if not null and returns the [Map].
  /// ```
  /// { 'placementName': String } || {}
  /// ```
  static Map<String, dynamic> showRewardedVideo(String? placementName) {
    return placementName != null ? {IronConstKey.PLACEMENT_NAME: placementName} : {};
  }

  /// Maps [placementName] to the key and returns the [Map].
  /// ```
  /// { 'placementName': String }
  /// ```
  static Map<String, dynamic> getRewardedVideoPlacementInfo(String placementName) {
    return {IronConstKey.PLACEMENT_NAME: placementName};
  }

  /// Maps [placementName] to the key and returns the [Map].
  /// ```
  /// { 'placementName': String }
  /// ```
  static Map<String, dynamic> isRewardedVideoPlacementCapped(String placementName) {
    return {IronConstKey.PLACEMENT_NAME: placementName};
  }

  /// Maps [parameters] to the key and returns the [Map].
  /// ```
  /// { 'parameters': Map<String, String> }
  /// ```
  static Map<String, dynamic> setRewardedVideoServerParams(Map<String, String> parameters) {
    return {IronConstKey.PARAMETERS: parameters};
  }

  /** IS API =====================================================================================*/

  /// Maps [placementName] to the key if not null and returns the [Map].
  /// ```
  /// { 'placementName': String } || {}
  /// ```
  static Map<String, dynamic> showInterstitial(String? placementName) {
    return placementName != null ? {IronConstKey.PLACEMENT_NAME: placementName} : {};
  }

  /// Maps [placementName] to the key and returns the [Map].
  /// ```
  /// { 'placementName': String }
  /// ```
  static Map<String, dynamic> isInterstitialPlacementCapped(String placementName) {
    return {IronConstKey.PLACEMENT_NAME: placementName};
  }

  /** BN API =====================================================================================*/

  /// Maps [size], [position], [offset], and [placementName] to the keys and returns the [Map].
  /// ```
  /// {
  ///   'description': String,
  ///   'width': int,
  ///   'height': int,
  ///   'isAdaptive': bool,
  ///   'position': int,
  ///   'offset': int?
  ///   'placementName': String?
  /// }
  /// ```
  static Map<String, dynamic> loadBanner(
      IronSourceBannerSize size, IronSourceBannerPosition position,
      {int? offset, String? placementName}) {
    final params = {
      IronConstKey.DESCRIPTION: size.description,
      IronConstKey.WIDTH: size.width,
      IronConstKey.HEIGHT: size.height,
      IronConstKey.IS_ADAPTIVE: size.isAdaptive,
      IronConstKey.POSITION: position.toInt(),
    };
    if (offset != null) params[IronConstKey.OFFSET] = offset;
    if (placementName != null) params[IronConstKey.PLACEMENT_NAME] = placementName;
    return params;
  }

  /// Maps [placementName] to the key and returns the [Map].
  /// ```
  /// { 'placementName': String }
  /// ```
  static Map<String, dynamic> isBannerPlacementCapped(String placementName) {
    return {IronConstKey.PLACEMENT_NAME: placementName};
  }

  /** OW =========================================================================================*/

  /// Maps [placementName] to the key if not null and returns the [Map].
  /// ```
  /// { 'placementName': String } || {}
  /// ```
  static Map<String, dynamic> showOfferwall(String? placementName) {
    return placementName != null ? {IronConstKey.PLACEMENT_NAME: placementName} : {};
  }

  /** iOS14 ConsentView ==========================================================================*/

  /// Maps [consentViewType] to the key and returns the [Map].
  /// ```
  /// { 'consentViewType': String }
  /// ```
  static Map<String, dynamic> loadConsentViewWithType(String consentViewType) {
    return {IronConstKey.CONSENT_VIEW_TYPE: consentViewType};
  }

  /// Maps [consentViewType] to the key and returns the [Map].
  /// ```
  /// { 'consentViewType': String }
  /// ```
  static Map<String, dynamic> showConsentViewWithType(String consentViewType) {
    return {IronConstKey.CONSENT_VIEW_TYPE: consentViewType};
  }

  /** Listener callbacks =========================================================================*/

  /** RV =========================================================================================*/

  /// Parses [arguments] to [bool] and returns.
  static bool onRewardedVideoAvailabilityChanged(dynamic arguments) {
    return ParserUtil.getArgumentValueWithKey(IronConstKey.IS_AVAILABLE, arguments);
  }

  /// Parses [arguments] to [IronSourceRVPlacement] and returns.
  static IronSourceRVPlacement onRewardedVideoAdRewarded(dynamic arguments) {
    return ParserUtil.getRVPlacementFromArguments(arguments);
  }

  /// Parses [arguments] to [IronSourceError] and returns.
  static IronSourceError onRewardedVideoAdShowFailed(dynamic arguments) {
    return ParserUtil.getIronSourceErrorFromArguments(arguments);
  }

  /// Parses [arguments] to [IronSourceRVPlacement] and returns.
  static IronSourceRVPlacement onRewardedVideoAdClicked(dynamic arguments) {
    return ParserUtil.getRVPlacementFromArguments(arguments);
  }

  /// Parses [arguments] to [IronSourceError] and returns.
  static IronSourceError onRewardedVideoAdLoadFailed(dynamic arguments) {
    return ParserUtil.getIronSourceErrorFromArguments(arguments);
  }

  /** IS =========================================================================================*/

  /// Parses [arguments] to [IronSourceError] and returns.
  static IronSourceError onInterstitialAdLoadFailed(dynamic arguments) {
    return ParserUtil.getIronSourceErrorFromArguments(arguments);
  }

  /// Parses [arguments] to [IronSourceError] and returns.
  static IronSourceError onInterstitialAdShowFailed(dynamic arguments) {
    return ParserUtil.getIronSourceErrorFromArguments(arguments);
  }

  /** BN =========================================================================================*/

  /// Parses [arguments] to [IronSourceError] and returns.
  static IronSourceError onBannerAdLoadFailed(dynamic arguments) {
    return ParserUtil.getIronSourceErrorFromArguments(arguments);
  }

  /** OW =========================================================================================*/

  /// Parses [arguments] to [bool] and returns.
  static bool onOfferwallAvailabilityChanged(dynamic arguments) {
    return ParserUtil.getArgumentValueWithKey(IronConstKey.IS_AVAILABLE, arguments);
  }

  /// Parses [arguments] to [IronSourceOWCreditInfo] and returns.
  static IronSourceOWCreditInfo onOfferwallAdCredited(dynamic arguments) {
    final credits = ParserUtil.getArgumentValueWithKey<int>(IronConstKey.CREDITS, arguments);
    final totalCredits =
        ParserUtil.getArgumentValueWithKey<int>(IronConstKey.TOTAL_CREDITS, arguments);
    final totalCreditsFlag =
        ParserUtil.getArgumentValueWithKey<bool>(IronConstKey.TOTAL_CREDITS_FLAG, arguments);
    return IronSourceOWCreditInfo(
        credits: credits, totalCredits: totalCredits, totalCreditsFlag: totalCreditsFlag);
  }

  /// Parses [arguments] to [IronSourceError] and returns.
  static IronSourceError onOfferwallShowFailed(dynamic arguments) {
    return ParserUtil.getIronSourceErrorFromArguments(arguments);
  }

  /// Parses [arguments] to [IronSourceError] and returns.
  static IronSourceError onGetOfferwallCreditsFailed(dynamic arguments) {
    return ParserUtil.getIronSourceErrorFromArguments(arguments);
  }

  /** Impression Data ============================================================================*/

  /// Parses [arguments] to [IronSourceImpressionData] if not null and returns.
  static IronSourceImpressionData? onImpressionSuccess(dynamic arguments) {
    if (arguments == null) {
      return null;
    }
    final String? auctionId =
        ParserUtil.getArgumentValueWithKey<String?>(IronConstKey.AUCTION_ID, arguments);
    final String? adUnit =
        ParserUtil.getArgumentValueWithKey<String?>(IronConstKey.AD_UNIT, arguments);
    final String? country =
        ParserUtil.getArgumentValueWithKey<String?>(IronConstKey.COUNTRY, arguments);
    final String? ab = ParserUtil.getArgumentValueWithKey<String?>(IronConstKey.AB, arguments);
    final String? segmentName =
        ParserUtil.getArgumentValueWithKey<String?>(IronConstKey.SEGMENT_NAME, arguments);
    final String? placement =
        ParserUtil.getArgumentValueWithKey<String?>(IronConstKey.PLACEMENT, arguments);
    final String? adNetwork =
        ParserUtil.getArgumentValueWithKey<String?>(IronConstKey.AD_NETWORK, arguments);
    final String? instanceName =
        ParserUtil.getArgumentValueWithKey<String?>(IronConstKey.INSTANCE_NAME, arguments);
    final String? instanceId =
        ParserUtil.getArgumentValueWithKey<String?>(IronConstKey.INSTANCE_ID, arguments);
    final double? revenue =
        ParserUtil.getArgumentValueWithKey<double?>(IronConstKey.REVENUE, arguments);
    final String? precision =
        ParserUtil.getArgumentValueWithKey<String?>(IronConstKey.PRECISION, arguments);
    final double? lifetimeRevenue =
        ParserUtil.getArgumentValueWithKey<double?>(IronConstKey.LIFETIME_REVENUE, arguments);
    final String? encryptedCPM =
        ParserUtil.getArgumentValueWithKey<String?>(IronConstKey.ENCRYPTED_CPM, arguments);
    return IronSourceImpressionData(
      auctionId: auctionId,
      adUnit: adUnit,
      country: country,
      ab: ab,
      segmentName: segmentName,
      placement: placement,
      adNetwork: adNetwork,
      instanceName: instanceName,
      instanceId: instanceId,
      revenue: revenue,
      precision: precision,
      lifetimeRevenue: lifetimeRevenue,
      encryptedCPM: encryptedCPM,
    );
  }

  /** iOS14 ConsentView ==========================================================================*/

  /// Parses [arguments] to [String] and returns.
  static String consentViewDidLoadSuccess(dynamic arguments) {
    return ParserUtil.getArgumentValueWithKey<String?>(IronConstKey.CONSENT_VIEW_TYPE, arguments) ??
        "";
  }

  /// Parses [arguments] to [IronSourceConsentViewError] and returns.
  static IronSourceConsentViewError consentViewDidFailToLoad(dynamic arguments) {
    final error = ParserUtil.getIronSourceErrorFromArguments(arguments);
    final consentViewType =
        ParserUtil.getArgumentValueWithKey<String?>(IronConstKey.CONSENT_VIEW_TYPE, arguments) ??
            "";
    return IronSourceConsentViewError(
        errorCode: error.errorCode, message: error.message, consentViewType: consentViewType);
  }

  /// Parses [arguments] to [String] and returns.
  static String consentViewDidShowSuccess(dynamic arguments) {
    return ParserUtil.getArgumentValueWithKey<String?>(IronConstKey.CONSENT_VIEW_TYPE, arguments) ??
        "";
  }

  /// Parses [arguments] to [IronSourceConsentViewError] and returns.
  static IronSourceConsentViewError consentViewDidFailToShow(dynamic arguments) {
    final error = ParserUtil.getIronSourceErrorFromArguments(arguments);
    final consentViewType =
        ParserUtil.getArgumentValueWithKey<String?>(IronConstKey.CONSENT_VIEW_TYPE, arguments) ??
            "";
    return IronSourceConsentViewError(
        errorCode: error.errorCode, message: error.message, consentViewType: consentViewType);
  }

  /// Parses [arguments] to [String] and returns.
  static String consentViewDidAccept(dynamic arguments) {
    return ParserUtil.getArgumentValueWithKey<String?>(IronConstKey.CONSENT_VIEW_TYPE, arguments) ??
        "";
  }

  /** Config API =================================================================================*/

  /// Maps [isEnabled] to the key and returns the [Map].
  /// ```
  /// { 'isEnabled': bool }
  /// ```
  static Map<String, dynamic> setClientSideCallbacks(bool isEnabled) {
    return {IronConstKey.IS_ENABLED: isEnabled};
  }

  /// Maps [parameters] to the key and returns the [Map].
  /// ```
  /// { 'parameters': Map<String, String> }
  /// ```
  static Map<String, dynamic> setOfferwallCustomParams(Map<String, String> parameters) {
    return {IronConstKey.PARAMETERS: parameters};
  }

  /** Internal Config API ========================================================================*/

  /// Maps [pluginType], [pluginVersion], and [pluginFrameworkVersion] to the key and returns the [Map].
  /// ```
  /// {
  ///   'pluginType': String,
  ///   'pluginVersion': String,
  ///   'pluginFrameworkVersion': String,
  /// }
  /// ```
  static Map<String, dynamic> setPluginData(
      String pluginType, String pluginVersion, String? pluginFrameworkVersion) {
    final params = {
      IronConstKey.PLUGIN_TYPE: pluginType,
      IronConstKey.PLUGIN_VERSION: pluginVersion,
    };
    if (pluginFrameworkVersion != null) {
      params[IronConstKey.PLUGIN_FRAMEWORK_VERSION] = pluginFrameworkVersion;
    }
    return params;
  }
}

/// Util wrapper class
class ParserUtil {
  /// A [arguments] [Map] value retriever.
  /// - Throws [ArgumentError].
  static T getArgumentValueWithKey<T>(String key, dynamic arguments) {
    if (arguments == null) {
      throw ArgumentError('arguments is null');
    }
    if (!isNullable<T>() && arguments[key] == null) {
      throw ArgumentError('key: $key does not exist');
    }
    if (arguments[key] is! T) {
      throw ArgumentError('Value retrieved is not a type of ${T.toString()}');
    }
    return arguments[key] as T;
  }

  static bool isNullable<T>() => null is T;

  static T? nullOrValue<O, T>(O? obj, ValueGetter<O, T> f) => obj != null ? f(obj) : null;

  /// Parses [arguments] to [IronSourceRVPlacement] and returns.
  /// - Throws [ArgumentError] if [arguments] is null.
  static IronSourceRVPlacement getRVPlacementFromArguments(dynamic arguments) {
    final placementName = getArgumentValueWithKey<String>(IronConstKey.PLACEMENT_NAME, arguments);
    final rewardName = getArgumentValueWithKey<String>(IronConstKey.REWARD_NAME, arguments);
    final rewardAmount = getArgumentValueWithKey<int>(IronConstKey.REWARD_AMOUNT, arguments);
    return IronSourceRVPlacement(
        placementName: placementName, rewardName: rewardName, rewardAmount: rewardAmount);
  }

  /// Parses [arguments] to [IronSourceError] and returns.
  /// - [arguments] should not be null as [IronSourceError] object should be passed.
  /// - [errorCode] is int, so it cannot be null.
  static IronSourceError getIronSourceErrorFromArguments(dynamic arguments) {
    final errorCode = ParserUtil.getArgumentValueWithKey<int>(IronConstKey.ERROR_CODE, arguments);
    final message = ParserUtil.getArgumentValueWithKey<String?>(IronConstKey.MESSAGE, arguments);
    return IronSourceError(errorCode: errorCode, message: message);
  }
}
