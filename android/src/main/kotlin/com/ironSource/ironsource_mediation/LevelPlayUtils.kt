package com.ironSource.ironsource_mediation

import android.os.Handler
import android.os.Looper
import com.ironsource.mediationsdk.IronSource
import com.ironsource.mediationsdk.adunit.adapter.utility.AdInfo
import com.ironsource.mediationsdk.logger.IronSourceError
import com.ironsource.mediationsdk.ads.nativead.LevelPlayNativeAd
import com.ironsource.mediationsdk.model.Placement
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
     * Creates a HashMap representing placement and adInfo for rewarded video.
     *
     * @param placement The placement object.
     * @param adInfo The adInfo object.
     * @return HashMap representing placement and adInfo.
     */
    fun hashMapOfRewardedVideoPlacementAdInfo(placement: Placement, adInfo: AdInfo): HashMap<String, Any> {
      return hashMapOf(
          "placement" to placement.toMap(),
          "adInfo" to adInfo.toMap()
      )
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

    /**
     * Converts ad unit string to IronSource.AD_UNIT enum.
     *
     * @param adUnit The ad unit string.
     * @return The corresponding IronSource.AD_UNIT enum value.
     */
    fun getAdUnit(adUnit: String?) : IronSource.AD_UNIT? {
      return when(adUnit) {
          "REWARDED_VIDEO" -> IronSource.AD_UNIT.REWARDED_VIDEO
          "INTERSTITIAL" -> IronSource.AD_UNIT.INTERSTITIAL
          "BANNER" -> IronSource.AD_UNIT.BANNER
          "NATIVE_AD" -> IronSource.AD_UNIT.NATIVE_AD
          else -> null
      }
    }
  }
}