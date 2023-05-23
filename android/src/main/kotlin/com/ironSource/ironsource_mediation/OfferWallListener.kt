package com.ironSource.ironsource_mediation

import com.ironsource.mediationsdk.logger.IronSourceError
import com.ironsource.mediationsdk.sdk.OfferwallListener
import io.flutter.plugin.common.MethodChannel

class OfferWallListener(channel: MethodChannel) : IronSourceListener(channel),
    OfferwallListener {
  override fun onOfferwallAvailable(isAvailable: Boolean) {
    invokeMethod("onOfferwallAvailabilityChanged", hashMapOf("isAvailable" to isAvailable))
  }

  override fun onOfferwallOpened() {
    invokeMethod("onOfferwallOpened")
  }

  override fun onOfferwallShowFailed(error: IronSourceError) {
    invokeMethod("onOfferwallShowFailed", error.toMap())
  }

  override fun onOfferwallAdCredited(credits: Int, totalCredits: Int, totalCreditsFlag: Boolean): Boolean {
    invokeMethod("onOfferwallAdCredited", hashMapOf(
        "credits" to credits,
        "totalCredits" to totalCredits,
        "totalCreditsFlag" to totalCreditsFlag
    ))
    // always return true as there is no way to return invokeChannel's result value.
    return true
  }

  override fun onGetOfferwallCreditsFailed(error: IronSourceError) {
    invokeMethod("onGetOfferwallCreditsFailed", error.toMap())
  }

  override fun onOfferwallClosed() {
    invokeMethod("onOfferwallClosed")
  }
}