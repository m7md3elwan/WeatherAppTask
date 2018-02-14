//
//  LocationManager.swift
//  WeatherAppTask
//
//  Created by Mohamed Mostafa on 2/8/18.
//  Copyright © 2018 Elwan. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

enum LocationServiceState {
    case notEnabled
    case denied
    case allowed
    case notDetermined
}

protocol LocationManagerDelegate {
    func locationManager(didUpdateLocation location:CLLocation)
    func locationManager(didChangeAuthorization status:LocationServiceState)
}

class LocationManager: NSObject {
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocation?
    var delegate: LocationManagerDelegate?
    
    override init() {
        super.init()
        
        self.locationManager = CLLocationManager()
        guard let locationManager = self.locationManager else {
            return
        }
        
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.delegate = self
    }
    
    static let shared : LocationManager = {
        let instance = LocationManager()
        return instance
    }()
    
    func getLocationServiceState() -> LocationServiceState {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined:
                return .notDetermined
            case .restricted, .denied:
                return .denied
            case .authorizedAlways, .authorizedWhenInUse:
                return .allowed
            }
        } else {
            return .notEnabled
        }
    }
    
    func openLocationSettings() {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string:"App-Prefs:root=LOCATION_SERVICES")!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(URL(string:"App-Prefs:root=LOCATION_SERVICES")!)
        }
    }
    
    func openAppLocationSetting() {
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        }
    }
    
    func startUpdatingLocation() {
        self.locationManager!.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        self.locationManager!.stopUpdatingLocation()
    }
}


extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        self.currentLocation = location
        delegate?.locationManager(didUpdateLocation: location)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        delegate?.locationManager(didChangeAuthorization:getLocationServiceState())
    }

}
