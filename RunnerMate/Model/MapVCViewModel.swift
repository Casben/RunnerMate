//
//  MapVCViewModel.swift
//  RunnerMate
//
//  Created by Herbert Dodge on 5/31/21.
//

import Foundation
import CoreLocation

class MapVCViewModel {
    static let shared = MapVCViewModel()
    var savedCoordinates: CLLocationCoordinate2D?
    
    func saveRunData(withCoordinates coordinates: CLLocationCoordinate2D) {
        let latitude = coordinates.latitude
        let longitude = coordinates.longitude
        
        userDefaults.setValue(latitude, forKey: "latitude")
        userDefaults.setValue(longitude, forKey: "longitude")
    }
    
    func loadRunData() -> Bool {
        guard let latitude = userDefaults.object(forKey: "latitude"), let longitude = userDefaults.object(forKey: "longitude") else { return false }
        savedCoordinates = CLLocationCoordinate2D(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees)
        return true
    }
}
