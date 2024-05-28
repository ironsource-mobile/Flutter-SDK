package com.ironSource.ironsource_mediation

import android.graphics.Typeface
import android.graphics.drawable.GradientDrawable
import android.view.View
import android.widget.Button
import android.widget.ImageView
import android.widget.TextView
import com.ironsource.mediationsdk.ads.nativead.LevelPlayMediaView
import com.ironsource.mediationsdk.ads.nativead.LevelPlayNativeAd
import com.ironsource.mediationsdk.ads.nativead.LevelPlayNativeAdListener
import com.ironsource.mediationsdk.ads.nativead.NativeAdLayout
import com.ironsource.mediationsdk.adunit.adapter.utility.AdInfo
import com.ironsource.mediationsdk.logger.IronSourceError
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

/**
 * Represents a native ad view that can be displayed in a Flutter app.
 * This view handles the display and interaction of native ads received from IronSource.
 *
 * @property viewId The unique identifier for this view.
 * @property placement The placement name associated with the native ad.
 * @property levelPlayBinaryMessenger The binary messenger used for communication between Flutter and native code.
 */
class LevelPlayNativeAdView(
    viewId: Int?,
    private var placement: String? = "",
    levelPlayBinaryMessenger: BinaryMessenger,
    private var nativeAdLayout: NativeAdLayout,
    private var templateStyles: LevelPlayNativeAdTemplateStyle?,
    viewType: String,
    private var onBindNativeAdView: (LevelPlayNativeAd?) -> Unit?
) : PlatformView, LevelPlayNativeAdListener {
    private var methodChannel: MethodChannel? = null
    private var nativeAd: LevelPlayNativeAd? = null

    init {
        methodChannel = MethodChannel(levelPlayBinaryMessenger, "${viewType}_$viewId")
        methodChannel!!.setMethodCallHandler { call, result ->  handleMethodCall(call, result)}

        // Apply styles before ad loaded
        applyStyles(
            nativeAdLayout.findViewById(R.id.adTitle),
            nativeAdLayout.findViewById(R.id.adBody),
            nativeAdLayout.findViewById(R.id.adAdvertiser),
            nativeAdLayout.findViewById(R.id.adCallToAction))
    }

    private fun applyStyles(titleView: TextView, bodyView: TextView, advertiserView: TextView, callToActionView: Button) {
        templateStyles?.let { styles ->
            applyStyle(titleView, styles.titleStyle)
            applyStyle(bodyView, styles.bodyStyle)
            applyStyle(advertiserView, styles.advertiserStyle)
            applyStyle(callToActionView, styles.callToActionStyle)
        }
    }

    private fun applyStyle(view: TextView?, style: LevelPlayNativeAdElementStyle?) {
        view?.apply {
            style?.let { it ->
                it.textColor?.let { setTextColor(it) }
                it.fontStyle?.let { setTypeface(null, parseFontStyle(it)) }
                it.textSize?.let { textSize = it }
                createBackgroundDrawable(it)?.let { background = it }
            }
        }
    }

    private fun parseFontStyle(fontStyle: String?): Int {
        if (fontStyle != null) {
            return if (fontStyle.lowercase().contains("bold")) {
                Typeface.BOLD
            } else if (fontStyle.lowercase().contains("italic")) {
                Typeface.ITALIC
            } else if (fontStyle.lowercase().contains("monospace")) {
                Typeface.MONOSPACE.style
            } else {
                Typeface.NORMAL
            }
        }
        return Typeface.NORMAL
    }

    private fun createBackgroundDrawable(style: LevelPlayNativeAdElementStyle): GradientDrawable? {
        val backgroundColor = style.backgroundColor
        val cornerRadius = style.cornerRadius

        // Check if either background color or corner radius is not null
        if (backgroundColor != null || cornerRadius != null) {
            val drawable = GradientDrawable()
            drawable.shape = GradientDrawable.RECTANGLE // Default shape is rectangle

            // Set background color if not null
            backgroundColor?.let { drawable.setColor(it) }

            // Set corner radius if not null
            cornerRadius?.let { drawable.cornerRadius = it }

            return drawable
        }
        return null // Return null if both background color and corner radius are null
    }


    /**
     * Handles method calls from Flutter.
     * This method is invoked when a method call is received from Flutter, and it delegates the call to the appropriate handler method.
     *
     * @param call The method call from Flutter.
     * @param result The result to be returned to Flutter.
     */
    private fun handleMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when(call.method) {
            "loadAd" -> loadAd(result)
            "destroyAd" -> destroyAd(result)
            else -> result.error("ERROR", "Method ${call.method} unknown", null)
        }
    }

    /**
     * Loads the native ad.
     * If the native ad object is not initialized, it creates a new one using LevelPlayNativeAd.Builder
     * and sets the placement name and listener. Then, it loads the ad.
     *
     * @param result The result to be returned to Flutter indicating the success of the method call.
     */
    private fun loadAd(result: MethodChannel.Result) {
        if (nativeAd == null) {
            // If nativeAd is not initialized, create a new one
            nativeAd = LevelPlayNativeAd.Builder()
                .withPlacementName(placement)
                .withListener(this)
                .build()
        }
        // Load the ad
        nativeAd?.loadAd()
        // Return success result to Flutter
        result.success(null)
    }

    /**
     * Destroys the native ad.
     * Removes all views from the nativeAdLayout, destroys the native ad object,
     * and invokes a method on the MethodChannel to notify Flutter that the ad has been destroyed.
     *
     * @param result The result to be returned to Flutter indicating the success of the method call.
     */
    private fun destroyAd(result: MethodChannel.Result) {
        // Remove all views from the layout
        nativeAdLayout.removeAllViews()
        // Destroy the native ad
        nativeAd?.destroyAd()
        // Set nativeAd to null
        nativeAd = null
        // Return success result to Flutter
        result.success(null)
    }

    override fun getView(): View = nativeAdLayout

    override fun dispose() {
        // Remove any views
        nativeAdLayout.removeAllViews()
        // Destroy the ad
        nativeAd?.destroyAd()
        nativeAd = null
        // Set method call handler to nil
        methodChannel?.setMethodCallHandler(null)
        // Set method channel to nil
        methodChannel = null
    }

    override fun onAdClicked(nativeAd: LevelPlayNativeAd?, adInfo: AdInfo?) {
        // Notify Flutter that the ad has been clicked
        methodChannel?.invokeMethod("onAdClicked", LevelPlayUtils.hashMapOfIronSourceNativeAdAndAdInfo(nativeAd, adInfo))
    }

    override fun onAdImpression(nativeAd: LevelPlayNativeAd?, adInfo: AdInfo?) {
        // Notify Flutter that the ad has been shown
        methodChannel?.invokeMethod("onAdImpression", LevelPlayUtils.hashMapOfIronSourceNativeAdAndAdInfo(nativeAd, adInfo))
    }

    override fun onAdLoadFailed(nativeAd: LevelPlayNativeAd?, error: IronSourceError?) {
        // Notify Flutter that the ad load has been failed
        methodChannel?.invokeMethod("onAdLoadFailed", LevelPlayUtils.hashMapOfIronSourceNativeAdAndError(nativeAd, error))
    }

    override fun onAdLoaded(nativeAd: LevelPlayNativeAd?, adInfo: AdInfo?) {
        // Save native ad instance
        this.nativeAd = nativeAd

        // Invoke the binding method
        onBindNativeAdView.invoke(nativeAd)

        // Notify Flutter that the ad has been loaded
        methodChannel?.invokeMethod("onAdLoaded", LevelPlayUtils.hashMapOfIronSourceNativeAdAndAdInfo(nativeAd, adInfo))
    }
}