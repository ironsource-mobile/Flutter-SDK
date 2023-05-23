import '../ironsource_impression_data.dart';

/// Impression Level Revenue
abstract class IronSourceImpressionDataListener {
  /// Native SDK Reference
  /// - Android: onImpressionSuccess
  /// -     iOS: impressionDataDidSucceed
  void onImpressionSuccess(IronSourceImpressionData? impressionData);
}
