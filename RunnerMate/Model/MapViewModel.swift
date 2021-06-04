//
//  MapVCViewModel.swift
//  RunnerMate
//
//  Created by Herbert Dodge on 5/31/21.
//

import Foundation
import CoreLocation

class MapViewModel {
    
    static let shared = MapViewModel()
    var savedCoordinates: CLLocationCoordinate2D?
    var runInProgress: Bool?
    
    func saveRunData(withCoordinates coordinates: CLLocationCoordinate2D) {
        let latitude = coordinates.latitude
        let longitude = coordinates.longitude
        
        userDefaults.setValue(latitude, forKey: UserDefaultsKeys.latitude)
        userDefaults.setValue(longitude, forKey: UserDefaultsKeys.longitude)
    }
    
    func loadRunData() {
        guard let latitude = userDefaults.object(forKey: UserDefaultsKeys.latitude), let longitude = userDefaults.object(forKey: UserDefaultsKeys.longitude) else { return }
        savedCoordinates = CLLocationCoordinate2D(latitude: latitude as! CLLocationDegrees, longitude: longitude as! CLLocationDegrees)
        runInProgress = true
    }
    
    func checkIfRunDataExsists() -> Bool {
        guard (userDefaults.object(forKey: UserDefaultsKeys.latitude) != nil) && (userDefaults.object(forKey: UserDefaultsKeys.longitude) != nil) else { return false }
        return true
    }
    
    func reset() {
        userDefaults.removeObject(forKey: UserDefaultsKeys.latitude)
        userDefaults.removeObject(forKey: UserDefaultsKeys.longitude)
        savedCoordinates = nil
    }
}
