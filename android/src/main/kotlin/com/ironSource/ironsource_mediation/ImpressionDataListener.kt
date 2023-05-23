package com.ironSource.ironsource_mediation

import com.ironsource.mediationsdk.impressionData.ImpressionData
import com.ironsource.mediationsdk.impressionData.ImpressionDataListener
import io.flutter.plugin.common.MethodChannel

class ImpressionDataListener(channel: MethodChannel) : IronSourceListener(channel),
    ImpressionDataListener {
  override fun onImpressionSuccess(impressionData: ImpressionData?) {
    invokeMethod("onImpressionSuccess", impressionData?.toMap())
  }
}