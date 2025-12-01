import '../utils/level_play_ad_object_manager.dart';
import '../utils/level_play_method_channel.dart';
import './listeners/level_play_rewarded_ad_listener.dart';

/// Represents a LevelPlay rewarded ad.
class LevelPlayRewardedAd {
  /// The ad unit id
  final String adUnitId;

  /// Unique ad object identifier
  String adId = "";

  /// A listener for rewarded ad events
  LevelPlayRewardedAdListener? listener;

  /// Optional bid floor
  double? bidFloor;

  /// The instance ad manager of the MADU interstitial & rewarded ads
  final LevelPlayAdObjectManager _levelPlayAdObjectManager = LevelPlayAdObjectManager();

  /// The general plugin method channel
  static final _channel = LevelPlayMethodChannel().channel;

  /// Constructs an instance of [LevelPlayRewardedAd].
  LevelPlayRewardedAd( {required this.adUnitId});

  /// Set the listener to handle ad events
  void setListener(LevelPlayRewardedAdListener listener) {
    this.listener = listener;
  }

  /// Get the listener for handling ad events
  LevelPlayRewardedAdListener? getListener() {
    return listener;
  }

  /// Set the bid floor
  void setBidFloor(double bidFloor) {
    this.bidFloor = bidFloor;
  }

  /// Get the bid floor value
  double? getBidFloor() {
    return bidFloor;
  }

  /// Return whether placement is capped or not.
  static Future<bool> isPlacementCapped(String placementName) async {
    return await _channel.invokeMethod('isRewardedAdPlacementCapped', { "placementName": placementName });
  }

  /// Load the rewarded ad.
  Future<void> loadAd() async => await _levelPlayAdObjectManager.loadRewardedAd(this);

  /// Show the rewarded ad.
  Future<void> showAd({String? placementName = ''}) async => await _levelPlayAdObjectManager.showRewardedAd(adId, placementName ?? '');

  /// Check if the ad is ready, returns `false` if the ad is not ready.
  Future<bool> isAdReady() async => await _levelPlayAdObjectManager.isRewardedAdReady(adId);

  /// Dispose of the rewarded ad instance
  Future<void> dispose() async => await _levelPlayAdObjectManager.disposeAd(adId);
}
