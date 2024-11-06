import 'dart:async';

import './utils/level_play_method_channel.dart';
import './utils/ironsource_method_call_handler.dart';
import './utils/ironsource_constants.dart';
import './models/models.dart';

class LevelPlay {
  static final _channel = LevelPlayMethodChannel().channel;

  /** Utils ======================================================================================*/

  /// Returns the plugin version.
  static String getPluginVersion() { return IronConst.PLUGIN_VERSION; }

  /// Returns the native SDK version for [platform].
  /// - [platform] should be either 'android' or 'ios'.
  static String getNativeSDKVersion(String platform) {
    return platform == 'android' ? IronConst.ANDROID_SDK_VERSION : platform == 'ios' ? IronConst.IOS_SDK_VERSION : '';
  }

  /** SDK Init API ===============================================================================*/

  /// Initializes the LevelPlay SDK with [appKey] for [adFormats].
  /// - It will initialize all [AdFormat] if [adFormats] was not passed.
  /// - Multiple calls for the same [adFormats] are not allowed.
  ///
  /// Native SDK Reference
  /// - Android: init
  /// -     iOS: initWith
  static Future<void> init({required LevelPlayInitRequest initRequest, required LevelPlayInitListener initListener}) async {
    IronSourceMethodCallHandler.setLevelPlayInitListener(initListener);
    return _channel.invokeMethod('initLevelPlay', initRequest.toMap());
  }
}
