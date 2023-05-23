package com.ironSource.ironsource_mediation

import com.ironsource.mediationsdk.logger.IronSourceError
import com.ironsource.mediationsdk.sdk.BannerListener
import io.flutter.plugin.common.MethodChannel

class BannerListener(
    channel: MethodChannel,
    private val onBannerAdLoadFailedCallBack: (error: IronSourceError) -> Unit)
  : IronSourceListener(channel), BannerListener {
  
  override fun onBannerAdLoaded() {
    invokeMethod("onBannerAdLoaded")
  }

  override fun onBannerAdLoadFailed(error: IronSourceError) {
    onBannerAdLoadFailedCallBack(error)
    invokeMethod("onBannerAdLoadFailed", error.toMap())
  }

  override fun onBannerAdClicked() {
    invokeMethod("onBannerAdClicked")
  }

  override fun onBannerAdScreenPresented() {
    // not called by every network
    invokeMethod("onBannerAdScreenPresented")
  }

  override fun onBannerAdScreenDismissed() {
    // not called by every network
    invokeMethod("onBannerAdScreenDismissed")
  }

  override fun onBannerAdLeftApplication() {
    invokeMethod("onBannerAdLeftApplication")
  }
}
