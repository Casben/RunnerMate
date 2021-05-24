//
//  Runner.swift
//  RunnerMate
//
//  Created by Herbert Dodge on 5/23/21.
//

import UIKit
import MapKit

class Runner: NSObject, MKAnnotation {
    var title: String? = "We started our route here."
    var subtitle: String? = "Tap for directions"
    var coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}
