package com.example.credit_cards

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

import android.content.Context
import android.content.ContextWrapper
import android.content.Intent
import android.content.IntentFilter
import android.hardware.Sensor
import android.hardware.SensorManager
import android.os.BatteryManager
import android.os.Build.VERSION
import android.os.Build.VERSION_CODES
import android.os.Messenger
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel

class MainActivity: FlutterActivity() {

    private val BATTERY_CHANNEL = "training/battery";
    private val PRESSURE_METHOD = "training/method";
    private val PRESSURE_CHANNEL = "training/pressure";

    private var methodChannel: MethodChannel? = null
    private lateinit var sensorManager: SensorManager
    private var pressureChannel: EventChannel? = null
    private var pressureStreamHandler: StreamHandler? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        setupChannels(this, flutterEngine.dartExecutor.binaryMessenger)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, BATTERY_CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "getBatteryLevel") {
                val batteryLevel = getBatteryLevel()

                if (batteryLevel != -1) {
                    result.success(batteryLevel)
                } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onDestroy() {
        teardownChannels()
        super.onDestroy()
    }

    private fun setupChannels(context: Context, messenger: BinaryMessenger) {

        sensorManager = context.getSystemService(Context.SENSOR_SERVICE) as SensorManager
        methodChannel = MethodChannel(messenger, PRESSURE_METHOD)

        methodChannel!!.setMethodCallHandler {
            call, result ->
            if (call.method == "isSensorAvailable") {
                result.success(sensorManager!!.getSensorList(Sensor.TYPE_PRESSURE).isNotEmpty())
            } else {
                result.notImplemented()
            }
        }

        pressureChannel = EventChannel(messenger, PRESSURE_CHANNEL)
        pressureStreamHandler = StreamHandler(sensorManager!!, Sensor.TYPE_PRESSURE)
        pressureChannel!!.setStreamHandler(pressureStreamHandler)
    }

    private fun teardownChannels() {
        methodChannel!!.setMethodCallHandler(null)
        pressureChannel!!.setStreamHandler(null)
    }

    private fun getBatteryLevel() : Int {
        val batteryLevel: Int = if (VERSION.SDK_INT >= VERSION_CODES.LOLLIPOP) {
            val batteryManager = getSystemService(Context.BATTERY_SERVICE) as BatteryManager
            batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        } else {
            val intent = ContextWrapper(applicationContext).registerReceiver(null, IntentFilter(Intent.ACTION_BATTERY_CHANGED))
            intent!!.getIntExtra(BatteryManager.EXTRA_LEVEL, -1) * 100 / intent.getIntExtra(BatteryManager.EXTRA_SCALE, -1)
        }
        return batteryLevel
    }
}
