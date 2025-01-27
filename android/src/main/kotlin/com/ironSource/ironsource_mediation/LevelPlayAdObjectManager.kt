package com.ironSource.ironsource_mediation

import android.app.Activity
import com.ironSource.ironsource_mediation.LevelPlayUtils.Companion.invokeMethodOnUiThread
import com.unity3d.mediation.LevelPlayAdError
import com.unity3d.mediation.LevelPlayAdInfo
import com.unity3d.mediation.interstitial.LevelPlayInterstitialAd
import com.unity3d.mediation.interstitial.LevelPlayInterstitialAdListener
import com.unity3d.mediation.rewarded.LevelPlayReward
import com.unity3d.mediation.rewarded.LevelPlayRewardedAd
import com.unity3d.mediation.rewarded.LevelPlayRewardedAdListener
import io.flutter.plugin.common.MethodChannel

class LevelPlayAdObjectManager(
    var activity: Activity?,
    private val channel: MethodChannel
) {
    private val interstitialAdsMap = hashMapOf<Int, LevelPlayInterstitialAd>()
    private val rewardedAdsMap = hashMapOf<Int, LevelPlayRewardedAd>()

    // Interstitial Ad Methods
    fun loadInterstitialAd(adObjectId: Int, adUnitId: String) {
        // Check if an interstitial ad already exists for this adObjectId
        val existingAd = interstitialAdsMap[adObjectId]

        if (existingAd != null) {
            // Ad exists, load the existing ad
            existingAd.loadAd()
            return
        }

        // Ad doesn't exist, create a new one
        val interstitialAd = LevelPlayInterstitialAd(adUnitId)
        interstitialAd.setListener(createInterstitialAdListener(adObjectId))

        // Store the new ad instance in the map and load it
        interstitialAdsMap[adObjectId] = interstitialAd
        interstitialAd.loadAd()
    }

    fun showInterstitialAd(adObjectId: Int, placementName: String?) {
        activity?.let {
            interstitialAdsMap[adObjectId]?.showAd(it, placementName)
        }
    }

    fun isInterstitialAdReady(adObjectId: Int): Boolean {
        return interstitialAdsMap[adObjectId]?.isAdReady() ?: false
    }

    private fun createInterstitialAdListener(adObjectId: Int): LevelPlayInterstitialAdListener {
        return object : LevelPlayInterstitialAdListener {
            override fun onAdLoaded(adInfo: LevelPlayAdInfo) {
                val args = hashMapOf("adObjectId" to adObjectId, "adInfo" to adInfo.toMap())
                invokeMethodOnUiThread(channel, "onInterstitialAdLoaded", args)
            }

            override fun onAdLoadFailed(error: LevelPlayAdError) {
                val args = hashMapOf("adObjectId" to adObjectId, "error" to error.toMap())
                invokeMethodOnUiThread(channel, "onInterstitialAdLoadFailed", args)
            }

            override fun onAdInfoChanged(adInfo: LevelPlayAdInfo) {
                val args = hashMapOf("adObjectId" to adObjectId, "adInfo" to adInfo.toMap())
                invokeMethodOnUiThread(channel, "onInterstitialAdInfoChanged", args)
            }

            override fun onAdDisplayed(adInfo: LevelPlayAdInfo) {
                val args = hashMapOf("adObjectId" to adObjectId, "adInfo" to adInfo.toMap())
                invokeMethodOnUiThread(channel, "onInterstitialAdDisplayed", args)
            }

            override fun onAdDisplayFailed(error: LevelPlayAdError, adInfo: LevelPlayAdInfo) {
                val args = hashMapOf(
                    "adObjectId" to adObjectId,
                    "error" to error.toMap(),
                    "adInfo" to adInfo.toMap()
                )
                invokeMethodOnUiThread(channel, "onInterstitialAdDisplayFailed", args)
            }

            override fun onAdClicked(adInfo: LevelPlayAdInfo) {
                val args = hashMapOf("adObjectId" to adObjectId, "adInfo" to adInfo.toMap())
                invokeMethodOnUiThread(channel, "onInterstitialAdClicked", args)
            }

            override fun onAdClosed(adInfo: LevelPlayAdInfo) {
                val args = hashMapOf("adObjectId" to adObjectId, "adInfo" to adInfo.toMap())
                invokeMethodOnUiThread(channel, "onInterstitialAdClosed", args)
            }
        }
    }

    // Rewarded Ad Methods
    fun loadRewardedAd(adObjectId: Int, adUnitId: String) {
        // Check if an rewarded ad already exists for this adObjectId
        val existingAd = rewardedAdsMap[adObjectId]

        if (existingAd != null) {
            // Ad exists, load the existing ad
            existingAd.loadAd()
            return
        }

        // Ad doesn't exist, create a new one
        val rewardedAd = LevelPlayRewardedAd(adUnitId)
        rewardedAd.setListener(createRewardedAdListener(adObjectId))

        // Store the new ad instance in the map and load it
        rewardedAdsMap[adObjectId] = rewardedAd
        rewardedAd.loadAd()
    }

    fun showRewardedAd(adObjectId: Int, placementName: String?) {
        activity?.let {
            rewardedAdsMap[adObjectId]?.showAd(it, placementName)
        }
    }

    fun isRewardedAdReady(adObjectId: Int): Boolean {
        return rewardedAdsMap[adObjectId]?.isAdReady() ?: false
    }

    private fun createRewardedAdListener(adObjectId: Int): LevelPlayRewardedAdListener {
        return object : LevelPlayRewardedAdListener {
            override fun onAdLoaded(adInfo: LevelPlayAdInfo) {
                val args = hashMapOf("adObjectId" to adObjectId, "adInfo" to adInfo.toMap())
                invokeMethodOnUiThread(channel, "onRewardedAdLoaded", args)
            }

            override fun onAdLoadFailed(error: LevelPlayAdError) {
                val args = hashMapOf("adObjectId" to adObjectId, "error" to error.toMap())
                invokeMethodOnUiThread(channel, "onRewardedAdLoadFailed", args)
            }

            override fun onAdDisplayed(adInfo: LevelPlayAdInfo) {
                val args = hashMapOf("adObjectId" to adObjectId, "adInfo" to adInfo.toMap())
                invokeMethodOnUiThread(channel, "onRewardedAdDisplayed", args)
            }

            override fun onAdDisplayFailed(error: LevelPlayAdError, adInfo: LevelPlayAdInfo) {
                val args = hashMapOf(
                    "adObjectId" to adObjectId,
                    "error" to error.toMap(),
                    "adInfo" to adInfo.toMap()
                )
                invokeMethodOnUiThread(channel, "onRewardedAdDisplayFailed", args)
            }

            override fun onAdInfoChanged(adInfo: LevelPlayAdInfo) {
                val args = hashMapOf("adObjectId" to adObjectId, "adInfo" to adInfo.toMap())
                invokeMethodOnUiThread(channel, "onRewardedAdInfoChanged", args)
            }

            override fun onAdClicked(adInfo: LevelPlayAdInfo) {
                val args = hashMapOf("adObjectId" to adObjectId, "adInfo" to adInfo.toMap())
                invokeMethodOnUiThread(channel, "onRewardedAdClicked", args)
            }

            override fun onAdClosed(adInfo: LevelPlayAdInfo) {
                val args = hashMapOf("adObjectId" to adObjectId, "adInfo" to adInfo.toMap())
                invokeMethodOnUiThread(channel, "onRewardedAdClosed", args)
            }

            override fun onAdRewarded(reward: LevelPlayReward, adInfo: LevelPlayAdInfo) {
                val args = hashMapOf(
                    "adObjectId" to adObjectId,
                    "adInfo" to adInfo.toMap(),
                    "reward" to reward.toMap()
                )
                invokeMethodOnUiThread(channel, "onRewardedAdRewarded", args)
            }

        }
    }

    // Shared Methods
    fun disposeAd(adObjectId: Int) {
        if (interstitialAdsMap.containsKey(adObjectId))
            interstitialAdsMap.remove(adObjectId)
        if (rewardedAdsMap.containsKey(adObjectId))
            rewardedAdsMap.remove(adObjectId)
    }

    fun disposeAllAds() {
        interstitialAdsMap.clear()
        rewardedAdsMap.clear()
    }
}
