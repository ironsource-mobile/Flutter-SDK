package com.ironSource.ironsource_mediation

import com.ironsource.mediationsdk.adunit.adapter.utility.AdInfo
import com.ironsource.mediationsdk.impressionData.ImpressionData
import com.ironsource.mediationsdk.logger.IronSourceError
import com.ironsource.mediationsdk.model.Placement

fun Placement.toMap(): HashMap<String, Any> {
  return hashMapOf(
      "placementName" to this.placementName,
      "rewardName" to this.rewardName,
      "rewardAmount" to this.rewardAmount
  )
}

fun IronSourceError.toMap(): HashMap<String, Any> {
  return hashMapOf(
      "errorCode" to this.errorCode,
      "message" to this.errorMessage
  )
}

fun ImpressionData.toMap(): HashMap<String, Any> {
  return hashMapOf(
      "auctionId" to this.auctionId,
      "adUnit" to this.adUnit,
      "country" to this.country,
      "ab" to this.ab,
      "segmentName" to this.segmentName,
      "placement" to this.placement,
      "adNetwork" to this.adNetwork,
      "instanceName" to this.instanceName,
      "instanceId" to this.instanceId,
      "revenue" to this.revenue,
      "precision" to this.precision,
      "lifetimeRevenue" to this.lifetimeRevenue,
      "encryptedCPM" to this.encryptedCPM
  )
}

fun AdInfo.toMap(): HashMap<String, Any> {
  return hashMapOf(
      "auctionId" to this.auctionId,
      "adUnit" to this.adUnit,
      "adNetwork" to this.adNetwork,
      "ab" to this.ab,
      "country" to this.country,
      "instanceId" to this.instanceId,
      "instanceName" to this.instanceName,
      "segmentName" to this.segmentName,
      "revenue" to this.revenue,
      "precision" to this.precision,
      "encryptedCPM" to this.encryptedCPM
  )
}