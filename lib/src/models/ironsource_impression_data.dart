/// For ILR data
class IronSourceImpressionData {
  String? auctionId;
  String? adUnit;
  String? country;
  String? ab;
  String? segmentName;
  String? placement;
  String? adNetwork;
  String? instanceName;
  String? instanceId;
  double? revenue;
  String? precision;
  double? lifetimeRevenue;
  String? encryptedCPM;

  IronSourceImpressionData(
      {this.auctionId,
      this.adUnit,
      this.country,
      this.ab,
      this.segmentName,
      this.placement,
      this.adNetwork,
      this.instanceName,
      this.instanceId,
      this.revenue,
      this.precision,
      this.lifetimeRevenue,
      this.encryptedCPM});

  @override
  String toString() {
    return 'ImpressionData{'
        'auctionId=$auctionId'
        ', adUnit=$adUnit'
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
        '}';
  }

  /// Equality overrides
  @override
  bool operator ==(other) {
    return (other is IronSourceImpressionData) &&
        other.auctionId == auctionId &&
        other.adUnit == adUnit &&
        other.country == country &&
        other.ab == ab &&
        other.segmentName == segmentName &&
        other.placement == placement &&
        other.adNetwork == adNetwork &&
        other.instanceName == instanceName &&
        other.instanceId == instanceId &&
        other.revenue == revenue &&
        other.precision == precision &&
        other.lifetimeRevenue == lifetimeRevenue &&
        other.encryptedCPM == encryptedCPM;
  }

  @override
  int get hashCode =>
      auctionId.hashCode ^
      adUnit.hashCode ^
      country.hashCode ^
      ab.hashCode ^
      segmentName.hashCode ^
      placement.hashCode ^
      adNetwork.hashCode ^
      instanceName.hashCode ^
      instanceId.hashCode ^
      revenue.hashCode ^
      precision.hashCode ^
      lifetimeRevenue.hashCode ^
      encryptedCPM.hashCode;
}
