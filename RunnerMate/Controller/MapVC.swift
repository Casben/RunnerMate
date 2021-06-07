//
//  ViewController.swift
//  RunnerMate
//
//  Created by Herbert Dodge on 5/23/21.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    
    //MARK: - Properties
    
    let runView = RunView()
    let controlView = RunControlView()
    
    var runnerAnnotation: Runner?
    var startCoordinates: CLLocationCoordinate2D?
    var endCoordinates: CLLocationCoordinate2D?

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationAuthStatus()
        configure()
    }


    //MARK: - Methods
    
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
        if MapViewModel.shared.checkIfRunDataExsists() {
            MapViewModel.shared.loadRunData()
            startCoordinates = MapViewModel.shared.savedCoordinates
            setupAnnotation(coordinate: startCoordinates!)
        }
    }
    
    func resetMapVC() {
        MapViewModel.shared.reset()
        MapViewModel.shared.runInProgress = false
        RunControlViewModel.shared.reset()
        controlView.shouldRunCompletionUI(beHidden: true)
        controlView.reset()
        runView.mapView.removeAnnotations(runView.mapView.annotations)
        runView.mapView.removeAnnotations(runView.mapView.annotations)
        runView.mapView.overlays.forEach { runView.mapView.removeOverlay($0) }
    }
}

//MARK: - MKMapviewDelegate

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

//MARK: - CustomUserlocationDelegate

extension MapVC: CustomUserLocationDelegate {
    
    func userLocationUpdated(location: CLLocation) {
        centerMapOnUserLocation(coordinates: location.coordinate)
    }
}

//MARK: - RunControlViewDelegate

extension MapVC: RunControlViewDelegate {
    
    func runDidBegin() {
        guard let startCoordinates = LocationServices.shared.currentLocation else { return }
            setupAnnotation(coordinate: startCoordinates)
        self.startCoordinates = startCoordinates
        MapViewModel.shared.saveRunData(withCoordinates: startCoordinates)
        MapViewModel.shared.runInProgress = true
        
    }
    
    func runDidEnd() {
        guard let endCoordinates = LocationServices.shared.currentLocation else { return }
        guard let startCoordinates = startCoordinates else { return }
    
        setupAnnotation(coordinate: endCoordinates)
        self.endCoordinates = endCoordinates
        MapViewModel.shared.runInProgress = false
        showRunRoute(startCoordinates: startCoordinates, endCoordinates: endCoordinates) { [unowned self] runDistance in
            guard let runDistance = runDistance else { return }
            
            self.controlView.shouldRunCompletionUI(beHidden: false)
            self.controlView.calculateForMilesAndKilometers(withDistance: runDistance)
            
        }
    }
    
    func resetButtonTapped() {
        resetMapVC()
    }
    
    func shareButtonTapped() {
        
        renderSnapShotOfMap { image in
            let activityItems: [Any] = ["Check out this run I just did!", image]
            let shareSheet = UIActivityViewController(activityItems: activityItems, applicationActivities: [])
            self.present(shareSheet, animated: true) {
                self.resetMapVC()
            }
        }
        
        
    }
    
}

//MARK: - Render runner route methods

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
    
    func renderSnapShotOfMap(completion: @escaping (UIImage) -> Void) {
        guard let latitude = startCoordinates?.latitude, let longitude = endCoordinates?.longitude else { return }
        
        let snapshotOptions = MKMapSnapshotter.Options()
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        let region = MKCoordinateRegion(center: location, latitudinalMeters: 300, longitudinalMeters: 300)
        
        snapshotOptions.region = region
        snapshotOptions.scale = UIScreen.main.scale
        snapshotOptions.size = CGSize(width: 300, height: 300)
        snapshotOptions.showsBuildings = true
        
        let snapshotter = MKMapSnapshotter(options: snapshotOptions)
        
        snapshotter.start { snapshot, error in
            guard let snapshot = snapshot else { return }
            
            let image = self.addAnnotationsAndPolylineTo(snapshot: snapshot)
            completion(image)
        }
    }
    
    func addAnnotationsAndPolylineTo(snapshot: MKMapSnapshotter.Snapshot) -> UIImage {
        let image = snapshot.image
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 300, height: 300), true, 0)
        image.draw(at: CGPoint.zero)
        
        let polyLineCoordinates = [startCoordinates!, endCoordinates!]
        
        let context = UIGraphicsGetCurrentContext()
        context?.setLineWidth(2.0)
        context?.setStrokeColor(UIColor.systemIndigo.cgColor)
        
        context?.move(to: snapshot.point(for: polyLineCoordinates[0]))
        
        for i in 0...polyLineCoordinates.count - 1 {
            context?.addLine(to: snapshot.point(for: polyLineCoordinates[i]))
            context?.move(to: snapshot.point(for: polyLineCoordinates[i]))
        }
        
        context?.strokePath()
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return resultImage!
    }
}
