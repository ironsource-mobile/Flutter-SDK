package com.ironSource.ironsource_mediation

import com.ironsource.mediationsdk.adunit.adapter.utility.AdInfo
import com.ironsource.mediationsdk.logger.IronSourceError
import com.ironsource.mediationsdk.model.Placement
import com.ironsource.mediationsdk.sdk.LevelPlayRewardedVideoListener
import com.ironsource.mediationsdk.sdk.LevelPlayRewardedVideoManualListener
import io.flutter.plugin.common.MethodChannel

/**
 * LevelPlay ReawrdedVideo Listener
 */
class LevelPlayRewardedVideoListener(channel: MethodChannel) : IronSourceListener(channel),
    LevelPlayRewardedVideoListener, LevelPlayRewardedVideoManualListener {

  override fun onAdAvailable(adInfo: AdInfo) {
    invokeMethod("LevelPlay_RewardedVideo:onAdAvailable", adInfo.toMap())
  }

  override fun onAdUnavailable() {
    invokeMethod("LevelPlay_RewardedVideo:onAdUnavailable")
  }

  override fun onAdOpened(adInfo: AdInfo) {
    invokeMethod("LevelPlay_RewardedVideo:onAdOpened", adInfo.toMap())
  }

  override fun onAdClosed(adInfo: AdInfo) {
    invokeMethod("LevelPlay_RewardedVideo:onAdClosed", adInfo.toMap())
  }

  override fun onAdRewarded(placement: Placement, adInfo: AdInfo) {
    invokeMethod("LevelPlay_RewardedVideo:onAdRewarded", LevelPlayUtils.hashMapOfRewardedVideoPlacementAdInfo(placement, adInfo))
  }

  override fun onAdShowFailed(error: IronSourceError, adInfo: AdInfo) {
    invokeMethod("LevelPlay_RewardedVideo:onAdShowFailed", LevelPlayUtils.hashMapOfIronSourceErrorAdInfo(error, adInfo))
  }

  override fun onAdClicked(placement: Placement, adInfo: AdInfo) {
    invokeMethod("LevelPlay_RewardedVideo:onAdClicked", LevelPlayUtils.hashMapOfRewardedVideoPlacementAdInfo(placement, adInfo))
  }

  /** Manual RewardedVideo Events ========================================================================**/
  override fun onAdReady(adInfo: AdInfo) {
    invokeMethod("LevelPlay_RewardedVideo:onAdReady", adInfo.toMap())
  }

  override fun onAdLoadFailed(error: IronSourceError) {
    invokeMethod("LevelPlay_RewardedVideo:onAdLoadFailed", error.toMap())
  }
}