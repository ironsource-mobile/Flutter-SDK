import '../utils/level_play_ad_object_manager.dart';
import '../utils/level_play_method_channel.dart';
import './listeners/level_play_interstitial_ad_listener.dart';

/// Represents a LevelPlay interstitial ad.
class LevelPlayInterstitialAd {
  /// The ad unit id
  final String adUnitId;
  // The Ad id that is used to identify the ad object - replacing adObjectId
  String adId = "";

  /// Unique ad object id
  @Deprecated("This parameter will be removed in future sdk version, Please use [adId] instead.")
  late int adObjectId;

  /// A listener for interstitial ad events
  LevelPlayInterstitialAdListener? listener;

  /// The instance ad manager of the MADU interstitial ads
  final LevelPlayAdObjectManager _levelPlayAdObjectManager = LevelPlayAdObjectManager();

  /// The general plugin method channel
  static final _channel = LevelPlayMethodChannel().channel;

  /// Constructs an instance of [LevelPlayInterstitialAd].
  LevelPlayInterstitialAd({required this.adUnitId}) {
    adObjectId = _levelPlayAdObjectManager.generateAdObjectId();
  }

  /// Set the listener to handle ad events
  void setListener(LevelPlayInterstitialAdListener listener) {
    this.listener = listener;
  }

  /// Get the listener for handling ad events
  LevelPlayInterstitialAdListener? getListener() {
    return listener;
  }


  /// Return whether placement is capped or not.
  static Future<bool> isPlacementCapped(String placementName) async {
    return await _channel.invokeMethod('isInterstitialAdPlacementCapped', { "placementName": placementName });
  }

  /// Load the interstitial ad.
  Future<void> loadAd() async => await _levelPlayAdObjectManager.loadInterstitialAd(this);

  /// Show the interstitial ad.
  Future<void> showAd({String? placementName = ''}) async => await _levelPlayAdObjectManager.showInterstitialAd(adId, placementName ?? '');

  /// Check if the ad is ready, returns `false` if the ad is not ready.
  Future<bool> isAdReady() async => await _levelPlayAdObjectManager.isInterstitialAdReady(adId);

  /// Dispose of the interstitial ad instance
  Future<void> dispose() async => await _levelPlayAdObjectManager.disposeAd(adId);
}
