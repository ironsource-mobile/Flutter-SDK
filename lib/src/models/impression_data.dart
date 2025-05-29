import 'dart:io';

/// ARM ImpressionData
/// see https://developers.is.com/ironsource-mobile/general/ad-revenue-measurement-postbacks/#step-2
///
/// Represents the data collected for an ad impression.
class ImpressionData {
  final String? auctionId;
  @Deprecated("This parameter will be removed in Flutter version 4.0.0. Please use [adFormat] instead.")
  final String? adUnit;
  final String? adUnitName;
  final String? adUnitId;
  final String? adFormat;
  final String? country;
  final String? ab;
  final String? segmentName;
  final String? placement;
  final String? adNetwork;
  final String? instanceName;
  final String? instanceId;
  final double? revenue;
  final String? precision;
  @Deprecated("This parameter will be removed in Flutter version 4.0.0.")
  final double? lifetimeRevenue;
  final String? encryptedCPM;
  final double? conversionValue; // Only for ios
  final String? creativeId;

  ImpressionData({
    required this.auctionId,
    required this.adUnit,
    required this.adUnitName,
    required this.adUnitId,
    required this.adFormat,
    required this.country,
    required this.ab,
    required this.segmentName,
    required this.placement,
    required this.adNetwork,
    required this.instanceName,
    required this.instanceId,
    required this.revenue,
    required this.precision,
    required this.lifetimeRevenue,
    required this.encryptedCPM,
    required this.conversionValue, // Only for ios
    required this.creativeId
  });

  Map<String, dynamic> toMap() {
    return {
      'auctionId': auctionId,
      'adUnit': adUnit,
      'adUnitName': adUnitName,
      'adUnitId': adUnitId,
      'adFormat': adFormat,
      'country': country,
      'ab': ab,
      'segmentName': segmentName,
      'placement': placement,
      'adNetwork': adNetwork,
      'instanceName': instanceName,
      'instanceId': instanceId,
      'revenue': revenue,
      'precision': precision,
      'lifetimeRevenue': lifetimeRevenue,
      'encryptedCPM': encryptedCPM,
      'conversionValue': conversionValue,
      'creativeId': creativeId
    };
  }

  factory ImpressionData.fromMap(dynamic args) {
    return ImpressionData(
      auctionId: args['auctionId'] as String?,
      adUnit: args['adUnit'] as String?,
      adUnitName: args['adUnitName'] as String?,
      adUnitId: args['adUnitId'] as String?,
      adFormat: args['adFormat'] as String?,
      country: args['country'] as String?,
      ab: args['ab'] as String?,
      segmentName: args['segmentName'] as String?,
      placement: args['placement'] as String?,
      adNetwork: args['adNetwork'] as String?,
      instanceName: args['instanceName'] as String?,
      instanceId: args['instanceId'] as String?,
      revenue: args['revenue'] as double?,
      precision: args['precision'] as String?,
      lifetimeRevenue: args['lifetimeRevenue'] as double?,
      encryptedCPM: args['encryptedCPM'] as String?,
      conversionValue: args['conversionValue'] as double?,
      creativeId: args['creativeId'] as String?
    );
  }

  @override
  String toString() {
    return 'ImpressionData{'
        'auctionId=$auctionId'
        ', adUnit=$adUnit'
        ', adUnitName=$adUnitName'
        ', adUnitId=$adUnitId'
        ', adFormat=$adFormat'
        ', country=$country'
        ', ab=$ab'
        ', segmentName=$segmentName'
        ', placement=$placement'
        ', adNetwork=$adNetwork'
        ', instanceName=$instanceName'
        ', instanceId=$instanceId'
        ', revenue=$revenue'
        ', precision=$precision'
        ', lifetimeRevenue=$lifetimeRevenue'
        ', encryptedCPM=$encryptedCPM'
        '${Platform.isIOS ? ', conversionValue=$conversionValue' : ''}'
        ', creativeId=$creativeId'
        '}';
  }

  /// Equality overrides
  @override
  bool operator ==(other) {
    return (other is ImpressionData) &&
        other.auctionId == auctionId &&
        other.adUnitName == adUnitName &&
        other.adUnitId == adUnitId &&
        other.adFormat == adFormat &&
        other.country == country &&
        other.ab == ab &&
        other.segmentName == segmentName &&
        other.placement == placement &&
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
      auctionId.hashCode ^
      adUnitName.hashCode ^
      adUnitId.hashCode ^
      adFormat.hashCode ^
      country.hashCode ^
      ab.hashCode ^
      segmentName.hashCode ^
      placement.hashCode ^
      adNetwork.hashCode ^
      instanceName.hashCode ^
      instanceId.hashCode ^
      revenue.hashCode ^
      precision.hashCode ^
      encryptedCPM.hashCode ^
      conversionValue.hashCode ^
      creativeId.hashCode;
}
