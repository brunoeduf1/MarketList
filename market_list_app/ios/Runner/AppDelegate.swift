import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
override func application(
_ application: UIApplication,
didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
) -> Bool {
FirebaseApp.configure()
GeneratedPluginRegistrant.register(with: self)
return true
// original line was:
// super.application(application, didFinishLaunchingWithOptions: launchOptions) //this line was working on older versions of
// iOS and stop working with iOS 14.7.1, at least in my case.
}
}
