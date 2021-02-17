//
//  LocationManager.swift
//  Fisherman's diary
//
//  Created by Егор Никитин on 03.02.2021.
//

import Foundation
import CoreLocation

struct LocationCoordinate {
    var latitude: Double
    var longitude: Double
    
    static func create(location: CLLocation) -> LocationCoordinate {
        return LocationCoordinate(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
    }
}

final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    static let sharedInstance = LocationManager()
    
    var manager = CLLocationManager()
    
    var blockForSave: ((LocationCoordinate) -> Void)?
    
    func requestAuthorization() {
        manager.requestWhenInUseAuthorization()
    }
    
    func getCurrentLocation(completion: ((LocationCoordinate) -> Void)?) {
        
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse {
            print("Пользователь не дал согласие на обработку локации")
            return
        }
        
        blockForSave = completion
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.activityType = .other
        
        manager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let lc = LocationCoordinate.create(location: locations.last!)
        blockForSave?(lc)
        
        manager.stopUpdatingLocation()
    }
    
}
