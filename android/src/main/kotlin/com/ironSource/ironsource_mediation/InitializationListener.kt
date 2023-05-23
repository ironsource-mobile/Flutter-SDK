package com.ironSource.ironsource_mediation

import com.ironsource.mediationsdk.sdk.InitializationListener
import io.flutter.plugin.common.MethodChannel

class InitializationListener(channel: MethodChannel) : IronSourceListener(channel),
    InitializationListener {
  override fun onInitializationComplete() {
    invokeMethod("onInitializationComplete")
  }
}