import Flutter
import UIKit

public class SwiftImageDimensionFinderFlutterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "image_dimension_finder_flutter", binaryMessenger: registrar.messenger())
    let instance = SwiftImageDimensionFinderFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }

  public func dummyMethodToEnforceBundling() {
    dummy_method_to_enforce_bundling()
  }
}