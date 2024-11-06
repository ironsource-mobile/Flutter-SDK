package com.ironSource.ironsource_mediation

import android.content.Context
import com.unity3d.mediation.LevelPlayAdSize
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import com.unity3d.mediation.banner.LevelPlayBannerAdView

class LevelPlayBannerAdViewFactory(
    private var levelPlayBinaryMessenger: BinaryMessenger
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        // Extract map from arguments
        val creationParams = args as Map<String, Any?>
        // Extract variables from map
        val adUnitId = creationParams["adUnitId"] as String
        val viewType = creationParams["viewType"] as String
        val placementName = creationParams["placementName"] as String?
        val adSize = getLevelPlayAdSize(context, creationParams["adSize"] as Map<String, Any?>)
        val levelPlayBanner = context?.let { LevelPlayBannerAdView(it, adUnitId) }
        if (adSize != null) {
            levelPlayBanner?.setAdSize(adSize)
        }
        levelPlayBanner?.setPlacementName(placementName)
        return LevelPlayBannerAdView(viewId, levelPlayBinaryMessenger, viewType, levelPlayBanner)
    }

    private fun getLevelPlayAdSize(context: Context?, adSizeMap: Map<String, Any?>): LevelPlayAdSize? {
        if (context == null) return null

        val width = adSizeMap["width"] as Int
        val height = adSizeMap["height"] as Int
        val adLabel = adSizeMap["adLabel"] as String?
        val isAdaptive = adSizeMap["isAdaptive"] as Boolean

        // At this point, developer has provided ad size, which means checks for
        // width and height already performed by the sdk and no need to check again.
        return if (isAdaptive) {
            // Valid width provided as adaptive already called if entered here
            LevelPlayAdSize.createAdaptiveAdSize(context, width)
        } else if (adLabel.equals("BANNER", true)) {
            LevelPlayAdSize.BANNER
        } else if (adLabel.equals("LARGE", true)) {
            LevelPlayAdSize.LARGE
        } else if (adLabel.equals("MEDIUM_RECTANGLE", true)) {
            LevelPlayAdSize.MEDIUM_RECTANGLE
        } else if (adLabel.equals("CUSTOM", true)) {
            LevelPlayAdSize.createCustomSize(width, height)
        } else {
            null
        }
    }
}
