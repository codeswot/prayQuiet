import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "com.geeksaxis.pray_quiet.dnd_channel", binaryMessenger: controller.binaryMessenger)
    channel.setMethodCallHandler({
      [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
      if call.method == "setDoNotDisturb" {
        if let args = call.arguments as? Bool {
          self?.setDoNotDisturb(enabled: args)
          result(nil)
        } else {
          result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments", details: nil))
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func setDoNotDisturb(enabled: Bool) {
    let notificationCenter = UNUserNotificationCenter.current()
    notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
      if granted {
        let content = UNMutableNotificationContent()
        content.title = "Title"
        content.body = "Body"
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "DNDNotification", content: content, trigger: trigger)

        notificationCenter.add(request) { (error) in
          if let error = error {
            print("Error adding notification request: \(error)")
          }
        }
      }
    }

    let dndMode: UIUserNotificationSettings
    if enabled {
      dndMode = UIUserNotificationSettings(types: .alert, categories: nil)
    } else {
      dndMode = UIUserNotificationSettings(types: [], categories: nil)
    }

    UIApplication.shared.registerUserNotificationSettings(dndMode)
    UIApplication.shared.registerForRemoteNotifications()
  }
}
