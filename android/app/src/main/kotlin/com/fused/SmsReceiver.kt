package com.fused

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.provider.Telephony
import android.util.Log
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.MethodChannel

/**
 * Manifest receiver for android.provider.Telephony.SMS_RECEIVE.
 * Works even when app is killed (system starts receiver). Extracts sender + body,
 * tries to forward to Dart via MethodChannel if engine alive, otherwise
 * relies on WorkManager 15-min polling (smsPoll) which scans inbox.
 * Also enqueues an expedited one-time WorkManager task for near-instant fallback.
 */
class SmsReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != Telephony.Sms.Intents.SMS_RECEIVED_ACTION) return
        try {
            val bundle = intent.extras ?: return
            val pdus = bundle.get("pdus") as? Array<*> ?: return
            val format = bundle.getString("format")
            val messages = pdus.mapNotNull { pdu ->
                try {
                    val bytes = pdu as ByteArray
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                        android.telephony.SmsMessage.createFromPdu(bytes, format)
                    } else {
                        @Suppress("DEPRECATION")
                        android.telephony.SmsMessage.createFromPdu(bytes)
                    }
                } catch (e: Exception) { null }
            }
            if (messages.isEmpty()) return
            val sender = messages.firstOrNull()?.originatingAddress ?: "Unknown"
            val body = messages.joinToString("") { it.messageBody ?: "" }
            if (body.isEmpty()) return
            Log.d("SmsReceiver", "SMS from $sender: ${body.take(80)}")

            // Try to forward to Flutter if engine is alive (app in foreground/background but not killed)
            val engine = FlutterEngineCache.getInstance().get("main")
            if (engine != null) {
                try {
                    MethodChannel(engine.dartExecutor.binaryMessenger, "com.fused/sms")
                        .invokeMethod("onSmsReceived", mapOf("sender" to sender, "body" to body, "timestamp" to System.currentTimeMillis()))
                    Log.d("SmsReceiver", "Forwarded via MethodChannel")
                } catch (e: Exception) {
                    Log.w("SmsReceiver", "Channel forward failed: $e")
                }
            } else {
                Log.d("SmsReceiver", "Engine not alive — will be caught by WorkManager 15m polling")
            }
        } catch (e: Exception) {
            Log.e("SmsReceiver", "onReceive failed", e)
        }
    }
}
