package com.ironSource.ironsource_mediation

import android.app.Activity
import com.ironSource.ironsource_mediation.LevelPlayUtils.Companion.invokeMethodOnUiThread
import com.unity3d.mediation.LevelPlayAdError
import com.unity3d.mediation.LevelPlayAdInfo
import com.unity3d.mediation.interstitial.LevelPlayInterstitialAd
import com.unity3d.mediation.interstitial.LevelPlayInterstitialAdListener
import io.flutter.plugin.common.MethodChannel

class LevelPlayAdObjectManager(
    var activity: Activity?,
    private val channel: MethodChannel
) {

    private val interstitialAdsMap = hashMapOf<Int, LevelPlayInterstitialAd>()

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
        interstitialAd.setListener(object : LevelPlayInterstitialAdListener {
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
        })

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

    fun disposeAd(adObjectId: Int) {
        interstitialAdsMap.remove(adObjectId)
    }

    fun disposeAllAds() {
        interstitialAdsMap.clear()
        channel.setMethodCallHandler(null)
        activity = null
    }
}
