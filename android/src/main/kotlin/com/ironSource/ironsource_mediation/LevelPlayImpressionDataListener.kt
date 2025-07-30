package com.ironSource.ironsource_mediation

import com.unity3d.mediation.impression.LevelPlayImpressionData
import com.unity3d.mediation.impression.LevelPlayImpressionDataListener
import io.flutter.plugin.common.MethodChannel

/**
 * A wrapper class to inform flutter side when LevelPlayImpressionData success event is triggered.
 */
class LevelPlayImpressionDataListener(channel: MethodChannel) : LevelPlayListener(channel), LevelPlayImpressionDataListener {
    override fun onImpressionSuccess(impressionData: LevelPlayImpressionData) {
        invokeMethod( "onLevelPlayImpressionSuccess", impressionData.toMap())
    }
}