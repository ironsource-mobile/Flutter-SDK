package com.ironSource.ironsource_mediation

import com.ironsource.mediationsdk.logger.IronSourceError
import com.ironsource.mediationsdk.sdk.InterstitialListener
import io.flutter.plugin.common.MethodChannel

class InterstitialListener(channel: MethodChannel) : IronSourceListener(channel),
    InterstitialListener {
  override fun onInterstitialAdReady() {
    invokeMethod("onInterstitialAdReady")
  }

  override fun onInterstitialAdLoadFailed(error: IronSourceError) {
    invokeMethod("onInterstitialAdLoadFailed", error.toMap())
  }

  override fun onInterstitialAdOpened() {
    invokeMethod("onInterstitialAdOpened")
  }

  override fun onInterstitialAdClosed() {
    invokeMethod("onInterstitialAdClosed")
  }

  override fun onInterstitialAdShowSucceeded() {
    invokeMethod("onInterstitialAdShowSucceeded")
  }

  override fun onInterstitialAdShowFailed(error: IronSourceError) {
    invokeMethod("onInterstitialAdShowFailed", error.toMap())
  }

  override fun onInterstitialAdClicked() {
    invokeMethod("onInterstitialAdClicked")
  }
}
