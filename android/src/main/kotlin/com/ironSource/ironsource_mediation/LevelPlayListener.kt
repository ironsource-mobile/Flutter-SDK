package com.ironSource.ironsource_mediation

import io.flutter.plugin.common.MethodChannel

abstract class LevelPlayListener(protected val channel: MethodChannel) {

  protected fun invokeMethod(methodName: String, args: Map<String, Any?>? = null) {
    LevelPlayUtils.invokeMethodOnUiThread(channel, methodName, args)
  }
}