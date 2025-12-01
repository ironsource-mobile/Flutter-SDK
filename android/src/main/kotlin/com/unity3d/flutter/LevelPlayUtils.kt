package com.unity3d.flutter

import android.os.Handler
import android.os.Looper
import com.ironsource.mediationsdk.adunit.adapter.utility.AdInfo
import com.ironsource.mediationsdk.logger.IronSourceError
import com.ironsource.mediationsdk.ads.nativead.LevelPlayNativeAd
import io.flutter.plugin.common.MethodChannel

/**
 * Utility class containing helper methods for IronSource mediation.
 */
class LevelPlayUtils {
  companion object {

    /**
     * Invokes a method on a Flutter MethodChannel on the UI thread.
     *
     * This function ensures that the call to `invokeMethod` on the
     * MethodChannel is performed on the main (UI) thread. This is essential
     * for thread-safety and to prevent crashes due to improper thread access.
     *
     * @param channel The [MethodChannel] on which the method is to be invoked.
     * @param methodName The name of the method to invoke on the channel.
     * @param arguments The arguments to pass to the method. This parameter is optional and defaults to null.
     */
    fun invokeMethodOnUiThread(channel: MethodChannel, methodName: String, arguments: Map<String, Any?>? = null) {
      Handler(Looper.getMainLooper())
        .post { channel.invokeMethod(methodName, arguments) }
    }

    /**
     * Creates a HashMap representing IronSource error and adInfo.
     *
     * @param error The IronSource error object.
     * @param adInfo The adInfo object.
     * @return HashMap representing IronSource error and adInfo.
     */
    fun hashMapOfIronSourceErrorAdInfo(error: IronSourceError, adInfo: AdInfo): HashMap<String, Any> {
      return hashMapOf(
          "error" to error.toMap(),
          "adInfo" to adInfo.toMap()
      )
    }

    /**
     * Maps IronSource native ad and adInfo to a HashMap.
     *
     * @param nativeAd The LevelPlayNativeAd object.
     * @param adInfo The adInfo object.
     * @return HashMap representing IronSource native ad and adInfo.
     */
    fun hashMapOfIronSourceNativeAdAndAdInfo(nativeAd: LevelPlayNativeAd?, adInfo: AdInfo?): HashMap<String, Any?> {
      return hashMapOf(
        "nativeAd" to nativeAd?.toMap(),
        "adInfo" to adInfo?.toMap()
      )
    }

    /**
     * Maps IronSource native ad and error to a HashMap.
     *
     * @param nativeAd The LevelPlayNativeAd object.
     * @param error The IronSourceError object.
     * @return HashMap representing IronSource native ad and error.
     */
    fun hashMapOfIronSourceNativeAdAndError(nativeAd: LevelPlayNativeAd?, error: IronSourceError?): HashMap<String, Any?> {
      return hashMapOf(
        "nativeAd" to nativeAd?.toMap(),
        "error" to error?.toMap()
      )
    }
  }
}