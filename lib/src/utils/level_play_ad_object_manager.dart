import 'package:flutter/services.dart';
import './level_play_method_channel.dart';
import '../models/level_play_interstitial_ad.dart';

class LevelPlayAdObjectManager {
  /// Singleton instance
  static final LevelPlayAdObjectManager _instance = LevelPlayAdObjectManager._internal();

  /// Channel
  static final MethodChannel _channel = LevelPlayMethodChannel().channel;

  /// Ad cache
  final Map<int, LevelPlayInterstitialAd> interstitialAdsMap = <int, LevelPlayInterstitialAd>{};

  /// Ad object id
  int _adObjectId = 0;

  /// Private constructor
  LevelPlayAdObjectManager._internal();

  /// Factory constructor to return the singleton instance
  factory LevelPlayAdObjectManager() {
    return _instance;
  }

  Future<void> loadInterstitialAd(LevelPlayInterstitialAd interstitialAd) async {
    final adObjectId = interstitialAd.adObjectId;
    final adUnitId = interstitialAd.adUnitId;
    if (!interstitialAdsMap.containsKey(adObjectId)) {
      interstitialAdsMap[adObjectId] = interstitialAd;
    }
    return await _channel.invokeMethod('loadInterstitialAd', { 'adObjectId': adObjectId, 'adUnitId': adUnitId });
  }

  Future<void> showInterstitialAd(int adObjectId, String placementName) async {
    if (interstitialAdsMap.containsKey(adObjectId)) {
      await _channel.invokeMethod('showInterstitialAd', { 'adObjectId': adObjectId, 'placementName': placementName });
    }
  }

  Future<bool> isInterstitialAdReady(int adObjectId) async {
    try {
      return await _channel.invokeMethod<bool>('isInterstitialAdReady', { 'adObjectId': adObjectId }) ?? false;
    } on PlatformException catch (_) {
      return false;
    }
  }

  Future<void> disposeAd(int adObjectId) async {
    if (interstitialAdsMap.containsKey(adObjectId)) {
      interstitialAdsMap.remove(adObjectId);
      await _channel.invokeMethod('disposeAd', { 'adObjectId': adObjectId });
    }
  }

  Future<void> disposeAllAds() async {
    interstitialAdsMap.clear();
    await _channel.invokeMethod('disposeAllAds');
  }

  int generateAdObjectId() {
    return _adObjectId++;
  }
}
