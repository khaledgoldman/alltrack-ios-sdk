//
//  AppDelegate.swift
//  AlltrackExample-Swift
//
//  Created by Uglješa Erceg (@uerceg) on 6th April 2016.
//  Copyright © 2016-Present Alltrack GmbH. All rights reserved.
//

import UIKit
import Alltrack

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AlltrackDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let appToken = "2fm9gkqubvpc"
        let environment = ALTEnvironmentSandbox
        let alltrackConfig = ALTConfig(appToken: appToken, environment: environment)
        
        // Change the log level.
        alltrackConfig?.logLevel = ALTLogLevelVerbose
        
        // Enable event buffering.
        // alltrackConfig?.eventBufferingEnabled = true
        
        // Set default tracker.
        // alltrackConfig?.defaultTracker = "{TrackerToken}"
        
        // Send in the background.
        // alltrackConfig?.sendInBackground = true
        
        // Enable COPPA compliance
        // alltrackConfig?.coppaCompliantEnabled = true
        
        // Set delegate object.
        alltrackConfig?.delegate = self
        
        // Delay the first session of the SDK.
        // alltrackConfig?.delayStart = 7
        
        // Add session callback parameters.
        Alltrack.addSessionCallbackParameter("obi", value: "wan")
        Alltrack.addSessionCallbackParameter("master", value: "yoda")
        
        // Add session partner parameters.
        Alltrack.addSessionPartnerParameter("darth", value: "vader")
        Alltrack.addSessionPartnerParameter("han", value: "solo")
        
        // Remove session callback parameter.
        Alltrack.removeSessionCallbackParameter("obi")
        
        // Remove session partner parameter.
        Alltrack.removeSessionPartnerParameter("han")
        
        // Remove all session callback parameters.
        // Alltrack.resetSessionCallbackParameters()
        
        // Remove all session partner parameters.
        // Alltrack.resetSessionPartnerParameters()
        
        // Initialise the SDK.
        Alltrack.appDidLaunch(alltrackConfig!)
        
        // Put the SDK in offline mode.
        // Alltrack.setOfflineMode(true);
        
        // Disable the SDK
        // Alltrack.setEnabled(false);
        
        // Interrupt delayed start set with setDelayStart: method.
        // Alltrack.sendFirstPackages()
        
        return true
    }
    
    func application(_ application: UIApplication, handleOpen url: URL) -> Bool {
        NSLog("Scheme based deep link opened an app: %@", url.absoluteString)
        // Pass deep link to Alltrack in order to potentially reattribute user.
        Alltrack.appWillOpen(url)
        return true
    }
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        if (userActivity.activityType == NSUserActivityTypeBrowsingWeb) {
            NSLog("Universal link opened an app: %@", userActivity.webpageURL!.absoluteString)
            // Pass deep link to Alltrack in order to potentially reattribute user.
            Alltrack.appWillOpen(userActivity.webpageURL!)
        }
        return true
    }
    
    func alltrackAttributionChanged(_ attribution: ALTAttribution?) {
        NSLog("Attribution callback called!")
        NSLog("Attribution: %@", attribution ?? "")
    }
    
    func alltrackEventTrackingSucceeded(_ eventSuccessResponseData: ALTEventSuccess?) {
        NSLog("Event success callback called!")
        NSLog("Event success data: %@", eventSuccessResponseData ?? "")
    }
    
    func alltrackEventTrackingFailed(_ eventFailureResponseData: ALTEventFailure?) {
        NSLog("Event failure callback called!")
        NSLog("Event failure data: %@", eventFailureResponseData ?? "")
    }
    
    func alltrackSessionTrackingSucceeded(_ sessionSuccessResponseData: ALTSessionSuccess?) {
        NSLog("Session success callback called!")
        NSLog("Session success data: %@", sessionSuccessResponseData ?? "")
    }
    
    func alltrackSessionTrackingFailed(_ sessionFailureResponseData: ALTSessionFailure?) {
        NSLog("Session failure callback called!");
        NSLog("Session failure data: %@", sessionFailureResponseData ?? "")
    }
    
    func alltrackDeeplinkResponse(_ deeplink: URL?) -> Bool {
        NSLog("Deferred deep link callback called!")
        NSLog("Deferred deep link URL: %@", deeplink?.absoluteString ?? "")
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Show ATT dialog.
        Alltrack.requestTrackingAuthorization { status in
            switch status {
            case 0:
                // ATTrackingManagerAuthorizationStatusNotDetermined case
                break
            case 1:
                // ATTrackingManagerAuthorizationStatusRestricted case
                break
            case 2:
                // ATTrackingManagerAuthorizationStatusDenied case
                break
            case 3:
                // ATTrackingManagerAuthorizationStatusAuthorized case
                break
            default:
                break
            }
        }
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
}
