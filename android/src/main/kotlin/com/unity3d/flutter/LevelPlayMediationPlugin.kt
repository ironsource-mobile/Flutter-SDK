package com.unity3d.flutter

import android.app.Activity
import android.content.Context
import android.util.Log
import androidx.lifecycle.LifecycleObserver
import com.ironsource.mediationsdk.config.ConfigFile
import com.unity3d.mediation.LevelPlay
import com.unity3d.mediation.LevelPlayAdSize
import com.unity3d.mediation.LevelPlayConfiguration
import com.unity3d.mediation.LevelPlayInitError
import com.unity3d.mediation.LevelPlayInitListener
import com.unity3d.mediation.LevelPlayInitRequest
import com.unity3d.mediation.impression.LevelPlayImpressionData
import com.unity3d.mediation.impression.LevelPlayImpressionDataListener
import com.unity3d.mediation.interstitial.LevelPlayInterstitialAd
import com.unity3d.mediation.rewarded.LevelPlayRewardedAd
import com.unity3d.mediation.segment.LevelPlaySegment
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.platform.PlatformViewFactory

class LevelPlayMediationPlugin : FlutterPlugin, MethodCallHandler, ActivityAware, LifecycleObserver,
  LevelPlayInitListener, LevelPlayImpressionDataListener {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private var channel: MethodChannel? = null
  private var activity: Activity? = null
  private var context: Context? = null

  // LevelPlay Native Ad
  private var nativeAdViewFactories = hashMapOf<String, PlatformViewFactory>()
  private var pluginBinding: FlutterPluginBinding? = null

  // LevelPlay Ad Object Manager
  private lateinit var levelPlayAdObjectManager: LevelPlayAdObjectManager

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "unity_levelplay_mediation")
    context = flutterPluginBinding.applicationContext
    pluginBinding = flutterPluginBinding

    channel?.setMethodCallHandler(this)

    // Banner ad view registry
    val bannerAdViewFactory = LevelPlayBannerAdViewFactory(pluginBinding!!.binaryMessenger)
    pluginBinding
      ?.platformViewRegistry
      ?.registerViewFactory("LevelPlayBannerAdView", bannerAdViewFactory)

    // Native ad view registry
    val nativeAdViewFactory = LevelPlayNativeAdViewFactoryTemplate(pluginBinding!!.binaryMessenger)
    addNativeAdViewFactory("LevelPlayNativeAdView", nativeAdViewFactory)

    // Ad object manager registry
    levelPlayAdObjectManager = LevelPlayAdObjectManager(activity, channel!!)
  }

  override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
    channel?.setMethodCallHandler(null)
    channel = null
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      /** Base API =============================================================================*/
      "validateIntegration" -> validateIntegration(result)
      "setDynamicUserId" -> setDynamicUserId(call, result)
      "setAdaptersDebug" -> setAdaptersDebug(call, result)
      "setConsent" -> setConsent(call, result)
      "setSegment" -> setSegment(call, result)
      "setMetaData" -> setMetaData(call, result)
      "launchTestSuite" -> launchTestSuite(result)
      "addImpressionDataListener" -> addImpressionDataListener(result)
      "setPluginData" -> setPluginData(call, result)
      /** LevelPlay Init API ===============================================================================*/
      "init" -> init(call, result)
      /** LevelPlay Interstitial Ad API ===============================================================================*/
      "createInterstitialAd" -> createInterstitialAd(call, result)
      "loadInterstitialAd" -> loadInterstitialAd(call, result)
      "showInterstitialAd" -> showInterstitialAd(call, result)
      "isInterstitialAdReady" -> isInterstitialAdReady(call, result)
      "isInterstitialAdPlacementCapped" -> isInterstitialAdPlacementCapped(call, result)
      "disposeAd" -> disposeAd(call, result)
      "disposeAllAds" -> disposeAllAds(result)
      /** LPMAdSize API ===============================================================================*/
      "createAdaptiveAdSize" -> createAdaptiveAdSize(call, result)
      /** LevelPlay Rewarded Ad API ===============================================================================*/
      "createRewardedAd" -> createRewardedAd(call, result)
      "loadRewardedAd" -> loadRewardedAd(call, result)
      "showRewardedAd" -> showRewardedAd(call, result)
      "isRewardedAdReady" -> isRewardedAdReady(call, result)
      "isRewardedAdPlacementCapped" -> isRewardedAdPlacementCapped(call, result)
      else -> result.notImplemented()
    }
  }

  /** region Base API ============================================================================*/

  /**
   * Validates the integration of the SDK.
   *
   * @param result The result to be returned after validating the integration.
   */
  private fun validateIntegration(result: Result) {
    context?.let { LevelPlay.validateIntegration(it) }
    result.success(null)
  }

  /**
   * Sets the dynamic user ID for LevelPlay SDK.
   *
   * @param call The method call containing arguments.
   * @param result The result to be returned after processing.
   */
  private fun setDynamicUserId(call: MethodCall, result: Result) {
    val userId: String = call.argument("userId")!!
    LevelPlay.setDynamicUserId(userId)
    result.success(null)
  }

  /**
   * Sets whether to enable debug mode for LevelPlay SDK adapters.
   *
   * @param call The method call containing arguments.
   * @param result The result to be returned after processing.
   */
  private fun setAdaptersDebug(call: MethodCall, result: Result) {
    val isEnabled: Boolean = call.argument("isEnabled")!!
    LevelPlay.setAdaptersDebug(isEnabled)
    result.success(null)
  }

  /**
   * Sets the consent status for the user.
   *
   * @param call The method call containing arguments.
   * @param result The result to be returned after processing.
   */
  private fun setConsent(call: MethodCall, result: Result) {
    val isConsent: Boolean = call.argument("isConsent")!!
    LevelPlay.setConsent(isConsent)
    result.success(null)
  }

  /**
   * Sets the segment for the user.
   *
   * @param call The method call containing arguments.
   * @param result The result to be returned after processing.
   */

  private fun setSegment(call: MethodCall, result: Result) {
    val segmentMap: HashMap<String, Any?> = call.argument("segment")!!
    val segment = LevelPlaySegment()
    segmentMap.entries.forEach { entry ->
      when (entry.key) {
        // Dart int is 64bits, so if the value is over 32bits it is parsed into Long else Int
        // Therefore, the number fields must be safely cast
        "segmentName" -> entry.value?.let { segment.segmentName = it as String }
        "level" -> entry.value?.let { segment.level = if (it is Int) it else (it as Long).toInt() }
        "isPaying" -> entry.value?.let { segment.isPaying = (it as Boolean) }
        "userCreationDate" -> entry.value?.let { segment.userCreationDate = (if (it is Long) it else (it as Int).toLong()) }
        "iapTotal" -> entry.value?.let { segment.iapTotal = (it as Double) }
        "customParameters" -> entry.value?.let { params ->
          (params as HashMap<String, String>).entries.forEach { param ->
            segment.setCustom(param.key, param.value)
          }
        }
      }
    }
    LevelPlay.setSegment(segment)
    result.success(null)
  }

  /**
   * Sets meta data for LevelPlay.
   *
   * @param call The method call containing arguments.
   * @param result The result to be returned after processing.
   */
  private fun setMetaData(call: MethodCall, result: Result) {
    val metaDataMap: HashMap<String, List<String>> = call.argument("metaData")!!
    metaDataMap.entries.forEach { entry: Map.Entry<String, List<String>> ->
      LevelPlay.setMetaData(
        entry.key,
        entry.value
      )
    }
    result.success(null)
  }

  /**
   * Launches the LevelPlay test suite.
   *
   * @param result The result to be returned after processing.
   */
  private fun launchTestSuite(result: Result) {
    context?.let { LevelPlay.launchTestSuite(it) }
    result.success(null)
  }

  /**
   * Adds a listener for receiving impression data events from LevelPlay.
   *
   * @param result The result to be returned after processing.
   */
  private fun addImpressionDataListener(result: Result) {
    LevelPlay.addImpressionDataListener(this)
    result.success(null)
  }

  /**
   * Sets plugin data for LevelPlay mediation.
   * Only called internally in the process of init on the Flutter plugin
   *
   * @param call   The method call containing arguments.
   * @param result The result to be returned after processing.
   */
  private fun setPluginData(call: MethodCall, result: Result) {
    val pluginType = call.argument("pluginType") as String?
      ?: return result.error("ERROR", "pluginType is null", null)
    val pluginVersion = call.argument("pluginVersion") as String?
      ?: return result.error("ERROR", "pluginVersion is null", null)
    val pluginFrameworkVersion = call.argument("pluginFrameworkVersion") as String?

    ConfigFile.getConfigFile().setPluginData(pluginType, pluginVersion, pluginFrameworkVersion)
    result.success(null)
  }

  // endregion

  /** region LevelPlay Init API =================================================================*/

  /**
   * Initializes LevelPlay with the provided app key, ad formats, and optional user ID.
   *
   * @param call The method call containing the app key, ad formats, and optional user ID.
   * @param result The result to be returned after processing.
   */
  private fun init(call: MethodCall, result: Result) {
    if (context == null) {
      return result.error("ERROR", "Context is null", null)
    }
    val appKey = call.argument("appKey") as String?
    val userId = call.argument("userId") as String?
    val requestBuilder = LevelPlayInitRequest.Builder(appKey!!)
    if (userId != null)
      requestBuilder.withUserId(userId)
    val initRequest = requestBuilder.build()

    LevelPlay.init(context!!, initRequest, this)
    result.success(null)
  }

  // endregion

  /** region LevelPlay Interstitial Ad API =================================================================*/

  /**
   * Creates an interstitial ad using the provided ad unit ID.
   *
   * @param call The method call from Flutter containing the ad unit ID parameter
   * @param result The result callback to send the created adId back to Flutter
   */
  private fun createInterstitialAd(call: MethodCall, result: Result) {
    val adUnitId: String = call.argument("adUnitId")!!
    val bidFloor: Double? = call.argument("bidFloor")
    // Create interstitial ad through the manager and get its unique adId
    val adId: String = levelPlayAdObjectManager.createInterstitialAd(adUnitId, bidFloor)
    // Return the adId to Flutter
    result.success(adId)
  }

  /**
   * Loads a LevelPlay interstitial ad.
   *
   * @param call The method call containing the ad instance ID.
   * @param result The result to be returned after processing.
   */
  private fun loadInterstitialAd(call: MethodCall, result: Result) {
    val adId: String = call.argument("adId")!!
    levelPlayAdObjectManager.loadInterstitialAd(adId)
    result.success(null)
  }

  /**
   * Shows a LevelPlay interstitial ad.
   *
   * @param call The method call containing the ad instance ID and optional placement name.
   * @param result The result to be returned after processing.
   */
  private fun showInterstitialAd(call: MethodCall, result: Result) {
    val adId: String = call.argument("adId")!!
    val placementName: String? = call.argument("placementName")
    levelPlayAdObjectManager.showInterstitialAd(adId, placementName)
    result.success(null)
  }

  /**
   * Checks if a LevelPlay interstitial ad is ready to be shown.
   *
   * @param call The method call containing the ad instance ID.
   * @param result The result to be returned containing the ready status as a boolean.
   */
  private fun isInterstitialAdReady(call: MethodCall, result: Result) {
    val adId: String = call.argument("adId")!!
    val isReady = levelPlayAdObjectManager.isInterstitialAdReady(adId)
    result.success(isReady)
  }

  /**
   * Checks whether the specified placement for LevelPlay interstitial ads is capped.
   *
   * @param call The method call containing the placement name.
   * @param result The result to be returned containing the capped status as a boolean.
   */
  private fun isInterstitialAdPlacementCapped(call: MethodCall, result: Result) {
    val placementName: String = call.argument("placementName")!!
    val isCapped = LevelPlayInterstitialAd.isPlacementCapped(placementName)
    result.success(isCapped)
  }

  /**
   * Disposes of a LevelPlay ad instance and releases its resources.
   *
   * @param call The method call containing the ad instance ID.
   * @param result The result to be returned after processing.
   */
  private fun disposeAd(call: MethodCall, result: Result) {
    val adId: String = call.argument("adId")!!
    levelPlayAdObjectManager.disposeAd(adId)
    result.success(null)
  }

  /**
   * Disposes of all LevelPlay ad instances and releases their resources.
   *
   * @param result The result to be returned after processing.
   */
  private fun disposeAllAds(result: Result) {
    levelPlayAdObjectManager.disposeAllAds()
    result.success(null)
  }

  // endregion

  /** region LPMAdSize API =================================================================*/

  /**
   * Creates an adaptive ad size for LevelPlay banner ads.
   *
   * @param call The method call containing the optional width parameter.
   * @param result The result to be returned containing the adaptive ad size data.
   */
  private fun createAdaptiveAdSize(call: MethodCall, result: Result) {
    val width = call.argument("width") as Int?
    val size = context?.let {
      LevelPlayAdSize.createAdaptiveAdSize(it, width)
    }
    result.success(size.toMap())
  }

  // endregion

  /** region LevelPlay Rewarded Ad API =================================================================*/

  /**
   * Creates a rewarded ad using the provided ad unit ID.
   *
   * @param call The method call from Flutter containing the ad unit ID parameter
   * @param result The result callback to send the created adId back to Flutter
   */
  private fun createRewardedAd(call: MethodCall, result: Result) {
    val adUnitId: String = call.argument("adUnitId")!!
    val bidFloor: Double? = call.argument("bidFloor")
    // Create a rewarded ad through the manager and get its unique adId
    val adId: String = levelPlayAdObjectManager.createRewardedAd(adUnitId, bidFloor)
    // Return the adId to Flutter
    result.success(adId)
  }

    /**
     * Loads a LevelPlay rewarded ad.
     *
     * @param call The method call containing the ad instance ID.
     * @param result The result to be returned after processing.
     */
    private fun loadRewardedAd(call: MethodCall, result: Result) {
      val adId: String = call.argument("adId")!!
      levelPlayAdObjectManager.loadRewardedAd(adId)
      result.success(null)
    }

    /**
     * Shows a LevelPlay rewarded ad.
     *
     * @param call The method call containing the ad instance ID and optional placement name.
     * @param result The result to be returned after processing.
     */
    private fun showRewardedAd(call: MethodCall, result: Result) {
      val adId: String = call.argument("adId")!!
      val placementName: String? = call.argument("placementName")
      levelPlayAdObjectManager.showRewardedAd(adId, placementName)
      result.success(null)
    }

    /**
     * Checks if a LevelPlay rewarded ad is ready to be shown.
     *
     * @param call The method call containing the ad instance ID.
     * @param result The result to be returned containing the ready status as a boolean.
     */
    private fun isRewardedAdReady(call: MethodCall, result: Result) {
      val adId: String = call.argument("adId")!!
      val isReady = levelPlayAdObjectManager.isRewardedAdReady(adId)
      result.success(isReady)
    }

  /**
   * Checks whether the specified placement for LevelPlay rewarded ads is capped.
   *
   * @param call The method call containing the placement name.
   * @param result The result to be returned containing the capped status as a boolean.
   */
  private fun isRewardedAdPlacementCapped(call: MethodCall, result: Result) {
    val placementName: String = call.argument("placementName")!!
    val isCapped = LevelPlayRewardedAd.isPlacementCapped(placementName)
    result.success(isCapped)
  }

    /** region LevelPlay Native Ad API ==============================================================================*/

  /**
   * Adds a new native ad view factory to the internal registry and registers it with the Flutter platform view registry.
   *
   * @param viewTypeId           The ID or type of the native ad view factory.
   * @param nativeAdViewFactory  The factory responsible for creating native ad views.
   */
  private fun addNativeAdViewFactory(
    viewTypeId: String,
    nativeAdViewFactory: LevelPlayNativeAdViewFactory
  ) {
    if (nativeAdViewFactories.containsKey(viewTypeId)) {
      Log.e(TAG, "A native ad view factory with ID $viewTypeId already exists.")
      return
    }
    nativeAdViewFactories[viewTypeId] = nativeAdViewFactory
    // Custom Native ad platform view registry
    pluginBinding
      ?.platformViewRegistry
      ?.registerViewFactory(viewTypeId, nativeAdViewFactory)
  }

  /**
   * Removes a native ad view factory from the internal registry based on its viewTypeId ID.
   *
   * @param viewTypeId  The ID of the factory to be removed.
   */
  private fun removeNativeAdViewFactory(viewTypeId: String) {
    nativeAdViewFactories.remove(viewTypeId)
  }

  // endregion

  // endregion

    /** region ActivityAware =======================================================================*/
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
      activity = binding.activity
      levelPlayAdObjectManager.activity = binding.activity
      if (activity is FlutterActivity) {
        (activity as FlutterActivity).lifecycle.addObserver(this)
      } else if (activity is FlutterFragmentActivity) {
        (activity as FlutterFragmentActivity).lifecycle.addObserver(this)
      }
    }

    override fun onDetachedFromActivityForConfigChanges() {
      if (activity is FlutterActivity) {
        (activity as FlutterActivity).lifecycle.removeObserver(this)
      } else if (activity is FlutterFragmentActivity) {
        (activity as FlutterFragmentActivity).lifecycle.removeObserver(this)
      }
      activity = null
      levelPlayAdObjectManager.activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
      if (activity is FlutterActivity) {
        activity = binding.activity as FlutterActivity
        (activity as FlutterActivity).lifecycle.addObserver(this)
      } else if (activity is FlutterFragmentActivity) {
        activity = binding.activity as FlutterFragmentActivity
        (activity as FlutterFragmentActivity).lifecycle.addObserver(this)
      }
      levelPlayAdObjectManager.activity = activity
    }

    override fun onDetachedFromActivity() {
      if (activity is FlutterActivity) {
        (activity as FlutterActivity).lifecycle.removeObserver(this)
      } else if (activity is FlutterFragmentActivity) {
        (activity as FlutterFragmentActivity).lifecycle.removeObserver(this)
      }
      activity = null
      levelPlayAdObjectManager.activity = null
    }

    // endregion

    companion object {
      val TAG: String = LevelPlayMediationPlugin::class.java.simpleName

      /**
       * Registers a native ad view factory with the specified factory ID to be used within the Flutter engine.
       *
       * @param flutterEngine The Flutter engine instance where the native ad view factory will be registered.
       * @param viewTypeId The ID for the native ad view factory.
       * @param nativeAdViewFactory The platform view factory responsible for creating native ad views.
       */
      fun registerNativeAdViewFactory(
        flutterEngine: FlutterEngine,
        viewTypeId: String,
        nativeAdViewFactory: LevelPlayNativeAdViewFactory
      ) {
        try {
          val flutterPlugin =
            flutterEngine.plugins[LevelPlayMediationPlugin::class.java] as LevelPlayMediationPlugin
          flutterPlugin.addNativeAdViewFactory(viewTypeId, nativeAdViewFactory)
        } catch (e: IllegalStateException) {
          Log.e(TAG, "The plugin may have not been registered.")
        }
      }

      /**
       * Unregisters a previously registered native ad view factory from the Flutter engine.
       *
       * @param flutterEngine The Flutter engine instance from which the native ad view factory will be unregistered.
       * @param viewTypeId The ID of the native ad view factory to be unregistered.
       */
      fun unregisterNativeAdViewFactory(
        flutterEngine: FlutterEngine,
        viewTypeId: String
      ) {
        try {
          val flutterPlugin =
            flutterEngine.plugins[LevelPlayMediationPlugin::class.java] as LevelPlayMediationPlugin
          flutterPlugin.removeNativeAdViewFactory(viewTypeId)
        } catch (e: IllegalStateException) {
          Log.e(TAG, "The plugin may have not been registered.")
        }
      }
    }

  override fun onInitFailed(error: LevelPlayInitError) {
    channel?.let { LevelPlayUtils.invokeMethodOnUiThread(it, "onInitFailed", error.toMap()) }
  }

  override fun onInitSuccess(configuration: LevelPlayConfiguration) {
    channel?.let { LevelPlayUtils.invokeMethodOnUiThread(it, "onInitSuccess", configuration.toMap()) }
  }

  override fun onImpressionSuccess(impressionData: LevelPlayImpressionData) {
    channel?.let { LevelPlayUtils.invokeMethodOnUiThread(it, "onImpressionSuccess", impressionData.toMap()) }
  }
}


