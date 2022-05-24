package com.ironSource.ironsource_mediation

import android.graphics.Color
import android.util.Log
import android.view.Gravity
import android.view.View
import android.widget.FrameLayout
import androidx.annotation.NonNull
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleObserver
import androidx.lifecycle.OnLifecycleEvent
import com.ironsource.adapters.supersonicads.SupersonicConfig
import com.ironsource.mediationsdk.ISBannerSize
import com.ironsource.mediationsdk.IronSource
import com.ironsource.mediationsdk.IronSourceBannerLayout
import com.ironsource.mediationsdk.IronSourceSegment
import com.ironsource.mediationsdk.config.ConfigFile
import com.ironsource.mediationsdk.impressionData.ImpressionData
import com.ironsource.mediationsdk.integration.IntegrationHelper
import com.ironsource.mediationsdk.logger.IronSourceError
import com.ironsource.mediationsdk.model.Placement
import com.ironsource.mediationsdk.sdk.*
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.util.concurrent.Executors
import kotlin.math.abs


/** IronSourceMediationPlugin */
class IronSourceMediationPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, LifecycleObserver {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel: MethodChannel
  private var activity: FlutterActivity? = null

  // Banner related
  private var mBannerContainer: FrameLayout? = null
  private var mBanner: IronSourceBannerLayout? = null
  private var mBannerVisibility: Int = View.VISIBLE
  private lateinit var mBannerListener: BannerListener
  private lateinit var mRVManualListener: RewardedVideoManualListener
  private lateinit var mInitializationListener: InitializationListener

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "ironsource_mediation")
    channel.setMethodCallHandler(this)
    setListeners()
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      /** Base API ===============================================================================*/
      "validateIntegration" -> validateIntegration(result)
      "shouldTrackNetworkState" -> shouldTrackNetworkState(call, result)
      "setAdaptersDebug" -> setAdaptersDebug(call, result)
      "setDynamicUserId" -> setDynamicUserId(call, result)
      "getAdvertiserId" -> getAdvertiserId(result)
      "setConsent" -> setConsent(call, result)
      "setSegment" -> setSegment(call, result)
      "setMetaData" -> setMetaData(call, result)
      /** Init API ===============================================================================*/
      "setUserId" -> setUserId(call, result)
      "init" -> initIronSource(call, result)
      /** RV API =================================================================================*/
      "showRewardedVideo" -> showRewardedVideo(call, result)
      "getRewardedVideoPlacementInfo" -> getRewardedVideoPlacementInfo(call, result)
      "isRewardedVideoAvailable" -> isRewardedVideoAvailable(result)
      "isRewardedVideoPlacementCapped" -> isRewardedVideoPlacementCapped(call, result)
      "setRewardedVideoServerParams" -> setRewardedVideoServerParams(call, result)
      "clearRewardedVideoServerParams" -> clearRewardedVideoServerParams(result)
      "setManualLoadRewardedVideo" -> setManualLoadRewardedVideo(result)
      "loadRewardedVideo" -> loadRewardedVideo(result)
      /** IS API =================================================================================*/
      "loadInterstitial" -> loadInterstitial(result)
      "showInterstitial" -> showInterstitial(call, result)
      "isInterstitialReady" -> isInterstitialReady(result)
      "isInterstitialPlacementCapped" -> isInterstitialPlacementCapped(call, result)
      /** BN API =================================================================================*/
      "loadBanner" -> loadBanner(call, result)
      "destroyBanner" -> destroyBanner(result)
      "displayBanner" -> displayBanner(result)
      "hideBanner" -> hideBanner(result)
      "isBannerPlacementCapped" -> isBannerPlacementCapped(call, result)
      /** OW API =================================================================================*/
      "showOfferwall" -> showOfferwall(call, result)
      "isOfferwallAvailable" -> isOfferwallAvailable(result)
      "getOfferwallCredits" -> getOfferwallCredits(result)
      /** Config API =============================================================================*/
      "setClientSideCallbacks" -> setClientSideCallbacks(call, result)
      "setOfferwallCustomParams" -> setOfferwallCustomParams(call, result)
      /** Internal Config API ====================================================================*/
      "setPluginData" -> setPluginData(call, result)
      else -> result.notImplemented()
    }
  }

  /** region Base API ============================================================================*/

  /** TODO: Refactor to use real error codes **/
  private fun validateIntegration(@NonNull result: Result) {
    activity?.apply {
      IntegrationHelper.validateIntegration(this)
      return result.success(null)
    } ?: return result.error("ERROR", "Activity is null", null)
  }

  /** TODO: Refactor to use real error codes **/
  private fun shouldTrackNetworkState(@NonNull call: MethodCall, @NonNull result: Result) {
    if (activity == null) {
      return result.error("ERROR", "Activity is null", null)
    }
    val isEnabled = call.argument("isEnabled") as Boolean?
        ?: return result.error("ERROR", "isEnabled is null", null)
    IronSource.shouldTrackNetworkState(activity, isEnabled)
    return result.success(null)
  }

  /** TODO: Refactor to use real error codes **/
  private fun setAdaptersDebug(@NonNull call: MethodCall, @NonNull result: Result) {
    val isEnabled = call.argument("isEnabled") as Boolean?
        ?: return result.error("ERROR", "isEnabled is null", null)
    IronSource.setAdaptersDebug(isEnabled)
    return result.success(null)
  }

  /** TODO: Refactor to use real error codes **/
  private fun setDynamicUserId(@NonNull call: MethodCall, @NonNull result: Result) {
    val userId = call.argument("userId") as String?
        ?: return result.error("ERROR", "userId is null", null)

    IronSource.setDynamicUserId(userId)
    return result.success(null)
  }

  /** TODO: Refactor to use real error codes **/
  private fun getAdvertiserId(@NonNull result: Result) {
    activity?.apply {
      val executer = Executors.newSingleThreadExecutor()
      executer.execute {
        // this API MUST be called on a background thread
        val idStr = IronSource.getAdvertiserId(this)
        runOnUiThread { result.success(idStr) }
      }
    } ?: return result.error("ERROR", "getAdvertiserId called when activity is null", null)
  }

  /** TODO: Refactor to use real error codes **/
  private fun setConsent(@NonNull call: MethodCall, @NonNull result: Result) {
    val isConsent = call.argument("isConsent") as Boolean?
        ?: return result.error("ERROR", "isConsent is null", null)
    IronSource.setConsent(isConsent)
    return result.success(null)
  }

  /** TODO: Refactor to use real error codes **/
  private fun setSegment(@NonNull call: MethodCall, @NonNull result: Result) {
    val segmentMap = call.argument("segment") as HashMap<String, Any?>?
        ?: return result.error("ERROR", "segment is null", null)
    val iSSegment = IronSourceSegment()
    segmentMap.entries.forEach { entry ->
      when (entry.key) {
        // Dart int is 64bits, so if the value is over 32bits it is parsed into Long else Int
        // Therefore, the number fields must be safely cast
        "segmentName" -> entry.value?.let { iSSegment.segmentName = it as String }
        "age" -> entry.value?.let { iSSegment.age = if (it is Int) it else (it as Long).toInt() }
        "gender" -> entry.value?.let { iSSegment.gender = it as String }
        "level" -> entry.value?.let { iSSegment.level = if (it is Int) it else (it as Long).toInt() }
        "isPaying" -> entry.value?.let { iSSegment.setIsPaying(it as Boolean) }
        "userCreationDate" -> entry.value?.let { iSSegment.setUserCreationDate(if (it is Long) it else (it as Int).toLong()) }
        "iapTotal" -> entry.value?.let { iSSegment.setIAPTotal(it as Double) }
        else -> entry.value?.let { iSSegment.setCustom(entry.key, it as String) }
      }
    }
    IronSource.setSegment(iSSegment)
    return result.success(null)
  }

  /** TODO: Refactor to use real error codes **/
  private fun setMetaData(@NonNull call: MethodCall, @NonNull result: Result) {
    val metaDataMap = call.argument("metaData") as HashMap<String, List<String>>?
        ?: return result.error("ERROR", "metaData is null", null)
    // internally overload function uses setMetaData(key: String, values:List<String>) after all
    metaDataMap.entries.forEach { entry: Map.Entry<String, List<String>> -> IronSource.setMetaData(entry.key, entry.value) }
    return result.success(null)
  }
  // endregion

  /** region Init API ============================================================================*/

  /** TODO: Refactor to use real error codes **/
  private fun setUserId(@NonNull call: MethodCall, @NonNull result: Result) {
    val userId = call.argument("userId") as String?
        ?: return result.error("ERROR", "userId is null", null)

    IronSource.setUserId(userId)
    return result.success(null)
  }

  /** TODO: Refactor to use real error codes **/
  private fun initIronSource(@NonNull call: MethodCall, @NonNull result: Result) {
    if (activity == null) {
      return result.error("ERROR", "Activity is null", null)
    }
    val appKey = call.argument("appKey") as String?
        ?: return result.error("ERROR", "appKey is null", null)
    val adUnits = call.argument("adUnits") as List<String>?

    if (adUnits == null) {
      IronSource.init(activity, appKey, mInitializationListener)
    } else {
      val parsed = adUnits.map {
        when (it) {
          "REWARDED_VIDEO" -> IronSource.AD_UNIT.REWARDED_VIDEO
          "INTERSTITIAL" -> IronSource.AD_UNIT.INTERSTITIAL
          "OFFERWALL" -> IronSource.AD_UNIT.OFFERWALL
          "BANNER" -> IronSource.AD_UNIT.BANNER
          else -> return@initIronSource result.error("ERROR", "Unsupported ad unit: $it", null)
        }
      }.toTypedArray()
      IronSource.init(activity, appKey, mInitializationListener, *parsed)
    }
    return result.success(null)
  }
  // endregion

  /** region RV API ==============================================================================*/

  /** TODO: Refactor to use real error codes **/
  private fun showRewardedVideo(@NonNull call: MethodCall, @NonNull result: Result) {
    activity?.apply {
      val placementName = call.argument("placementName") as String?
      placementName?.let { name -> IronSource.showRewardedVideo(name) }
          ?: IronSource.showRewardedVideo()

      return result.success(null)
    } ?: return result.error("ERROR", "showRewardedVideo called when activity is null", null)
  }

  /** TODO: Refactor to use real error codes **/
  private fun getRewardedVideoPlacementInfo(@NonNull call: MethodCall, @NonNull result: Result) {
    val placementName = call.argument("placementName") as String?
        ?: return result.error("ERROR", "placementName is null", null)
    val placement: Placement? = IronSource.getRewardedVideoPlacementInfo(placementName)
    return result.success(placement?.toMap())
  }

  private fun isRewardedVideoAvailable(@NonNull result: Result) {
    return result.success(IronSource.isRewardedVideoAvailable())
  }

  /** TODO: Refactor to use real error codes **/
  private fun isRewardedVideoPlacementCapped(@NonNull call: MethodCall, @NonNull result: Result) {
    val placementName = call.argument("placementName") as String?
        ?: return result.error("ERROR", "placementName is null", null)
    val isCapped = IronSource.isRewardedVideoPlacementCapped(placementName)
    return result.success(isCapped)
  }

  /** TODO: Refactor to use real error codes **/
  private fun setRewardedVideoServerParams(@NonNull call: MethodCall, @NonNull result: Result) {
    val parameters = call.argument("parameters") as HashMap<String, String>?
        ?: return result.error("ERROR", "parameters is null", null)
    IronSource.setRewardedVideoServerParameters(parameters)
    return result.success(null)
  }

  private fun clearRewardedVideoServerParams(@NonNull result: Result) {
    IronSource.clearRewardedVideoServerParameters()
    return result.success(null)
  }

  /**
   * Manual Load RV
   * Must be called before init
   */
  private fun setManualLoadRewardedVideo(@NonNull result: Result) {
    IronSource.setRewardedVideoListener(null) // remove the auto load RV listener
    IronSource.setManualLoadRewardedVideo(mRVManualListener) // set the manual load one
    return result.success(null)
  }

  /**
   * Manual Load RV
   */
  private fun loadRewardedVideo(@NonNull result: Result) {
    IronSource.loadRewardedVideo()
    return result.success(null)
  }
  // endregion

  /** region IS API ==============================================================================*/
  private fun loadInterstitial(@NonNull result: Result) {
    IronSource.loadInterstitial()
    return result.success(null)
  }

  /** TODO: Refactor to use real error codes **/
  private fun showInterstitial(@NonNull call: MethodCall, @NonNull result: Result) {
    activity?.apply {
      val placementName = call.argument("placementName") as String?
      placementName?.let { name -> IronSource.showInterstitial(name) }
          ?: IronSource.showInterstitial()

      return result.success(null)
    } ?: return result.error("ERROR", "showInterstitial called when activity is null", null)
  }

  private fun isInterstitialReady(@NonNull result: Result) {
    return result.success(IronSource.isInterstitialReady())
  }

  /** TODO: Refactor to use real error codes **/
  private fun isInterstitialPlacementCapped(@NonNull call: MethodCall, @NonNull result: Result) {
    val placementName = call.argument("placementName") as String?
        ?: return result.error("ERROR", "placementName is null", null)
    val isCapped = IronSource.isInterstitialPlacementCapped(placementName)
    return result.success(isCapped)
  }
  // endregion

  /** region BN API ==============================================================================*/

  /** TODO: Refactor to use real error codes **/
  private fun loadBanner(@NonNull call: MethodCall, @NonNull result: Result) {
    // fallback to BANNER in the case of invalid descriptions
    fun getBannerSize(description: String, width: Int, height: Int): ISBannerSize {
      return when (description) {
        "CUSTOM" -> ISBannerSize(width, height)
        "BANNER" -> ISBannerSize.BANNER
        "SMART" -> ISBannerSize.SMART
        "RECTANGLE" -> ISBannerSize.RECTANGLE
        "LARGE" -> ISBannerSize.LARGE
        else -> ISBannerSize.BANNER
      }
    }

    activity?.apply {
      // args
      // Dart int is 64bits, so if the value is over 32bits, it is parsed into Long
      // Therefore, the Int fields could be passed as Long in some cases and must be safely cast
      val description = call.argument("description") as String?
          ?: return result.error("ERROR", "description is null", null)
      val width = (call.argument("width") as Any?)?.let { if (it is Int) it else (it as Long).toInt() }
          ?: return result.error("ERROR", "width is null", null)
      val height = (call.argument("height") as Any?)?.let { if (it is Int) it else (it as Long).toInt() }
          ?: return result.error("ERROR", "height is null", null)
      val isAdaptive = call.argument("isAdaptive") as Boolean?
          ?: return result.error("ERROR", "isAdaptive is null", null)
      val position = (call.argument("position") as Any?)?.let { if (it is Int) it else (it as Long).toInt() }
          ?: return result.error("ERROR", "position is null", null)
      val offset = (call.argument("offset") as Any?)?.let { if (it is Int) it else (it as Long).toInt() }
          ?: 0
      val placementName = call.argument("placementName") as String?

      runOnUiThread {
        synchronized(this@IronSourceMediationPlugin) {
          try {
            // Create a container
            if (mBannerContainer == null) {
              mBannerContainer = FrameLayout(this).apply {
                fitsSystemWindows = true
                setBackgroundColor(Color.TRANSPARENT)
              }
              this.addContentView(mBannerContainer, FrameLayout.LayoutParams(
                  FrameLayout.LayoutParams.MATCH_PARENT,
                  FrameLayout.LayoutParams.MATCH_PARENT
              ))
            }

            // Create banner if not exists yet
            if (mBanner == null) {
              val size = getBannerSize(description, width, height)
              size.isAdaptive = isAdaptive // Adaptive banners
              mBanner = IronSource.createBanner(this, size)

              // Banner position - TODO: use 0 - 100% vertical position/offset??
              val gravity = when (position) {
                BannerPosition.Top.value -> Gravity.TOP
                BannerPosition.Center.value -> Gravity.CENTER
                BannerPosition.Bottom.value -> Gravity.BOTTOM
                else -> throw IllegalArgumentException("BannerPosition: $position is not supported.")
              }

              // Banner layout params
              val layoutParams = FrameLayout.LayoutParams(
                  FrameLayout.LayoutParams.MATCH_PARENT,
                  FrameLayout.LayoutParams.WRAP_CONTENT,
                  gravity
              ).apply {
                if (offset > 0) {
                  topMargin = abs(offset)
                } else if (offset < 0) {
                  bottomMargin = abs(offset)
                }
              }

              // Add banner to container
              mBannerContainer?.addView(mBanner, 0, layoutParams)

              // Add listener
              mBanner?.bannerListener = mBannerListener
            }

            mBanner?.visibility = mBannerVisibility

            // Load banner
            // if already loaded, console error would be shown by iS SDK
            if (placementName != null) {
              IronSource.loadBanner(mBanner, placementName)
            } else {
              IronSource.loadBanner(mBanner)
            }

            result.success(null)
          } catch (e: Throwable) {
            Log.e(TAG, e.toString())
            result.error("ERROR", "Failed to load banner", e)
          }
        }
      }
    } ?: result.error("ERROR", "loadBanner called when activity is null", null)
  }

  /** TODO: Refactor to use real error codes **/
  private fun destroyBanner(@NonNull result: Result) {
    activity?.apply {
      runOnUiThread {
        synchronized(this@IronSourceMediationPlugin) {
          mBannerContainer?.removeAllViews()
          if (mBanner != null) {
            IronSource.destroyBanner(mBanner)
            mBanner = null
            mBannerVisibility = View.VISIBLE // Reset the visibility
          }
          result.success(null)
        }
      }
    } ?: result.error("ERROR", "destroyBanner called when activity is null", null)
  }

  /** TODO: Refactor to use real error codes **/
  private fun displayBanner(@NonNull result: Result) {
    activity?.apply {
      runOnUiThread {
        synchronized(this@IronSourceMediationPlugin) {
          mBannerVisibility = View.VISIBLE
          mBanner?.visibility = View.VISIBLE
          result.success(null)
        }
      }
    } ?: result.error("ERROR", "displayBanner called when activity is null", null)
  }

  /** TODO: Refactor to use real error codes **/
  private fun hideBanner(@NonNull result: Result) {
    activity?.apply {
      runOnUiThread {
        synchronized(this@IronSourceMediationPlugin) {
          mBannerVisibility = View.GONE
          mBanner?.visibility = View.GONE
          result.success(null)
        }
      }
    } ?: result.error("ERROR", "hideBanner called when activity is null", null)
  }

  /** TODO: Refactor to use real error codes **/
  private fun isBannerPlacementCapped(@NonNull call: MethodCall, @NonNull result: Result) {
    val placementName = call.argument("placementName") as String?
        ?: return result.error("ERROR", "placementName is null", null)
    val isCapped = IronSource.isBannerPlacementCapped(placementName)
    return result.success(isCapped)
  }
  // endregion

  /** region OW API ==============================================================================*/

  private fun getOfferwallCredits(@NonNull result: Result) {
    IronSource.getOfferwallCredits()
    return result.success(null)
  }

  /** TODO: Refactor to use real error codes **/
  private fun showOfferwall(@NonNull call: MethodCall, @NonNull result: Result) {
    activity?.apply {
      val placementName = call.argument("placementName") as String?
      placementName?.let { name -> IronSource.showOfferwall(name) }
          ?: IronSource.showOfferwall()

      return result.success(null)
    } ?: return result.error("ERROR", "showOfferwall called when activity is null", null)
  }

  private fun isOfferwallAvailable(@NonNull result: Result) {
    return result.success(IronSource.isOfferwallAvailable())
  }
  // endregion

  /** region Config API ==========================================================================*/

  /** TODO: Refactor to use real error codes **/
  private fun setClientSideCallbacks(@NonNull call: MethodCall, @NonNull result: Result) {
    val isEnabled = call.argument("isEnabled") as Boolean?
        ?: return result.error("ERROR", "isEnabled is null", null)
    SupersonicConfig.getConfigObj().clientSideCallbacks = isEnabled
    return result.success(null)
  }

  /** TODO: Refactor to use real error codes **/
  private fun setOfferwallCustomParams(@NonNull call: MethodCall, @NonNull result: Result) {
    val parameters = call.argument("parameters") as HashMap<String, String>?
        ?: return result.error("ERROR", "parameters is null", null)
    SupersonicConfig.getConfigObj().offerwallCustomParams = parameters
    return result.success(null)
  }
  // endregion

  /** region Internal Config API =================================================================*/

  /**
   * Only called internally in the process of init on the Flutter plugin
   */
  private fun setPluginData(@NonNull call: MethodCall, @NonNull result: Result) {

    val pluginType = call.argument("pluginType") as String?
        ?: return result.error("ERROR", "pluginType is null", null)
    val pluginVersion = call.argument("pluginVersion") as String?
        ?: return result.error("ERROR", "pluginVersion is null", null)
    val pluginFrameworkVersion = call.argument("pluginFrameworkVersion") as String?

    ConfigFile.getConfigFile().setPluginData(pluginType, pluginVersion, pluginFrameworkVersion)
    return result.success(null)
  }
  // endregion

  /** region Listeners Setup =====================================================================*/
  private fun setListeners() {
    /** RV Listener ==============================================================================*/
    mRVManualListener = object : RewardedVideoManualListener {
      override fun onRewardedVideoAdOpened() {
        invokeChannelMethod("onRewardedVideoAdOpened")
      }

      override fun onRewardedVideoAdClosed() {
        invokeChannelMethod("onRewardedVideoAdClosed")
      }

      override fun onRewardedVideoAvailabilityChanged(isAvailable: Boolean) {
        invokeChannelMethod("onRewardedVideoAvailabilityChanged", mapOf("isAvailable" to isAvailable))
      }

      override fun onRewardedVideoAdStarted() {
        invokeChannelMethod("onRewardedVideoAdStarted")
      }

      override fun onRewardedVideoAdEnded() {
        invokeChannelMethod("onRewardedVideoAdEnded")
      }

      override fun onRewardedVideoAdRewarded(placement: Placement) {
        invokeChannelMethod("onRewardedVideoAdRewarded", placement.toMap())
      }

      override fun onRewardedVideoAdShowFailed(error: IronSourceError) {
        invokeChannelMethod("onRewardedVideoAdShowFailed", error.toMap())
      }

      override fun onRewardedVideoAdClicked(placement: Placement) {
        invokeChannelMethod("onRewardedVideoAdClicked", placement.toMap())
      }

      override fun onRewardedVideoAdReady() {
        invokeChannelMethod("onRewardedVideoAdReady")
      }

      override fun onRewardedVideoAdLoadFailed(error: IronSourceError) {
        invokeChannelMethod("onRewardedVideoAdLoadFailed", error.toMap())
      }
    }
    IronSource.setRewardedVideoListener(mRVManualListener) // Set as an auto load RV Listener by default

    /** IS Listener ==============================================================================*/
    IronSource.setInterstitialListener(object : InterstitialListener {
      override fun onInterstitialAdReady() {
        invokeChannelMethod("onInterstitialAdReady")
      }

      override fun onInterstitialAdLoadFailed(error: IronSourceError) {
        invokeChannelMethod("onInterstitialAdLoadFailed", error.toMap())
      }

      override fun onInterstitialAdOpened() {
        invokeChannelMethod("onInterstitialAdOpened")
      }

      override fun onInterstitialAdClosed() {
        invokeChannelMethod("onInterstitialAdClosed")
      }

      override fun onInterstitialAdShowSucceeded() {
        invokeChannelMethod("onInterstitialAdShowSucceeded")
      }

      override fun onInterstitialAdShowFailed(error: IronSourceError) {
        invokeChannelMethod("onInterstitialAdShowFailed", error.toMap())
      }

      override fun onInterstitialAdClicked() {
        invokeChannelMethod("onInterstitialAdClicked")
      }
    })

    /** BN Listener ==============================================================================*/
    mBannerListener = object : BannerListener {
      override fun onBannerAdLoaded() {
        activity?.runOnUiThread {
          synchronized(this@IronSourceMediationPlugin) {
            mBanner?.visibility = mBannerVisibility // the previously set visibility state
          }
        }
        invokeChannelMethod("onBannerAdLoaded")
      }

      override fun onBannerAdLoadFailed(error: IronSourceError) {
        activity?.runOnUiThread {
          synchronized(this@IronSourceMediationPlugin) {
            mBannerContainer?.removeAllViews()
            if (mBanner != null) {
              mBanner = null
            }
          }
        }
        invokeChannelMethod("onBannerAdLoadFailed", error.toMap())
      }

      override fun onBannerAdClicked() {
        invokeChannelMethod("onBannerAdClicked")
      }

      override fun onBannerAdScreenPresented() {
        // not called by every network
        invokeChannelMethod("onBannerAdScreenPresented")
      }

      override fun onBannerAdScreenDismissed() {
        // not called by every network
        invokeChannelMethod("onBannerAdScreenDismissed")
      }

      override fun onBannerAdLeftApplication() {
        invokeChannelMethod("onBannerAdLeftApplication")
      }
    }

    /** OW Listener ==============================================================================*/
    IronSource.setOfferwallListener(object : OfferwallListener {
      override fun onOfferwallAvailable(isAvailable: Boolean) {
        invokeChannelMethod("onOfferwallAvailabilityChanged", hashMapOf("isAvailable" to isAvailable))
      }

      override fun onOfferwallOpened() {
        invokeChannelMethod("onOfferwallOpened")
      }

      override fun onOfferwallShowFailed(error: IronSourceError) {
        invokeChannelMethod("onOfferwallShowFailed", error.toMap())
      }

      override fun onOfferwallAdCredited(credits: Int, totalCredits: Int, totalCreditsFlag: Boolean): Boolean {
        invokeChannelMethod("onOfferwallAdCredited", hashMapOf(
            "credits" to credits,
            "totalCredits" to totalCredits,
            "totalCreditsFlag" to totalCreditsFlag
        ))
        // always return true as there is no way to return invokeChannel's result value.
        return true
      }

      override fun onGetOfferwallCreditsFailed(error: IronSourceError) {
        invokeChannelMethod("onGetOfferwallCreditsFailed", error.toMap())
      }

      override fun onOfferwallClosed() {
        invokeChannelMethod("onOfferwallClosed")
      }
    })

    /** ImpressionData Listener ==================================================================*/
    IronSource.addImpressionDataListener { impressionData: ImpressionData? ->
      invokeChannelMethod("onImpressionSuccess", impressionData?.toMap())
    }

    /** Initialization Listener ==================================================================*/
    mInitializationListener = InitializationListener {
      invokeChannelMethod("onInitializationComplete")
    }
  }
  // endregion

  /** region Utils/Extensions ====================================================================*/
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

  /**
   * Thin wrapper for runOnUiThread and invokeMethod.
   * No success result handling expected for now.
   */
  fun invokeChannelMethod(methodName: String, args: Any? = null) {
    activity?.runOnUiThread {
      channel.invokeMethod(methodName, args, object : Result {
        override fun success(result: Any?) {}
        override fun error(errorCode: String, errorMessage: String?, errorDetails: Any?) {
          Log.e(TAG, "Error: invokeMethod $methodName failed "
              + "errorCode: $errorCode, message: $errorMessage, details: $errorDetails")
        }

        override fun notImplemented() {
          throw Error("Critical Error: invokeMethod $methodName notImplemented ")
        }
      })
    }
  }
  // endregion

  /** region ActivityAware =======================================================================*/
  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
    activity = binding.activity as FlutterActivity
    activity?.lifecycle?.addObserver(this)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity?.lifecycle?.removeObserver(this)
    activity = null
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = binding.activity as FlutterActivity
    activity?.lifecycle?.addObserver(this)
  }

  override fun onDetachedFromActivity() {
    activity?.lifecycle?.removeObserver(this)
    activity = null
  }
  // endregion

  /** region LifeCycleObserver  ==================================================================*/
  @OnLifecycleEvent(Lifecycle.Event.ON_RESUME)
  fun onResume() {
    activity?.apply { IronSource.onResume(this) }
  }

  @OnLifecycleEvent(Lifecycle.Event.ON_PAUSE)
  fun onPause() {
    activity?.apply { IronSource.onPause(this) }
  }
  // endregion

  companion object {
    val TAG = IronSourceMediationPlugin::class.java.simpleName
  }

  enum class BannerPosition(val value: Int) {
    Top(0),
    Center(1),
    Bottom(2)
  }
}
