import '../level_play_init_error.dart';
import '../level_play_configuration.dart';

/// Level Play Init Listener
abstract class LevelPlayInitListener {
  /// Invoked when the SDK fails to complete the init process.
  /// - This callback is called only once per session after the first init.
  ///
  /// Native SDK Reference
  /// - Android: onInitFailed
  /// -     iOS:
  void onInitFailed(LevelPlayInitError error);
  /// Invoked when the SDK completes the init process for the first time.
  /// - This callback is called only once per session after the first init.
  ///
  /// Native SDK Reference
  /// - Android: onInitSuccess
  /// -     iOS:
  void onInitSuccess(LevelPlayConfiguration configuration);
}