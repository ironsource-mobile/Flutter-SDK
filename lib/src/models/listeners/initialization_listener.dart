/// Init Completion Listener
@Deprecated("This Listener will be removed in Flutter 4.0.0 version, Please use LevelPlayInitListener instead.")
abstract class IronSourceInitializationListener {
  /// Invoked when the SDK completes the init process for the first time.
  /// - This callback is called only once per session after the first init.
  ///
  /// Native SDK Reference
  /// - Android: onInitializationComplete
  /// -     iOS: initializationDidComplete
  @Deprecated("This method will be removed in Flutter 4.0.0 version, Please use onInitSuccess instead.")
  void onInitializationComplete();
}