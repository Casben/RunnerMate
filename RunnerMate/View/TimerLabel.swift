//
//  TimerLabel.swift
//  RunnerMate
//
//  Created by Herbert Dodge on 6/3/21.
//

import UIKit

class TimerLabel: UILabel {
    
    private let startingPositionText = "00 : 00 : 00"

    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        font = UIFont.systemFont(ofSize: 16)
        textColor = .systemIndigo
        setStartingPositionText()
    }
    
    func setStartingPositionText() {
        text = startingPositionText
    }
}
