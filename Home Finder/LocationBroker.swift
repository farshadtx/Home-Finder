//
//  LocationBroker.swift
//  Home Finder
//
//  Created by Farshad on 3/26/17.
//  Copyright © 2017 WolfskiN. All rights reserved.
//

import Foundation
import CoreLocation
import PromiseKit

let midnight: Int = 10

class LocationBroker: NSObject, CLLocationManagerDelegate {
    let locationManager: CLLocationManager!
    var isDeferring: Bool = false
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 100
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = true
    }
    
    func askPermission() {
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            locationManager.requestAlwaysAuthorization()
        }
    }

    func getLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        isDeferring = false
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let now = Date()
        
        let morningLocations = locations.filter { location in
            location.timestamp.hour == midnight
        }
        
        if let location = morningLocations.first {
            UserDefaults.standard.set("\(location.coordinate.latitude), \(location.coordinate.longitude) - \(location.timestamp.hour):\(location.timestamp.minute)", forKey: "lastLocation")
        } else {
            print("No Update! - \(now.hour):\(now.minute)")
        }
        
        if !isDeferring {
            var morningTime: Date
            if now.hour < midnight {
                morningTime = try! now.atTime(hour: midnight, minute: 0, second: 0)
            } else {
                morningTime = try! now.at(unitsWithValues: [.day: now.day + 1,
                                                            .hour: midnight,
                                                            .minute: 0,
                                                            .second: 0])
            }
            locationManager.allowDeferredLocationUpdates(untilTraveled: CLLocationDistanceMax, timeout: morningTime.timeIntervalSince(now))
            isDeferring = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let now = Date()
        print("No Update! - \(now.hour):\(now.minute)")
    }
}
