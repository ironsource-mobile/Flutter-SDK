package com.ironSource.ironsource_mediation_example

import com.ironSource.ironsource_mediation.IronSourceMediationPlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {
    private val viewType = "ExampleViewType"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        // Custom native ad view template must be registered here
        IronSourceMediationPlugin.registerNativeAdViewFactory(flutterEngine, viewType, NativeAdViewFactoryExample(flutterEngine.dartExecutor.binaryMessenger, R.layout.my_custom_native_ad_view))
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)
        // Custom native ad view template must be unregistered here
        IronSourceMediationPlugin.unregisterNativeAdViewFactory(flutterEngine, viewType)
    }
}

