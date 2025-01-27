import '../utils/level_play_ad_object_manager.dart';

abstract class LevelPlayAd {
  /// The instance ad manager of the MADU interstitial & rewarded ads
  final LevelPlayAdObjectManager _levelPlayAdObjectManager = LevelPlayAdObjectManager();

  /// The ad unit id
  final String adUnitId;

  /// Unique ad object id
  late int adObjectId;

  LevelPlayAd(this.adUnitId) {
    adObjectId = _levelPlayAdObjectManager.generateAdObjectId();
  }
}