//
//  ViewController.swift
//  RunnerMate
//
//  Created by Herbert Dodge on 5/23/21.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    
    let runView = RunView()
    let controlButtons = RunControlView()

    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthStatus()
        configure()
    }


    func configure() {
        view.backgroundColor = .systemBackground
        view.addSubview(runView)
        runView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingRight: 10, width: 400, height: 425)
        
        runView.delegate = self
        
        view.addSubview(controlButtons)
        controlButtons.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 20, paddingBottom: 10, paddingRight: 20, width: runView.frame.width, height: 250)
    }
}

extension MapVC: MKMapViewDelegate {
    
    func checkLocationAuthStatus() {
        if LocationServices.shared.locationManger.authorizationStatus == .authorizedWhenInUse {
//            runView.mapView.showsUserLocation = true
            runView.mapView.showsUserLocation = true
        } else {
            LocationServices.shared.locationManger.requestWhenInUseAuthorization()
        }
    }
    
    func centerMapOnUserLocation(coordinates: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 500, longitudinalMeters: 500)
        runView.mapView.setRegion(region, animated: true)
    }
}
