import '../level_play_impression_data.dart';

/// Interface for handling LevelPlayImpressionData events
abstract class LevelPlayImpressionDataListener {
  /// Native SDK Reference
  /// - Android: onImpressionSuccess
  /// -     iOS: impressionDataDidSucceed
  void onImpressionSuccess(LevelPlayImpressionData impressionData);
}
