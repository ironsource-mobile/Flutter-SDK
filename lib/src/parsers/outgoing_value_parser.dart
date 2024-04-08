import '../models/models.dart';
import '../ironsource_constants.dart';
import '../models/waterfall_configuration.dart';

/// To parse values to be passed from Flutter to the native side via [MethodChannel]
class OutgoingValueParser {
  // Base API //////////////////////////////////////////////////////////////////////////////////////

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

  /// Maps [waterfallConfiguration] to the key and returns the [Map].
  /// ```
  /// { 'waterfallConfiguration': Map<String, double> }
  /// ```
  static Map<String, dynamic> setWaterfallConfiguration(double? ceiling, double? floor, IronSourceAdUnit adUnit) {
    return {IronConstKey.WATERFALL_CONFIGURATION: <String, dynamic>{
      'ceiling': ceiling,
      'floor': floor,
      'adUnit': adUnit.parse()
    }};
  }

  // Init API //////////////////////////////////////////////////////////////////////////////////////

  /// Maps [appKey] and [adUnits] to the keys and returns the [Map].
  /// ```
  /// { 'appKey': String, 'adUnits': List<String>? }
  /// ```
  static Map<String, dynamic> init(
      {required String appKey, List<IronSourceAdUnit>? adUnits}) {
    final Map<String, dynamic> args = {IronConstKey.APP_KEY: appKey};
    if (adUnits != null && adUnits.isNotEmpty) {
      args[IronConstKey.AD_UNITS] =
          adUnits.map((unit) => unit.parse()).toList();
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

  // RV API ////////////////////////////////////////////////////////////////////////////////////////

  /// Maps [placementName] to the key if not null and returns the [Map].
  /// ```
  /// { 'placementName': String } || {}
  /// ```
  static Map<String, dynamic> showRewardedVideo(String? placementName) {
    return placementName != null
        ? {IronConstKey.PLACEMENT_NAME: placementName}
        : {};
  }

  /// Maps [placementName] to the key and returns the [Map].
  /// ```
  /// { 'placementName': String }
  /// ```
  static Map<String, dynamic> getRewardedVideoPlacementInfo(
      String placementName) {
    return {IronConstKey.PLACEMENT_NAME: placementName};
  }

  /// Maps [placementName] to the key and returns the [Map].
  /// ```
  /// { 'placementName': String }
  /// ```
  static Map<String, dynamic> isRewardedVideoPlacementCapped(
      String placementName) {
    return {IronConstKey.PLACEMENT_NAME: placementName};
  }

  /// Maps [parameters] to the key and returns the [Map].
  /// ```
  /// { 'parameters': Map<String, String> }
  /// ```
  static Map<String, dynamic> setRewardedVideoServerParams(
      Map<String, String> parameters) {
    return {IronConstKey.PARAMETERS: parameters};
  }

  // IS API ////////////////////////////////////////////////////////////////////////////////////////

  /// Maps [placementName] to the key if not null and returns the [Map].
  /// ```
  /// { 'placementName': String } || {}
  /// ```
  static Map<String, dynamic> showInterstitial(String? placementName) {
    return placementName != null
        ? {IronConstKey.PLACEMENT_NAME: placementName}
        : {};
  }

  /// Maps [placementName] to the key and returns the [Map].
  /// ```
  /// { 'placementName': String }
  /// ```
  static Map<String, dynamic> isInterstitialPlacementCapped(
      String placementName) {
    return {IronConstKey.PLACEMENT_NAME: placementName};
  }

  // BN API ////////////////////////////////////////////////////////////////////////////////////////

  /// Maps [size], [position], [offset], [placementName], [containerWidth], [containerHeight] to the keys and returns the [Map].
  /// ```
  /// {
  ///   'description': String,
  ///   'width': int,
  ///   'height': int,
  ///   'isAdaptive': bool,
  ///   'position': int,
  ///   'offset': int?
  ///   'placementName': String?
  ///   'containerWidth': int,
  ///   'containerHeight': int
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
      IronConstKey.CONTAINER_WIDTH: size.isContainerParams.width,
      IronConstKey.CONTAINER_HEIGHT: size.isContainerParams.height,
    };
    if (offset != null) params[IronConstKey.OFFSET] = offset;
    if (placementName != null) {
      params[IronConstKey.PLACEMENT_NAME] = placementName;
    }
    return params;
  }

  /// Maps [placementName] to the key and returns the [Map].
  /// ```
  /// { 'placementName': String }
  /// ```
  static Map<String, dynamic> isBannerPlacementCapped(String placementName) {
    return {IronConstKey.PLACEMENT_NAME: placementName};
  }

  /// Maps [width] to the key and returns the [Map].
  /// ```
  /// { 'width': Int }
  /// ```
  static Map<String, dynamic> getMaximalAdaptiveHeight(int width) {
    return {IronConstKey.WIDTH: width};
  }

  // OfferWall

  /// Maps [placementName] to the key if not null and returns the [Map].
  /// ```
  /// { 'placementName': String } || {}
  /// ```
  static Map<String, dynamic> showOfferwall(String? placementName) {
    return placementName != null
        ? {IronConstKey.PLACEMENT_NAME: placementName}
        : {};
  }

  // iOS14 ConsentView

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

  // Config API ////////////////////////////////////////////////////////////////////////////////////

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
  static Map<String, dynamic> setOfferwallCustomParams(
      Map<String, String> parameters) {
    return {IronConstKey.PARAMETERS: parameters};
  }

  // Internal Config API

  /// Maps [pluginType], [pluginVersion],
  /// and [pluginFrameworkVersion] to the key and returns the [Map].
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
