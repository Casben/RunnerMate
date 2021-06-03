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
    let controlView = RunControlView()
    
    var runnerAnnotation: Runner?
    var startCoordinates: CLLocationCoordinate2D?

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
        
        view.addSubview(controlView)
        controlView.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 20, paddingBottom: 10, paddingRight: 20, width: runView.frame.width, height: 250)
        
        controlView.delegate = self
        restoreSaveRunData()
    }
    
    func restoreSaveRunData() {
        if MapVCViewModel.shared.loadRunData() {
            setupAnnotation(coordinate: MapVCViewModel.shared.savedCoordinates!)
        }
    }
    
    func resetMapVC() {
        RunControlViewModel.shared.reset()
        MapVCViewModel.shared.reset()
        controlView.reset()
        runView.mapView.removeAnnotations(runView.mapView.annotations)
        runView.mapView.removeAnnotations(runView.mapView.annotations)
        runView.mapView.overlays.forEach { runView.mapView.removeOverlay($0) }
    }
}

extension MapVC: MKMapViewDelegate {
    
    func checkLocationAuthStatus() {
        if LocationServices.shared.locationManger.authorizationStatus == .authorizedWhenInUse {
            runView.mapView.showsUserLocation = true
            LocationServices.shared.delegate = self
        } else {
            LocationServices.shared.locationManger.requestWhenInUseAuthorization()
        }
    }
    
    func centerMapOnUserLocation(coordinates: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 250, longitudinalMeters: 250)
        runView.mapView.setRegion(region, animated: true)
    }
    
    func setupAnnotation(coordinate: CLLocationCoordinate2D) {
        runnerAnnotation = Runner(coordinate: coordinate)
        runView.mapView.addAnnotation(runnerAnnotation!)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? Runner {
            let id = "pin"
            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: id)
            view.canShowCallout = true
            view.animatesDrop = true
            view.pinTintColor = .systemIndigo
            view.calloutOffset = CGPoint(x: -8, y: -3)
            view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let directionsRenderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        directionsRenderer.strokeColor = .systemIndigo
        directionsRenderer.lineWidth = 5
        directionsRenderer.alpha = 0.85
        
        return directionsRenderer
    }
}

extension MapVC: CustomUserLocationDelegate {
    
    func userLocationUpdated(location: CLLocation) {
        centerMapOnUserLocation(coordinates: location.coordinate)
    }
}

extension MapVC: RunControlViewDelegate {
    
    func runDidBegin() {
        guard let startCoordinates = LocationServices.shared.currentLocation else { return }
            setupAnnotation(coordinate: startCoordinates)
        self.startCoordinates = startCoordinates
        MapVCViewModel.shared.saveRunData(withCoordinates: startCoordinates)
        MapVCViewModel.shared.runInProgress = true
        
    }
    
    func runDidEnd() {
        guard let endCoordinates = LocationServices.shared.currentLocation else { return }
        
        setupAnnotation(coordinate: endCoordinates)
        MapVCViewModel.shared.runInProgress = false
        showRunRoute(startCoordinates: startCoordinates!, endCoordinates: endCoordinates) { [unowned self] runDistance in
            guard let runDistance = runDistance else { return }
            
            self.controlView.shouldRunCompletionUI(beHidden: false)
            self.controlView.calculateForMilesAndKilometers(withDistance: runDistance)
            
        }
    }
    
}

extension MapVC {
    
    func showRunRoute(startCoordinates: CLLocationCoordinate2D, endCoordinates: CLLocationCoordinate2D, completion: @escaping (CLLocationDistance?) -> Void) {
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: startCoordinates))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: endCoordinates))
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        
        directions.calculate { [unowned self] response, error in
            if let route = response?.routes.first {
                self.runView.mapView.addOverlay(route.polyline)
                self.runView.mapView.setVisibleMapRect(route.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 200, left: 50, bottom: 50, right: 50), animated: true)
                
                completion(route.distance)
                
            } else {
                completion(nil)
            }
        }
    }
    
    func presentFinishRunVC(withRoute route: MKRoute) {
        resetMapVC()
    }
}
