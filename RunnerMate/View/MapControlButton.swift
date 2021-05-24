//
//  MapControlButton.swift
//  RunnerMate
//
//  Created by Herbert Dodge on 5/23/21.
//

import UIKit

class MapControlButton: UIButton {

    init(controlType: String) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        layer.cornerRadius = frame.height / 2
        layer.cornerRadius = 20
        layer.shadowOpacity = 0.4
        layer.shadowColor = UIColor.black.cgColor
    }

}
