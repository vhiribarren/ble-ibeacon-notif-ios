//
//  ViewController.swift
//  ble-ibeacon-notif-ios
//
//  Created by Vincent Hiribarren on 23/02/2019.
//  Copyright © 2019 Vincent Hiribarren. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications


class ViewController: UIViewController {

    
    private let locationManager = CLLocationManager()
    private let notificationCenter = UNUserNotificationCenter.current()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        askAuthorizations()
    }

    
    func askAuthorizations() {
        locationManager.requestAlwaysAuthorization()
        notificationCenter.requestAuthorization(options: [.alert]) { (granted, error) in
        }
    }
    
    
}
