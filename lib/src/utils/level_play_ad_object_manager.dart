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
  final Map<String, LevelPlayInterstitialAd> interstitialAdsMap = <String, LevelPlayInterstitialAd>{};
  final Map<String, LevelPlayRewardedAd> rewardedAdsMap = <String, LevelPlayRewardedAd>{};

  /// Ad object id
  @Deprecated('This field is deprecated and will be removed in 4.0.0 version. Use the adId property on ad objects instead.')
  int _adObjectId = 0;

  /// Private constructor
  LevelPlayAdObjectManager._internal();

  /// Factory constructor to return the singleton instance
  factory LevelPlayAdObjectManager() {
    return _instance;
  }

  /// Interstitial Ad

  Future<String> createInterstitialAd(LevelPlayInterstitialAd interstitialAd) async {
    // Build parameters map
    final Map<String, dynamic> params = {
      'adUnitId': interstitialAd.adUnitId,
    };

    if (interstitialAd.bidFloor != null) {
      params['bidFloor'] = interstitialAd.bidFloor;
    }

    // Invoke native method to create interstitial ad and get the ad identifier
    final adId = await _channel.invokeMethod('createInterstitialAd', params);
    // Store the ad instance in the map if it's not already present
    if (!interstitialAdsMap.containsKey(adId)) {
      // Assign the returned ID to the ad object
      interstitialAd.adId = adId;
      // Add the ad to the map using its ID as key for future reference
      interstitialAdsMap[adId] = interstitialAd;
    }
    return adId;
  }

  Future<void> loadInterstitialAd(LevelPlayInterstitialAd interstitialAd) async {
    final adId = interstitialAd.adId.isEmpty ?
      await createInterstitialAd(interstitialAd) : interstitialAd.adId;
    await _channel.invokeMethod('loadInterstitialAd', { 'adId': adId });
  }

  Future<void> showInterstitialAd(String adId, String placementName) async {
    if (interstitialAdsMap.containsKey(adId)) {
      await _channel.invokeMethod('showInterstitialAd', { 'adId': adId, 'placementName': placementName });
    }
  }

  Future<bool> isInterstitialAdReady(String adId) async {
    try {
      return await _channel.invokeMethod<bool>('isInterstitialAdReady', { 'adId': adId }) ?? false;
    } on PlatformException catch (_) {
      return false;
    }
  }

  /// Rewarded Ad

  Future<String> createRewardedAd(LevelPlayRewardedAd rewardedAd) async {
    // Build parameters map
    final Map<String, dynamic> params = {
      'adUnitId': rewardedAd.adUnitId,
    };

    if (rewardedAd.bidFloor != null) {
      params['bidFloor'] = rewardedAd.bidFloor;
    }

    // Invoke native method to create rewarded ad and get the ad identifier
    final adId = await _channel.invokeMethod('createRewardedAd', params);
    // Store the ad instance in the map if it's not already present
    if (!rewardedAdsMap.containsKey(adId)) {
      // Assign the returned ID to the ad object
        rewardedAd.adId = adId;
        // Add the ad to the map using its ID as key for future reference
        rewardedAdsMap[adId] = rewardedAd;
      }
      return adId;
    }

  Future<void> loadRewardedAd(LevelPlayRewardedAd rewardedAd) async {
    final adId = rewardedAd.adId.isEmpty ?
    await createRewardedAd(rewardedAd) : rewardedAd.adId;
    await _channel.invokeMethod('loadRewardedAd', { 'adId': adId });
    }

  Future<void> showRewardedAd(String adId, String placementName) async {
    if (rewardedAdsMap.containsKey(adId)) {
      await _channel.invokeMethod('showRewardedAd', { 'adId': adId, 'placementName': placementName });
    }
  }

  Future<bool> isRewardedAdReady(String adId) async {
    try {
      return await _channel.invokeMethod<bool>('isRewardedAdReady', { 'adId': adId }) ?? false;
    } on PlatformException catch (_) {
      return false;
    }
  }

  /// Shared Methods

  Future<void> disposeAd(String adId) async {
    bool wasRemoved = false;

    // Check and remove from interstitial ads map
    if (interstitialAdsMap.containsKey(adId)) {
      interstitialAdsMap.remove(adId);
      wasRemoved = true;
    }

    // Check and remove from rewarded ads map
    if (rewardedAdsMap.containsKey(adId)) {
      rewardedAdsMap.remove(adId);
      wasRemoved = true;
    }

    // Only invoke the channel method if the adObjectId was present in any map
    if (wasRemoved) {
      await _channel.invokeMethod('disposeAd', { 'adId': adId });
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
