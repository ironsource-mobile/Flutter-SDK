/// For LevelPlayListeners
class AdInfo {
  final String? auctionId;
  final String? adNetwork;
  final String? instanceName;
  final String? instanceId;
  final String? country;
  final double? revenue;
  final String? precision;
  final String? ab;
  final String? segmentName;
  final String? encryptedCPM;
  final double? conversionValue;

  AdInfo(
      {this.auctionId,
      this.adNetwork,
      this.instanceName,
      this.instanceId,
      this.country,
      this.revenue,
      this.precision,
      this.ab,
      this.segmentName,
      this.encryptedCPM,
      this.conversionValue});

  factory AdInfo.fromMap(dynamic args) {
    return AdInfo(
      auctionId: args['auctionId'] as String?,
      adNetwork: args['adNetwork'] as String?,
      instanceName: args['instanceName'] as String?,
      instanceId: args['instanceId'] as String?,
      country: args['country'] as String?,
      revenue: args['revenue'] as double?,
      precision: args['precision'] as String?,
      ab: args['ab'] as String?,
      segmentName: args['segmentName'] as String?,
      encryptedCPM: args['encryptedCPM'] as String?,
      conversionValue: args['conversionValue'] as double?,
    );
  }

  @override
  String toString() {
    return 'AdInfo{'
        'auctionId=$auctionId'
        ', adNetwork=$adNetwork'
        ', instanceName=$instanceName'
        ', instanceId=$instanceId'
        ', country=$country'
        ', revenue=$revenue'
        ', precision=$precision'
        ', ab=$ab'
        ', segmentName=$segmentName'
        ', encryptedCPM=$encryptedCPM'
        ', conversionValue=$conversionValue'
        '}';
  }

  /// Equality overrides
  @override
  bool operator ==(other) {
    return (other is AdInfo) &&
        other.auctionId == auctionId &&
        other.adNetwork == adNetwork &&
        other.instanceName == instanceName &&
        other.instanceId == instanceId &&
        other.country == country &&
        other.revenue == revenue &&
        other.precision == precision &&
        other.ab == ab &&
        other.segmentName == segmentName &&
        other.encryptedCPM == encryptedCPM &&
        other.conversionValue == conversionValue;
  }

  @override
  int get hashCode =>
      auctionId.hashCode ^
      adNetwork.hashCode ^
      instanceName.hashCode ^
      instanceId.hashCode ^
      country.hashCode ^
      revenue.hashCode ^
      precision.hashCode ^
      ab.hashCode ^
      segmentName.hashCode ^
      encryptedCPM.hashCode ^
      conversionValue.hashCode;
}

