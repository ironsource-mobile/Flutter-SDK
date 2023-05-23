/// For LevelPlayListeners
class IronSourceAdInfo {
  final String? auctionId;
  final String? adUnit;
  final String? adNetwork;
  final String? instanceName;
  final String? instanceId;
  final String? country;
  final double? revenue;
  final String? precision;
  final String? ab;
  final String? segmentName;
  final String? encryptedCPM;

  IronSourceAdInfo(
      {this.auctionId,
      this.adUnit,
      this.adNetwork,
      this.instanceName,
      this.instanceId,
      this.country,
      this.revenue,
      this.precision,
      this.ab,
      this.segmentName,
      this.encryptedCPM});

  @override
  String toString() {
    return 'IronSourceAdInfo{'
        'auctionId=$auctionId'
        ', adUnit=$adUnit'
        ', adNetwork=$adNetwork'
        ', instanceName=$instanceName'
        ', instanceId=$instanceId'
        ', country=$country'
        ', revenue=$revenue'
        ', precision=$precision'
        ', ab=$ab'
        ', segmentName=$segmentName'
        ', encryptedCPM=$encryptedCPM'
        '}';
  }

  /// Equality overrides
  @override
  bool operator ==(other) {
    return (other is IronSourceAdInfo) &&
        other.auctionId == auctionId &&
        other.adUnit == adUnit &&
        other.adNetwork == adNetwork &&
        other.instanceName == instanceName &&
        other.instanceId == instanceId &&
        other.country == country &&
        other.revenue == revenue &&
        other.precision == precision &&
        other.ab == ab &&
        other.segmentName == segmentName &&
        other.encryptedCPM == encryptedCPM;
  }

  @override
  int get hashCode =>
      auctionId.hashCode ^
      adUnit.hashCode ^
      adNetwork.hashCode ^
      instanceName.hashCode ^
      instanceId.hashCode ^
      country.hashCode ^
      revenue.hashCode ^
      precision.hashCode ^
      ab.hashCode ^
      segmentName.hashCode ^
      encryptedCPM.hashCode;
}
