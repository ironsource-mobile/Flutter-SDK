package com.ironSource.ironsource_mediation

import android.app.Activity
import android.util.Log
import com.ironsource.mediationsdk.adunit.adapter.utility.AdInfo
import com.ironsource.mediationsdk.logger.IronSourceError
import com.ironsource.mediationsdk.model.Placement
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class Utils {
  companion object {
    /**
     * Thin wrapper for runOnUiThread and invokeMethod.
     * No success result handling expected for now.
     */
    fun invokeChannelMethod(activity: Activity?, channel: MethodChannel, methodName: String, args: Any? = null) {
      activity?.runOnUiThread {
        channel.invokeMethod(methodName, args, object : MethodChannel.Result {
          override fun success(result: Any?) {}
          override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
            Log.e(IronSourceMediationPlugin.TAG, "Error: invokeMethod $methodName failed "
                + "errorCode: $errorCode, message: $errorMessage, details: $errorDetails")
          }

          override fun notImplemented() {
            throw Error("Critical Error: invokeMethod $methodName notImplemented ")
          }
        })
      }
    }

    /**
     * for Level Play Listeners
     */

    fun hashMapOfRewardedVideoPlacementAdInfo(placement: Placement, adInfo: AdInfo): HashMap<String, Any> {
      return hashMapOf(
          "placement" to placement.toMap(),
          "adInfo" to adInfo.toMap()
      )
    }

    fun hashMapOfIronSourceErrorAdInfo(error: IronSourceError, adInfo: AdInfo): HashMap<String, Any> {
      return hashMapOf(
          "error" to error.toMap(),
          "adInfo" to adInfo.toMap()
      )
    }
  }
}