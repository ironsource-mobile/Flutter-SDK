package com.ironSource.ironsource_mediation

import android.content.Context
import android.view.LayoutInflater
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import com.ironsource.mediationsdk.ads.nativead.LevelPlayNativeAd
import com.ironsource.mediationsdk.ads.nativead.NativeAdLayout

/**
 * Factory abstract class for creating instances of LevelPlayNativeAdView with build-in templates and custom layouts.
 * This factory is responsible for creating instances of LevelPlayNativeAdView and bind their views
 * to the native ad created.
 *
 * @param levelPlayBinaryMessenger The binary messenger used for communication between Flutter and native code.
 * @param layoutId The layout id used for custom native ad layout.
 */
abstract class LevelPlayNativeAdViewFactory(
    private var levelPlayBinaryMessenger: BinaryMessenger,
    private val layoutId: Int? = null
) : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context?, viewId: Int, args: Any?): PlatformView {
        // Extract map from arguments
        val creationParams = args as Map<String?, Any?>?
        // Extract variables from map
        val placement = creationParams?.get("placement") as? String
        val templateType = if (creationParams?.containsKey("templateType") == true) creationParams["templateType"] as String else null
        val viewType = if (creationParams?.containsKey("viewType") == true) creationParams["viewType"] as String else null
        val styleMap = creationParams?.get("templateStyle") as? Map<String, Any?>
        // Parse LevelPlayNativeAdElementStyle objects
        val titleElementStyle = parseElementStyle(styleMap?.get("titleStyle") as? Map<String, Any?>)
        val bodyElementStyle = parseElementStyle(styleMap?.get("bodyStyle") as? Map<String, Any?>)
        val advertiserElementStyle = parseElementStyle(styleMap?.get("advertiserStyle") as? Map<String, Any?>)
        val callToActionElementStyle = parseElementStyle(styleMap?.get("callToActionStyle") as? Map<String, Any?>)
        // Create the template style from parsed element styles(if exist)
        val levelPlayNativeAdTemplateStyle = LevelPlayNativeAdTemplateStyle(titleElementStyle, bodyElementStyle, advertiserElementStyle, callToActionElementStyle)
        // Create the native ad layout
        val layoutInflater = LayoutInflater.from(context)
        val nativeAdLayout = if (layoutId != null && layoutId > 0) {
            // This is the case of custom native ad view creation - layoutId provided
            try {
                layoutInflater.inflate(layoutId, null) as NativeAdLayout
            } catch (e: Exception) {
                throw  IllegalArgumentException("Unsupported layoutId: $layoutId")
            }
        } else {
            // This is the case of template native ad view
            when(templateType) {
                "SMALL" -> layoutInflater.inflate(R.layout.small_level_play_native_ad_template, null) as NativeAdLayout
                "MEDIUM" -> layoutInflater.inflate(R.layout.medium_level_play_native_ad_template, null) as NativeAdLayout
                else -> throw IllegalArgumentException("Unsupported templateType: $templateType")
            }
        }

        return LevelPlayNativeAdView(
            viewId,
            placement,
            levelPlayBinaryMessenger,
            nativeAdLayout,
            levelPlayNativeAdTemplateStyle,
            viewType!!
        ) { nativeAd ->
            // When native is loaded, this Unit is triggered to
            // notify the ad has been loaded and developer needs
            // to bind it to the layout.
            bindNativeAdToView(nativeAd, nativeAdLayout)
        }
    }

    /**
     * This function extract styles values from map and create instance of LevelPlayNativeAdElementStyle
     *
     * @param styleMap The style map used to extract the styling elements
     * @return The LevelPlayNativeAdElementStyle instance
     */
    private fun parseElementStyle(styleMap: Map<String, Any?>?): LevelPlayNativeAdElementStyle? {
        return styleMap?.let {
            val backgroundColor = (it["backgroundColor"] as? Long)?.toInt()
            val textSize = (it["textSize"] as? Double)?.toFloat()
            val textColor = (it["textColor"] as? Long)?.toInt()
            val fontStyle = it["fontStyle"] as? String
            val cornerRadius = (it["cornerRadius"] as? Double)?.toFloat()
            LevelPlayNativeAdElementStyle(backgroundColor, textSize, textColor, fontStyle, cornerRadius)
        }
    }

    abstract fun bindNativeAdToView(nativeAd: LevelPlayNativeAd?, nativeAdLayout: NativeAdLayout)
}
