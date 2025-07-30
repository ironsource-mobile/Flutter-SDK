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
    private val interstitialAdsMap = hashMapOf<String, LevelPlayInterstitialAd>()
    private val rewardedAdsMap = hashMapOf<String, LevelPlayRewardedAd>()


    // Interstitial Ad Methods
    fun createInterstitialAd(adUnitId: String, bidFloor: Double?): String {
        // Set the bidFloor for the interstitial ad
        val adConfigBuilder = LevelPlayInterstitialAd.Config.Builder()
        if (bidFloor != null)
            adConfigBuilder.setBidFloor(bidFloor)
        // Create the interstitial ad
        val interstitialAd = LevelPlayInterstitialAd(adUnitId, adConfigBuilder.build())
        // Set the listener for the interstitial ad
        interstitialAd.setListener(createInterstitialAdListener(interstitialAd.adId))
        // Store the interstitial ad in the map
        interstitialAdsMap[interstitialAd.adId] = interstitialAd
        // Return the unique adId for the created ad object
        return interstitialAd.adId
    }

    fun loadInterstitialAd(adId: String) {
        // Retrieve the interstitial ad from the map and load it if found
        interstitialAdsMap[adId]?.loadAd()
    }

    fun showInterstitialAd(adId: String, placementName: String?) {
        // Only proceed if activity context is available
        activity?.let {
            // Find the object by adId, show it
            interstitialAdsMap[adId]?.showAd(it, placementName)
        }
    }
    /**
     * Checks if an interstitial ad is ready to be displayed.
     *
     * @param adId The identifier of the ad to check
     * @return true if the ad exists and is ready to be shown, false otherwise
     *         (including when the ad doesn't exist in the map)
     */
    fun isInterstitialAdReady(adId: String): Boolean {
        return interstitialAdsMap[adId]?.isAdReady() ?: false
    }

    private fun createInterstitialAdListener(adId: String): LevelPlayInterstitialAdListener {
        return object : LevelPlayInterstitialAdListener {
            override fun onAdLoaded(adInfo: LevelPlayAdInfo) {
                val args = hashMapOf("adId" to adId, "adInfo" to adInfo.toMap())
                invokeMethodOnUiThread(channel, "onInterstitialAdLoaded", args)
            }

            override fun onAdLoadFailed(error: LevelPlayAdError) {
                val args = hashMapOf("adId" to adId, "error" to error.toMap())
                invokeMethodOnUiThread(channel, "onInterstitialAdLoadFailed", args)
            }

            override fun onAdInfoChanged(adInfo: LevelPlayAdInfo) {
                val args = hashMapOf("adId" to adId, "adInfo" to adInfo.toMap())
                invokeMethodOnUiThread(channel, "onInterstitialAdInfoChanged", args)
            }

            override fun onAdDisplayed(adInfo: LevelPlayAdInfo) {
                val args = hashMapOf("adId" to adId, "adInfo" to adInfo.toMap())
                invokeMethodOnUiThread(channel, "onInterstitialAdDisplayed", args)
            }

            override fun onAdDisplayFailed(error: LevelPlayAdError, adInfo: LevelPlayAdInfo) {
                val args = hashMapOf(
                    "adId" to adId,
                    "error" to error.toMap(),
                    "adInfo" to adInfo.toMap()
                )
                invokeMethodOnUiThread(channel, "onInterstitialAdDisplayFailed", args)
            }

            override fun onAdClicked(adInfo: LevelPlayAdInfo) {
                val args = hashMapOf("adId" to adId, "adInfo" to adInfo.toMap())
                invokeMethodOnUiThread(channel, "onInterstitialAdClicked", args)
            }

            override fun onAdClosed(adInfo: LevelPlayAdInfo) {
                val args = hashMapOf("adId" to adId, "adInfo" to adInfo.toMap())
                invokeMethodOnUiThread(channel, "onInterstitialAdClosed", args)
            }
        }
    }

    // Rewarded Ad Methods
    fun createRewardedAd(adUnitId: String, bidFloor: Double?): String {
        // Set the bidFloor for the rewarded ad
        val adConfigBuilder = LevelPlayRewardedAd.Config.Builder()
        if (bidFloor != null)
            adConfigBuilder.setBidFloor(bidFloor)
        // Create the rewarded ad
        val rewardedAd = LevelPlayRewardedAd(adUnitId, adConfigBuilder.build())
        // Set the listener for the rewarded ad
        rewardedAd.setListener(createRewardedAdListener(rewardedAd.adId))
        // Store the rewarded ad in the map
        rewardedAdsMap[rewardedAd.adId] = rewardedAd
        // Return the unique adId for the created ad object
        return rewardedAd.adId
    }

    fun loadRewardedAd(adId: String) {
        // Retrieve the rewarded ad from the map and load it if found
        rewardedAdsMap[adId]?.loadAd()
        }

    fun showRewardedAd(adId: String, placementName: String?) {
        // Only proceed if activity context is available
        activity?.let {
            // Find the adObject by adId, verify it's ready, then show it
            rewardedAdsMap[adId]?.showAd(it, placementName)
        }
    }
    /**
     * Checks if rewarded ad is ready to be displayed.
     *
     * @param adId The identifier of the ad to check
     * @return true if the ad exists and is ready to be shown, false otherwise
     *         (including when the ad doesn't exist in the map)
     */

    fun isRewardedAdReady(adId: String): Boolean {
        return rewardedAdsMap[adId]?.isAdReady() ?: false
    }

    private fun createRewardedAdListener(adId: String): LevelPlayRewardedAdListener {
        return object : LevelPlayRewardedAdListener {
            override fun onAdLoaded(adInfo: LevelPlayAdInfo) {
                val args = hashMapOf("adId" to adId, "adInfo" to adInfo.toMap())
                invokeMethodOnUiThread(channel, "onRewardedAdLoaded", args)
            }

            override fun onAdLoadFailed(error: LevelPlayAdError) {
                val args = hashMapOf("adId" to adId, "error" to error.toMap())
                invokeMethodOnUiThread(channel, "onRewardedAdLoadFailed", args)
            }

            override fun onAdDisplayed(adInfo: LevelPlayAdInfo) {
                val args = hashMapOf("adId" to adId, "adInfo" to adInfo.toMap())
                invokeMethodOnUiThread(channel, "onRewardedAdDisplayed", args)
            }

            override fun onAdDisplayFailed(error: LevelPlayAdError, adInfo: LevelPlayAdInfo) {
                val args = hashMapOf(
                    "adId" to adId,
                    "error" to error.toMap(),
                    "adInfo" to adInfo.toMap()
                )
                invokeMethodOnUiThread(channel, "onRewardedAdDisplayFailed", args)
            }

            override fun onAdInfoChanged(adInfo: LevelPlayAdInfo) {
                val args = hashMapOf("adId" to adId, "adInfo" to adInfo.toMap())
                invokeMethodOnUiThread(channel, "onRewardedAdInfoChanged", args)
            }

            override fun onAdClicked(adInfo: LevelPlayAdInfo) {
                val args = hashMapOf("adId" to adId, "adInfo" to adInfo.toMap())
                invokeMethodOnUiThread(channel, "onRewardedAdClicked", args)
            }

            override fun onAdClosed(adInfo: LevelPlayAdInfo) {
                val args = hashMapOf("adId" to adId, "adInfo" to adInfo.toMap())
                invokeMethodOnUiThread(channel, "onRewardedAdClosed", args)
            }

            override fun onAdRewarded(reward: LevelPlayReward, adInfo: LevelPlayAdInfo) {
                val args = hashMapOf(
                    "adId" to adId,
                    "adInfo" to adInfo.toMap(),
                    "reward" to reward.toMap()
                )
                invokeMethodOnUiThread(channel, "onRewardedAdRewarded", args)
            }

        }
    }

    // Shared Methods
    fun disposeAd(adId: String) {
        if (interstitialAdsMap.containsKey(adId))
            interstitialAdsMap.remove(adId)
        if (rewardedAdsMap.containsKey(adId))
            rewardedAdsMap.remove(adId)
    }

    fun disposeAllAds() {
        interstitialAdsMap.clear()
        rewardedAdsMap.clear()
    }
}


