package com.ironSource.ironsource_mediation

import com.ironsource.mediationsdk.logger.IronSourceError
import com.ironsource.mediationsdk.model.Placement
import com.ironsource.mediationsdk.sdk.RewardedVideoListener
import com.ironsource.mediationsdk.sdk.RewardedVideoManualListener
import io.flutter.plugin.common.MethodChannel

class RewardedVideoListener(channel: MethodChannel) : IronSourceListener(channel),
    RewardedVideoListener,
    RewardedVideoManualListener {

  override fun onRewardedVideoAdOpened() {
    invokeMethod("onRewardedVideoAdOpened")
  }

  override fun onRewardedVideoAdClosed() {
    invokeMethod("onRewardedVideoAdClosed")
  }

  override fun onRewardedVideoAvailabilityChanged(isAvailable: Boolean) {
    invokeMethod("onRewardedVideoAvailabilityChanged", mapOf("isAvailable" to isAvailable))
  }

  override fun onRewardedVideoAdStarted() {
    invokeMethod("onRewardedVideoAdStarted")
  }

  override fun onRewardedVideoAdEnded() {
    invokeMethod("onRewardedVideoAdEnded")
  }

  override fun onRewardedVideoAdRewarded(placement: Placement) {
    invokeMethod("onRewardedVideoAdRewarded", placement.toMap())
  }

  override fun onRewardedVideoAdShowFailed(error: IronSourceError) {
    invokeMethod("onRewardedVideoAdShowFailed", error.toMap())
  }

  override fun onRewardedVideoAdClicked(placement: Placement) {
    invokeMethod("onRewardedVideoAdClicked", placement.toMap())
  }

  /** Manual RewardedVideo =================================================================================**/

  override fun onRewardedVideoAdReady() {
    invokeMethod("onRewardedVideoAdReady")
  }

  override fun onRewardedVideoAdLoadFailed(error: IronSourceError) {
    invokeMethod("onRewardedVideoAdLoadFailed", error.toMap())
  }
}