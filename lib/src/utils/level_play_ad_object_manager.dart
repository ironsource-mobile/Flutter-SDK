import 'package:flutter/services.dart';

import './level_play_method_channel.dart';
import '../models/level_play_interstitial_ad.dart';
import '../models/level_play_rewarded_ad.dart';

class LevelPlayAdObjectManager {
  /// Singleton instance
  static final LevelPlayAdObjectManager _instance = LevelPlayAdObjectManager._internal();

  /// Channel
  static final MethodChannel _channel = LevelPlayMethodChannel().channel;

  /// Ad cache
  final Map<int, LevelPlayInterstitialAd> interstitialAdsMap = <int, LevelPlayInterstitialAd>{};
  final Map<int, LevelPlayRewardedAd> rewardedAdsMap = <int, LevelPlayRewardedAd>{};

  /// Ad object id
  int _adObjectId = 0;

  /// Private constructor
  LevelPlayAdObjectManager._internal();

  /// Factory constructor to return the singleton instance
  factory LevelPlayAdObjectManager() {
    return _instance;
  }

  /// Interstitial Ad

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

  /// Rewarded Ad

  Future<void> loadRewardedAd(LevelPlayRewardedAd rewardedAd) async {
    final adObjectId = rewardedAd.adObjectId;
    final adUnitId = rewardedAd.adUnitId;
    if (!rewardedAdsMap.containsKey(adObjectId)) {
      rewardedAdsMap[adObjectId] = rewardedAd;
    }
    return await _channel.invokeMethod('loadRewardedAd', { 'adObjectId': adObjectId, 'adUnitId': adUnitId });
  }

  Future<void> showRewardedAd(int adObjectId, String placementName) async {
    if (rewardedAdsMap.containsKey(adObjectId)) {
      await _channel.invokeMethod('showRewardedAd', { 'adObjectId': adObjectId, 'placementName': placementName });
    }
  }

  Future<bool> isRewardedAdReady(int adObjectId) async {
    try {
      return await _channel.invokeMethod<bool>('isRewardedAdReady', { 'adObjectId': adObjectId }) ?? false;
    } on PlatformException catch (_) {
      return false;
    }
  }

  /// Shared Methods

  Future<void> disposeAd(int adObjectId) async {
    bool wasRemoved = false;

    // Check and remove from interstitial ads map
    if (interstitialAdsMap.containsKey(adObjectId)) {
      interstitialAdsMap.remove(adObjectId);
      wasRemoved = true;
    }

    // Check and remove from rewarded ads map
    if (rewardedAdsMap.containsKey(adObjectId)) {
      rewardedAdsMap.remove(adObjectId);
      wasRemoved = true;
    }

    // Only invoke the channel method if the adObjectId was present in any map
    if (wasRemoved) {
      await _channel.invokeMethod('disposeAd', { 'adObjectId': adObjectId });
    }
  }

  Future<void> disposeAllAds() async {
    interstitialAdsMap.clear();
    rewardedAdsMap.clear();
    await _channel.invokeMethod('disposeAllAds');
  }

  int generateAdObjectId() {
    return _adObjectId++;
  }
}
