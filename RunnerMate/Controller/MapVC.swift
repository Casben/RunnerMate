//
//  ViewController.swift
//  RunnerMate
//
//  Created by Herbert Dodge on 5/23/21.
//

import UIKit
import MapKit

class MapVC: UIViewController {
    
    let mapView = MapView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }


    func configure() {
        view.backgroundColor = .systemBackground
        view.addSubview(mapView)
        mapView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 25, paddingLeft: 20, paddingRight: 20, width: 400, height: 550)
    }
}

