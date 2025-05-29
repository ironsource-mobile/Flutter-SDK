import './impression_data.dart';
import './level_play_ad_size.dart';

/// Represents detailed information about a LevelPlay ad.
class LevelPlayAdInfo {
  final String adId;
  final String adUnitId;
  final String adFormat;
  final ImpressionData? impressionData;
  final LevelPlayAdSize? adSize;

  LevelPlayAdInfo({
    required this.adId,
    required this.adUnitId,
    required this.adFormat,
    this.impressionData,
    this.adSize
  });

  Map<String, dynamic> toMap() {
    return {
      'adId': adId,
      'adUnitId': adUnitId,
      'adFormat': adFormat,
      'impressionData': impressionData?.toMap(),
      'adSize': adSize?.toMap(),
    };
  }

  factory LevelPlayAdInfo.fromMap(dynamic args) {
    return LevelPlayAdInfo(
      adId: args['adId'] as String,
      adUnitId: args['adUnitId'] as String,
      adFormat: args['adFormat'] as String,
      impressionData: args['impressionData'] != null
          ? ImpressionData.fromMap(args['impressionData'])
          : null,
      adSize: args['adSize'] != null
          ? LevelPlayAdSize.fromMap(args['adSize'])
          : null,
    );
  }

  @override
  String toString() {
    return 'LevelPlayAdInfo{'
        'adId=$adId'
        ', adUnitId=$adUnitId'
        ', adFormat=$adFormat'
        ', impressionData=${impressionData.toString()}'
        ', adSize=${adSize.toString()}'
        '}';
  }

  /// Equality overrides
  @override
  bool operator ==(other) {
    return (other is LevelPlayAdInfo) &&
        other.adId == adId &&
        other.adUnitId == adUnitId &&
        other.adFormat == adFormat &&
        other.impressionData == impressionData &&
        other.adSize == adSize;
  }

  @override
  int get hashCode =>
      adId.hashCode ^
      adUnitId.hashCode ^
      adFormat.hashCode ^
      impressionData.hashCode ^
      adSize.hashCode;
}
