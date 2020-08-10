import UIKit
import Flutter
import AWSMobileClient

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    var navigationController: UINavigationController?
    var storyboard: UIStoryboard?
    
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    let channelName = "flutter.native/helper";
    
    //let rootViewController : FlutterViewController = window?.rootViewController as! FlutterViewController
    
    // video stuff starts here
    
    // this is from SO
    
   let flutterViewController = FlutterViewController()
    self.navigationController = UINavigationController(rootViewController: flutterViewController)
    self.navigationController?.isNavigationBarHidden = true
    
    self.window = UIWindow(frame: UIScreen.main.bounds)
    self.window.rootViewController = self.navigationController
    self.window.makeKeyAndVisible()
    
    //SO ends here
    
    let methodChannel = FlutterMethodChannel(name: channelName, binaryMessenger: flutterViewController.binaryMessenger)
    
    methodChannel.setMethodCallHandler {(call: FlutterMethodCall, result: FlutterResult) -> Void in
        if (call.method == "test") {
            // setup logging
            AWSDDLog.sharedInstance.logLevel = .verbose

            // setup service configuration
            let serviceConfiguration = AWSServiceConfiguration(region: cognitoIdentityUserPoolRegion, credentialsProvider: nil)

            // create pool configuration
            let poolConfiguration = AWSCognitoIdentityUserPoolConfiguration(clientId: cognitoIdentityUserPoolAppClientId,
                                                                            clientSecret: cognitoIdentityUserPoolAppClientSecret,
                                                                            poolId: cognitoIdentityUserPoolId)

            // initialize user pool client
            AWSCognitoIdentityUserPool.register(with: serviceConfiguration, userPoolConfiguration: poolConfiguration, forKey: awsCognitoUserPoolsSignInProviderKey)
            
            
            AWSMobileClient.default().initialize { (userState, error) in
                
                if let error = error {
                    print("error: \(error.localizedDescription)")

                    return
                }

                guard let userState = userState else {
                    return
                }
                print("The user is \(userState.rawValue).")
                
                AWSMobileClient.default().signIn(username: "rohandalvi", password: "Hrithik1!", completionHandler: { (signInResult, error) in
                    debugPrint("LoginState: \(signInResult?.signInState)")
                    DispatchQueue.main.async {
                        self.storyboard = UIStoryboard(name: "Video", bundle: nil)
                        
                        if #available(iOS 13.0, *) {
                            let uiViewController = self.storyboard!.instantiateViewController(identifier: "channelConfig")
                            self.navigationController!.present(uiViewController, animated: true, completion: nil);
                            //self.navigationController?.pushViewController(uiViewController, animated: true)
                        } else {
                            // Fallback on earlier versions
                            let uiViewController = self.storyboard!.instantiateViewController(withIdentifier: "channelConfig")
                            self.navigationController!.present(uiViewController, animated: true, completion: nil);
                            //self.navigationController?.pushViewController(uiViewController, animated: true)
                        }
                    }
                })
            }
            
            
            result("Jabri");
        } else {
                result(FlutterMethodNotImplemented)
        }
        
    }
    
    
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    var orientationLock = UIInterfaceOrientationMask.all

    override func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return self.orientationLock
    }
    
    struct AppUtility {
        static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                delegate.orientationLock = orientation
            }
        }

        static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation: UIInterfaceOrientation) {
            self.lockOrientation(orientation)
            UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        }
    }
}
