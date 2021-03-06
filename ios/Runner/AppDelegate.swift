import UIKit
import Flutter
import WidgetKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    let defaults = UserDefaults.standard
    
    
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(name: "eu.araulin.devinci/channel",
                                           binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            print(call.method);
            switch call.method {
            case "changeIcon":
                let iconId = call.arguments as! Int
                self.changeIcon(iconId:iconId, result: result)
                return
            case "showDialog":
                let dic = call.arguments as! Dictionary<String, String>
                self.showDialog(result:result, dic:dic)
                return
            case "setICal":
                let url = call.arguments as! String
                self.setICal(result: result, url: url)
                return
            default:
                result(FlutterMethodNotImplemented)
                return
            }
            
        })
        
        GeneratedPluginRegistrant.register(with: self)
        
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    private func changeIcon(iconId: Int,result: @escaping FlutterResult){
        if UIApplication.shared.supportsAlternateIcons {
                var iconName = "iconwhitea"
                switch iconId {
                    case 1:
                        iconName = "iconblacka"
                    case 2: 
                        iconName = "iconwhiteb"
                    case 3: 
                        iconName = "iconblackb"
                    default:
                        iconName = "iconwhitea"
                }
                UIApplication.shared.setAlternateIconName(iconName){ error in
                    if let error = error {
                        print(error.localizedDescription)
                        result(FlutterError(code: "ERROR",
                        message: error.localizedDescription,
                        details: nil))
                    } else {
                        result(true)
                    }
                }
            }
    }
    
    private func setICal(result: @escaping FlutterResult, url: String){
        let defaults = UserDefaults(suiteName: "group.eu.araulin.devinciApp")
        defaults?.set(url, forKey: "ical")
        print("ical set");
        if #available(iOS 14, *) {
            WidgetCenter.shared.reloadAllTimelines()
        } else {
            // show sad face emoji
        }
        result(true)
    }

    private func showDialog(result: @escaping FlutterResult, dic: Dictionary<String, String>){
        
        let alert = UIAlertController(title: dic["title"], message: dic["content"], preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: dic["ok"], style: .default, handler: { action in
    result(true)
}))
        alert.addAction(UIAlertAction(title: dic["cancel"], style: .cancel, handler: { action in
    result(false)
}))

        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true)
        
    }

}
