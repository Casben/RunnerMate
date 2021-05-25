//
//  StartButton.swift
//  RunnerMate
//
//  Created by Herbert Dodge on 5/24/21.
//

import UIKit

class StartButton: UIButton {

    private let startText: NSMutableAttributedString = {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "figure.walk")?.withTintColor(.white, renderingMode: .alwaysTemplate)
        
        let attributedText = NSMutableAttributedString(string: "Start your run ")
        attributedText.append(NSAttributedString(attachment: attachment))
        
        return attributedText
    }()
    
    private let endText: NSMutableAttributedString = {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "stopwatch")?.withTintColor(.white, renderingMode: .alwaysTemplate)
        
        let attributedText = NSMutableAttributedString(string: "STOP ")
        attributedText.append(NSAttributedString(attachment: attachment))
        
        return attributedText
    }()
    
    private let startButtonColor = UIColor(red: 115 / 255, green: 133 / 255, blue: 84 / 255, alpha: 1)
    private let endButtonColor = UIColor(red: 242 / 255, green: 118 / 255, blue: 109 / 255, alpha: 1)
    
    var isInStartingPosition: Bool = true {
        didSet {
            switch isInStartingPosition {
            case true:
                setStartText()
            case false:
                setStopText()
            }
        }
    }
    

    init(type: ButtonType) {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        layer.cornerRadius = 20
        setStartText()
    }
    
    private func setStartText() {
        backgroundColor = startButtonColor
        setAttributedTitle(startText, for: .normal)
        setTitleColor(.white, for: .normal)
    }
    
    private func setStopText() {
        backgroundColor = endButtonColor
        setAttributedTitle(endText, for: .normal)
    }
    
}
