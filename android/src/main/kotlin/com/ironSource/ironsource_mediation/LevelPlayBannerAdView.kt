package com.ironSource.ironsource_mediation

import com.ironSource.ironsource_mediation.LevelPlayUtils.Companion.invokeMethodOnUiThread
import com.unity3d.mediation.LevelPlayAdError
import com.unity3d.mediation.LevelPlayAdInfo
import com.unity3d.mediation.banner.LevelPlayBannerAdView
import com.unity3d.mediation.banner.LevelPlayBannerAdViewListener
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.platform.PlatformView

internal class LevelPlayBannerAdView(
    viewId: Int?,
    levelPlayBinaryMessenger: BinaryMessenger,
    viewType: String,
    private var levelPlayBanner: LevelPlayBannerAdView?
) : PlatformView, LevelPlayBannerAdViewListener {
    private var methodChannel: MethodChannel? = null

    init {
        methodChannel = MethodChannel(levelPlayBinaryMessenger, "${viewType}_$viewId")
        methodChannel!!.setMethodCallHandler { call, result ->  handleMethodCall(call, result)}
        levelPlayBanner?.setBannerListener(this)
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
            "destroyBanner" -> destroyBanner(result)
            "pauseAutoRefresh" -> pauseAutoRefresh(result)
            "resumeAutoRefresh" -> resumeAutoRefresh(result)
            else -> result.error("ERROR", "Method ${call.method} unknown", null)
        }
    }

    private fun loadAd(result: MethodChannel.Result) {
        levelPlayBanner?.loadAd()
        // Return success result to Flutter
        result.success(null)
    }

    private fun destroyBanner(result: MethodChannel.Result) {
        levelPlayBanner?.destroy()
        // Return success result to Flutter
        result.success(null)
    }


    private fun pauseAutoRefresh(result: MethodChannel.Result) {
        levelPlayBanner?.pauseAutoRefresh()
        // Return success result to Flutter
        result.success(null)
    }

    private fun resumeAutoRefresh(result: MethodChannel.Result) {
        levelPlayBanner?.resumeAutoRefresh()
        // Return success result to Flutter
        result.success(null)
    }

    override fun getView(): LevelPlayBannerAdView? = levelPlayBanner

    override fun dispose() {
        levelPlayBanner?.destroy()
        // Set method call handler to nil
        methodChannel?.setMethodCallHandler(null)
        // Set method channel to nil
        methodChannel = null
    }

    override fun onAdLoaded(adInfo: LevelPlayAdInfo) {
        val args = hashMapOf("adInfo" to adInfo.toMap())
        invokeMethodOnUiThread(methodChannel!!, "onAdLoaded", args)
    }

    override fun onAdLoadFailed(error: LevelPlayAdError) {
        val args = hashMapOf("error" to error.toMap())
        invokeMethodOnUiThread(methodChannel!!, "onAdLoadFailed", args)
    }

    override fun onAdDisplayed(adInfo: LevelPlayAdInfo) {
        val args = hashMapOf("adInfo" to adInfo.toMap())
        invokeMethodOnUiThread(methodChannel!!, "onAdDisplayed", args)
    }

    override fun onAdDisplayFailed(adInfo: LevelPlayAdInfo, error: LevelPlayAdError) {
        val args = hashMapOf("adInfo" to adInfo.toMap(), "error" to error.toMap())
        invokeMethodOnUiThread(methodChannel!!, "onAdDisplayFailed", args)
    }

    override fun onAdClicked(adInfo: LevelPlayAdInfo) {
        val args = hashMapOf("adInfo" to adInfo.toMap())
        invokeMethodOnUiThread(methodChannel!!, "onAdClicked", args)
    }

    override fun onAdExpanded(adInfo: LevelPlayAdInfo) {
        val args = hashMapOf("adInfo" to adInfo.toMap())
        invokeMethodOnUiThread(methodChannel!!, "onAdExpanded", args)
    }

    override fun onAdCollapsed(adInfo: LevelPlayAdInfo) {
        val args = hashMapOf("adInfo" to adInfo.toMap())
        invokeMethodOnUiThread(methodChannel!!, "onAdCollapsed", args)
    }

    override fun onAdLeftApplication(adInfo: LevelPlayAdInfo) {
        val args = hashMapOf("adInfo" to adInfo.toMap())
        invokeMethodOnUiThread(methodChannel!!, "onAdLeftApplication", args)
    }
}