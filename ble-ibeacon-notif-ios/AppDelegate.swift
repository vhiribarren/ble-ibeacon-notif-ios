//
//  AppDelegate.swift
//  ble-ibeacon-notif-ios
//
//  Created by Vincent Hiribarren on 23/02/2019.
//  Copyright © 2019 Vincent Hiribarren. All rights reserved.
//

import os.log
import UIKit
import CoreLocation
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    
    var window: UIWindow?
    let notificationCenter = UNUserNotificationCenter.current()
    let locationManager = CLLocationManager()

    let beaconUuid = UUID(uuidString: "00112233-4455-6677-8899-aabbccddeeff")!
    let beaconMajor:CLBeaconMajorValue = 0
    let beaconMinor:CLBeaconMajorValue = 0
    let beaconIdentifier = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String
        ?? "ble-ibeacon-notif-ios"
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        notificationCenter.delegate = self
        locationManager.delegate = self
        detectBeacon()
        return true
    }
    
    
    func detectBeacon() {
        os_log("Start beacon detection.", type: .info)
        // If identifier vary, several monitoring start are done without canceling the previous one
        let region = CLBeaconRegion(proximityUUID: beaconUuid, major: beaconMajor, minor: beaconMinor, identifier : beaconIdentifier)
        region.notifyOnEntry = true
        region.notifyOnExit = true
        region.notifyEntryStateOnDisplay = true
        locationManager.startMonitoring(for: region)
    }

    
    func displayNotification(message: String) {
        let content = UNMutableNotificationContent()
        content.title = "iBeacon Notification"
        content.body = message
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: nil)
        notificationCenter.add(request) { (error) in
            if let error = error {
                os_log("%{public}@", type: .error, error.localizedDescription)
            }
        }
    }
    
}


extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
    
}


extension AppDelegate : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        os_log("iBeacon didEnterRegion.", type: .info)
        displayNotification(message: "enter")
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        os_log("iBeacon didExitRegion.", type: .info)
        displayNotification(message: "exit")
    }
    
}

