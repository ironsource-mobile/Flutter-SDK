import '../ironsource_impression_data.dart';
import '../impression_data.dart';

/// Impression Level Revenue
@Deprecated("This method will be removed in future versions. Please use ImpressionDataListener instead.")
abstract class IronSourceImpressionDataListener {
  /// Native SDK Reference
  /// - Android: onImpressionSuccess
  /// -     iOS: impressionDataDidSucceed
  void onImpressionSuccess(IronSourceImpressionData? impressionData);
}

/// Impression Level Revenue
abstract class ImpressionDataListener {
  /// Native SDK Reference
  /// - Android: onImpressionSuccess
  /// -     iOS: impressionDataDidSucceed
  void onImpressionSuccess(ImpressionData? impressionData);
}
