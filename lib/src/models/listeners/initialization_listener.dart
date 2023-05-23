/// Init Completion Listener
abstract class IronSourceInitializationListener {
  /// Invoked when the SDK completes the init process for the first time.
  /// - This callback is called only once per session after the first init.
  ///
  /// Native SDK Reference
  /// - Android: onInitializationComplete
  /// -     iOS: initializationDidComplete
  void onInitializationComplete();
}