import 'dart:async';

import './utils/level_play_method_channel.dart';
import './utils/ironsource_method_call_handler.dart';
import './utils/ironsource_constants.dart';
import './models/models.dart';

class LevelPlay {
  static final _channel = LevelPlayMethodChannel().channel;
  static String? _flutterVersion;

  /** Utils ======================================================================================*/

  /// Returns the plugin version.
  static String getPluginVersion() { return IronConst.PLUGIN_VERSION; }

  /// Returns the native SDK version for [platform].
  /// - [platform] should be either 'android' or 'ios'.
  static String getNativeSDKVersion(String platform) {
    return platform == 'android' ? IronConst.ANDROID_SDK_VERSION : platform == 'ios' ? IronConst.IOS_SDK_VERSION : '';
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
    return _channel.invokeMethod('setDynamicUserId', {IronConstKey.USER_ID: dynamicUserId});
  }

  /// Enables debug logging on adapters/SDKs when [isEnabled] is true.
  ///
  /// Native SDK Reference
  /// - Android: setAdaptersDebug
  /// -     iOS: setAdaptersDebug
  static Future<void> setAdaptersDebug(bool isEnabled) async {
    return _channel.invokeMethod('setAdaptersDebug', {IronConstKey.IS_ENABLED: isEnabled});
  }

  /// Sets [isConsent] as the GDPR setting.
  /// - __Note__: Must be called before [init].
  ///
  /// Native SDK Reference
  /// - Android: setConsent
  /// -     iOS: setConsent
  static Future<void> setConsent(bool isConsent) async {
    return _channel.invokeMethod('setConsent', {IronConstKey.IS_CONSENT: isConsent});
  }

  /// Sets metadata with key-value pairs for custom configurations.
  ///
  /// Native SDK Reference
  /// - Android: setMetaData
  /// -     iOS: setMetaDataWithKey
  static Future<void> setMetaData(Map<String, List<String>> metaData) async {
    return _channel.invokeMethod('setMetaData', {IronConstKey.META_DATA: metaData});
  }

  /// Configures a user segment with specific attributes for targeting purposes.
  ///
  /// Native SDK Reference
  /// - Android: setSegment
  /// -     iOS: setSegment
  static Future<void> setSegment(LevelPlaySegment segment) async {
    return _channel.invokeMethod('setSegment', {IronConstKey.SEGMENT: segment.toMap()});
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
    IronSourceMethodCallHandler.addLevelPlayImpressionDataListener(listener);
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
      IronConstKey.PLUGIN_TYPE: IronConst.PLUGIN_TYPE,
      IronConstKey.PLUGIN_VERSION: IronConst.PLUGIN_VERSION,
    };
    if (_flutterVersion != null) {
      pluginData[IronConstKey.PLUGIN_FRAMEWORK_VERSION] = _flutterVersion!;
    }
    await _channel.invokeMethod('setPluginData', pluginData);

    IronSourceMethodCallHandler.setLevelPlayInitListener(initListener);
    return _channel.invokeMethod('init', initRequest.toMap());
  }
}
