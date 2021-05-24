//
//  MapView.swift
//  RunnerMate
//
//  Created by Herbert Dodge on 5/23/21.
//

import UIKit
import MapKit

class MapView: UIView {

    let mapView = MKMapView()
    
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addRoundedCornerAndShadow()
        
        addSubview(mapView)
        
        mapView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
        mapView.layer.cornerRadius = 20
        
        
    }
    
}
