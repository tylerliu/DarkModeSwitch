//
//  LocationBackground.swift
//  DarkModeSwitcher
//
//  Created by Tyler on 2018/11/22.
//  Copyright © 2018 Tyler Liu. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService : NSObject, CLLocationManagerDelegate {
    
    static let locationManager = CLLocationManager()
    static private let shared = LocationService()
    static private var initialized = false;
    
    static func initiatize() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = shared
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        }
        initialized = true;
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        Preference.setLocation(lat: locValue.latitude, lon: locValue.longitude)
        //print("locations = \(locValue.latitude) \(locValue.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //print("No Location Found")
    }
    
    static func startMonitor() {
        if !initialized {
            initiatize()
            update()
        }
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    static func stopMonitor() {
        locationManager.stopMonitoringSignificantLocationChanges()
    }
    
    static func update() {
        locationManager.requestLocation()
    }
    
    static func approximateLonFromTZ() -> Double {
        var lon = Double(TimeZone.current.secondsFromGMT()) / 240.0
        if lon > 180.1 {
            lon -= 360
        }
        if lon < -180.1 {
            lon += 360
        }
        return lon
    }
}
