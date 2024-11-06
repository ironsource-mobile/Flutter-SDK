package com.ironSource.ironsource_mediation

import com.unity3d.mediation.LevelPlayConfiguration
import com.unity3d.mediation.LevelPlayInitError
import com.unity3d.mediation.LevelPlayInitListener
import io.flutter.plugin.common.MethodChannel

class LevelPlayInitListener(channel: MethodChannel) : LevelPlayListener(channel), LevelPlayInitListener {

    override fun onInitFailed(error: LevelPlayInitError) {
        invokeMethod("onInitFailed", error.toMap())
    }

    override fun onInitSuccess(configuration: LevelPlayConfiguration) {
        invokeMethod("onInitSuccess", configuration.toMap())
    }
}