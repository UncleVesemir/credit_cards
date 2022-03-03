import UIKit
import Flutter
import CoreMotion

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      
      let METHOD_CHANNEL = "training/method"
      let PRESSURE_CHANNEL = "training/pressure"
      let pressureStreamHandler = PressureStreamHandler()
      
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let methodChannel = FlutterMethodChannel(name: METHOD_CHANNEL, binaryMessenger: controller.binaryMessenger)
      
      methodChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          switch call.method {
          case "isSensorAvailable" : result(CMAltimeter.isRelativeAltitudeAvailable())
          default: result(FlutterMethodNotImplemented)
          }
      })
      
      let pressureChannel = FlutterEventChannel(name: PRESSURE_CHANNEL, binaryMessenger: controller.binaryMessenger)
      pressureChannel.setStreamHandler(pressureStreamHandler)
      
      ///
      
      let batteryChannel = FlutterMethodChannel(name: "training/battery",
                                                binaryMessenger: controller.binaryMessenger)
      batteryChannel.setMethodCallHandler({
        [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
        // Note: this method is invoked on the UI thread.
        guard call.method == "getBatteryLevel" else {
          result(FlutterMethodNotImplemented)
          return
        }
        self?.receiveBatteryLevel(result: result)
      })
      
      ///
      
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func receiveBatteryLevel(result: FlutterResult) {
      let device = UIDevice.current
      device.isBatteryMonitoringEnabled = true
      if device.batteryState == UIDevice.BatteryState.unknown {
        result(FlutterError(code: "UNAVAILABLE",
                            message: "Battery info unavailable",
                            details: nil))
      } else {
        result(Int(device.batteryLevel * 100))
      }
    }
}


