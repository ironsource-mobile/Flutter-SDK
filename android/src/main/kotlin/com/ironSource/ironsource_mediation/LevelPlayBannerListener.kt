package com.ironSource.ironsource_mediation

import com.ironsource.mediationsdk.adunit.adapter.utility.AdInfo
import com.ironsource.mediationsdk.logger.IronSourceError
import com.ironsource.mediationsdk.sdk.LevelPlayBannerListener
import io.flutter.plugin.common.MethodChannel

/**
 * LevelPlay Banner Listener
 */
class LevelPlayBannerListener(channel: MethodChannel) : IronSourceListener(channel),
    LevelPlayBannerListener {

  override fun onAdLoaded(adInfo: AdInfo) {
    invokeMethod("LevelPlay_Banner:onAdLoaded", adInfo.toMap())
  }

  override fun onAdLoadFailed(error: IronSourceError) {
    invokeMethod("LevelPlay_Banner:onAdLoadFailed", error.toMap())
  }

  override fun onAdClicked(adInfo: AdInfo) {
    invokeMethod("LevelPlay_Banner:onAdClicked", adInfo.toMap())
  }

  override fun onAdScreenPresented(adInfo: AdInfo) {
    invokeMethod("LevelPlay_Banner:onAdScreenPresented", adInfo.toMap())
  }

  override fun onAdScreenDismissed(adInfo: AdInfo) {
    invokeMethod("LevelPlay_Banner:onAdScreenDismissed", adInfo.toMap())
  }

  override fun onAdLeftApplication(adInfo: AdInfo) {
    invokeMethod("LevelPlay_Banner:onAdLeftApplication", adInfo.toMap())
  }
}