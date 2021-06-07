//
//  TimerLabel.swift
//  RunnerMate
//
//  Created by Herbert Dodge on 6/3/21.
//

import UIKit

class TimerLabel: UILabel {
    
    //MARK: - Properties
    
    private let startingPositionText = "00 : 00 : 00"

    //MARK: - Lifecycle
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Methods
    
    func configure() {
        font = UIFont.systemFont(ofSize: 16)
        textColor = .systemIndigo
        setStartingPositionText()
    }
    
    func setStartingPositionText() {
        text = startingPositionText
    }
}
