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


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        notificationCenter.delegate = self
        locationManager.delegate = self
        detectBeacon()
        return true
    }
    
    
    func detectBeacon() {
        os_log("Start beacon detection.", type: .info)
        let uuid = UUID(uuidString: "00112233-4455-6677-8899-aabbccddeeff")
        let major:CLBeaconMajorValue = 0
        let minor:CLBeaconMinorValue = 0
        let identifier = UUID().uuidString
        let region = CLBeaconRegion(proximityUUID: uuid!, major: major, minor: minor, identifier: identifier)
        region.notifyOnEntry = true
        region.notifyOnExit = true
        region.notifyEntryStateOnDisplay = true
        locationManager.startMonitoring(for: region)
        //locationManager.startRangingBeacons(in: region)
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

