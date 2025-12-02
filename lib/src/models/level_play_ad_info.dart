import './level_play_ad_size.dart';

/// Represents detailed information about a LevelPlay ad.
class LevelPlayAdInfo {
  /// The unique identifier of the ad object.
  final String adId;

  /// The unique identifier of the ad unit.
  final String adUnitId;

  /// The name of the ad unit.
  final String adUnitName;

  /// The size of the ad.
  /// This can be null if the ad size is not applicable or not provided.
  final LevelPlayAdSize? adSize;

  /// The format of the ad (e.g., BANNER, INTERSTITIAL, REWARDED, NATIVE_AD).
  final String adFormat;

  /// The name of the placement where the ad was shown.
  final String placementName;

  /// The unique identifier for the auction in which the ad was won.
  final String auctionId;

  /// The country where the ad was displayed.
  final String country;

  /// A/B testing group identifier.
  final String ab;

  /// The name of the segment in which the user falls.
  final String segmentName;

  /// The name of the ad network that served the ad.
  final String adNetwork;

  /// The name of the ad instance.
  final String instanceName;

  /// The identifier of the ad instance.
  final String instanceId;

  /// The revenue earned from the ad impression.
  final double revenue;

  /// The precision of the revenue amount.
  final String precision;

  /// The encrypted cost per thousand impressions (CPM).
  final String encryptedCPM;

  /// The conversion value attributed to this impression, used for SKAdNetwork.
  final double? conversionValue;

  /// The unique identifier of the creative that was displayed.
  final String creativeId;

  LevelPlayAdInfo({
    required this.adId,
    required this.adUnitId,
    required this.adUnitName,
    this.adSize,
    required this.adFormat,
    required this.placementName,
    required this.auctionId,
    required this.country,
    required this.ab,
    required this.segmentName,
    required this.adNetwork,
    required this.instanceName,
    required this.instanceId,
    required this.revenue,
    required this.precision,
    required this.encryptedCPM,
    this.conversionValue,
    required this.creativeId,
  });

  Map<String, dynamic> toMap() {
    return {
      'adId': adId,
      'adUnitId': adUnitId,
      'adUnitName': adUnitName,
      'adSize': adSize?.toMap(),
      'adFormat': adFormat,
      'placementName': placementName,
      'auctionId': auctionId,
      'country': country,
      'ab': ab,
      'segmentName': segmentName,
      'adNetwork': adNetwork,
      'instanceName': instanceName,
      'instanceId': instanceId,
      'revenue': revenue,
      'precision': precision,
      'encryptedCPM': encryptedCPM,
      'conversionValue': conversionValue,
      'creativeId': creativeId,
    };
  }

  factory LevelPlayAdInfo.fromMap(dynamic args) {
    return LevelPlayAdInfo(
      adId: args['adId'] as String,
      adUnitId: args['adUnitId'] as String,
      adUnitName: args['adUnitName'] as String,
      adSize: args['adSize'] != null
          ? LevelPlayAdSize.fromMap(args['adSize'])
          : null,
      adFormat: args['adFormat'] as String,
      placementName: args['placementName'] as String,
      auctionId: args['auctionId'] as String,
      country: args['country'] as String,
      ab: args['ab'] as String,
      segmentName: args['segmentName'] as String,
      adNetwork: args['adNetwork'] as String,
      instanceName: args['instanceName'] as String,
      instanceId: args['instanceId'] as String,
      revenue: args['revenue'] as double,
      precision: args['precision'] as String,
      encryptedCPM: args['encryptedCPM'] as String,
      conversionValue: args['conversionValue'] as double?,
      creativeId: args['creativeId'] as String,
    );
  }

  @override
  String toString() {
    return 'LevelPlayAdInfo{'
        'adId=$adId'
        ', adUnitId=$adUnitId'
        ', adUnitName=$adUnitName'
        ', adSize=${adSize.toString()}'
        ', adFormat=$adFormat'
        ', placementName=$placementName'
        ', auctionId=$auctionId'
        ', country=$country'
        ', ab=$ab'
        ', segmentName=$segmentName'
        ', adNetwork=$adNetwork'
        ', instanceName=$instanceName'
        ', instanceId=$instanceId'
        ', revenue=$revenue'
        ', precision=$precision'
        ', encryptedCPM=$encryptedCPM'
        ', conversionValue=$conversionValue'
        ', creativeId=$creativeId'
        '}';
  }

  /// Equality overrides
  @override
  bool operator ==(other) {
    return (other is LevelPlayAdInfo) &&
        other.adId == adId &&
        other.adUnitId == adUnitId &&
        other.adUnitName == adUnitName &&
        other.adSize == adSize &&
        other.adFormat == adFormat &&
        other.placementName == placementName &&
        other.auctionId == auctionId &&
        other.country == country &&
        other.ab == ab &&
        other.segmentName == segmentName &&
        other.adNetwork == adNetwork &&
        other.instanceName == instanceName &&
        other.instanceId == instanceId &&
        other.revenue == revenue &&
        other.precision == precision &&
        other.encryptedCPM == encryptedCPM &&
        other.conversionValue == conversionValue &&
        other.creativeId == creativeId;
  }

  @override
  int get hashCode =>
      adId.hashCode ^
      adUnitId.hashCode ^
      adUnitName.hashCode ^
      adSize.hashCode ^
      adFormat.hashCode ^
      placementName.hashCode ^
      auctionId.hashCode ^
      country.hashCode ^
      ab.hashCode ^
      segmentName.hashCode ^
      adNetwork.hashCode ^
      instanceName.hashCode ^
      instanceId.hashCode ^
      revenue.hashCode ^
      precision.hashCode ^
      encryptedCPM.hashCode ^
      conversionValue.hashCode ^
      creativeId.hashCode;
}
