//
//  LocationServices.swift
//  RunnerMate
//
//  Created by Herbert Dodge on 5/31/21.
//

import Foundation
import CoreLocation

protocol CustomUserLocationDelegate {
    func userLocationUpdated(location: CLLocation)
}

class LocationServices: NSObject, CLLocationManagerDelegate {
    
    //MARK: - Properties
    
    static let shared = LocationServices()
    
    var delegate: CustomUserLocationDelegate?
    
    var locationManger = CLLocationManager()
    var currentLocation: CLLocationCoordinate2D?
    
    //MARK: - Lifecycle
    
    override init() {
        super.init()
        self.locationManger.delegate = self
        self.locationManger.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManger.distanceFilter = 10
        self.locationManger.startUpdatingLocation()
    }
    
    //MARK: - Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.currentLocation = manager.location?.coordinate
        
        if delegate != nil {
            delegate?.userLocationUpdated(location: locations.first!)
        }
    }
}
