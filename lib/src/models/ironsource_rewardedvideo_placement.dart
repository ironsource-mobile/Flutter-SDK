import 'ironsource_rv_placement.dart';

/// Placement for RewardedVideo
class IronSourceRewardedVideoPlacement implements IronSourceRVPlacement {
  final String placementName;
  final String rewardName;
  final int rewardAmount;

  IronSourceRewardedVideoPlacement({
    required this.placementName,
    required this.rewardName,
    required this.rewardAmount,
  });

  @override
  String toString() {
    return 'IronSourceRewardedVideoPlacement{'
        'placementName:$placementName,'
        ' rewardName:$rewardName,'
        ' rewardAmount:$rewardAmount'
        '}';
  }

  /// Equality overrides
  @override
  bool operator ==(other) {
    return (other is IronSourceRewardedVideoPlacement) &&
        other.placementName == placementName &&
        other.rewardName == rewardName &&
        other.rewardAmount == rewardAmount;
  }

  @override
  int get hashCode =>
      placementName.hashCode ^ rewardName.hashCode ^ rewardAmount.hashCode;
}
