//
//  FinishRunVC.swift
//  RunnerMate
//
//  Created by Herbert Dodge on 6/1/21.
//

import UIKit
import MapKit

class FinishRunVC: UIViewController {
    
    var route: MKRoute!

    override func viewDidLoad() {
        super.viewDidLoad()

        configure()
    }
    
    func configure() {
        view.backgroundColor = .red
        print(route)
    }

}
