package com.fused

import android.content.Intent
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val serviceChannel = "com.fused/service"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        FlutterEngineCache.getInstance().put("main", flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, serviceChannel).setMethodCallHandler { call, result ->
            when (call.method) {
                "startForeground" -> {
                    startSmsForegroundService()
                    result.success(true)
                }
                "stopForeground" -> {
                    stopSmsForegroundService()
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun startSmsForegroundService() {
        val intent = Intent(this, SmsForegroundService::class.java)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            startForegroundService(intent)
        } else {
            startService(intent)
        }
    }

    private fun stopSmsForegroundService() {
        val intent = Intent(this, SmsForegroundService::class.java).apply { action = SmsForegroundService.ACTION_STOP }
        startService(intent)
    }

    override fun onDestroy() {
        FlutterEngineCache.getInstance().remove("main")
        super.onDestroy()
    }
}
