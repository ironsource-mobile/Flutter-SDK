/// Placement for RV
@Deprecated(
    "This class has been deprecated as of SDK 7.3.0. Please use IronSourceRewardedVideoPlacement instead.")
class IronSourceRVPlacement {
  final String placementName;
  final String rewardName;
  final int rewardAmount;

  IronSourceRVPlacement({
    required this.placementName,
    required this.rewardName,
    required this.rewardAmount,
  });

  @override
  String toString() {
    return 'placementName: $placementName,'
        ' rewardName:$rewardName,'
        ' rewardAmount:$rewardAmount';
  }

  /// Equality overrides
  @override
  bool operator ==(other) {
    return (other is IronSourceRVPlacement) &&
        other.placementName == placementName &&
        other.rewardName == rewardName &&
        other.rewardAmount == rewardAmount;
  }

  @override
  int get hashCode =>
      placementName.hashCode ^ rewardName.hashCode ^ rewardAmount.hashCode;
}
