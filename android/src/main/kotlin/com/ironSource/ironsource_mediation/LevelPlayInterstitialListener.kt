package com.ironSource.ironsource_mediation

import com.ironsource.mediationsdk.adunit.adapter.utility.AdInfo
import com.ironsource.mediationsdk.logger.IronSourceError
import com.ironsource.mediationsdk.sdk.LevelPlayInterstitialListener
import io.flutter.plugin.common.MethodChannel

/**
 * LevelPlay Interstitial Listener
 */
class LevelPlayInterstitialListener(channel: MethodChannel) : IronSourceListener(channel),
    LevelPlayInterstitialListener {

  override fun onAdReady(adInfo: AdInfo) {
    invokeMethod("LevelPlay_Interstitial:onAdReady", adInfo.toMap())
  }

  override fun onAdLoadFailed(error: IronSourceError) {
    invokeMethod("LevelPlay_Interstitial:onAdLoadFailed", error.toMap())
  }

  override fun onAdOpened(adInfo: AdInfo) {
    invokeMethod("LevelPlay_Interstitial:onAdOpened", adInfo.toMap())
  }

  override fun onAdClosed(adInfo: AdInfo) {
    invokeMethod("LevelPlay_Interstitial:onAdClosed", adInfo.toMap())
  }

  override fun onAdShowFailed(error: IronSourceError, adInfo: AdInfo) {
    invokeMethod("LevelPlay_Interstitial:onAdShowFailed", LevelPlayUtils.hashMapOfIronSourceErrorAdInfo(error, adInfo))
  }

  override fun onAdClicked(adInfo: AdInfo) {
    invokeMethod("LevelPlay_Interstitial:onAdClicked", adInfo.toMap())
  }

  override fun onAdShowSucceeded(adInfo: AdInfo) {
    invokeMethod("LevelPlay_Interstitial:onAdShowSucceeded", adInfo.toMap())
  }
}