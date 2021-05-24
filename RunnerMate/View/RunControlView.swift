//
//  MapControlView.swift
//  RunnerMate
//
//  Created by Herbert Dodge on 5/23/21.
//

import UIKit

class RunControlView: UIView {
    
    let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 115 / 255, green: 133 / 255, blue: 84 / 255, alpha: 1)
//        button.addRoundedCornerAndShadow()
        button.layer.cornerRadius = 20
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "figure.walk")?.withTintColor(.white, renderingMode: .alwaysTemplate)
        
        let attributedText = NSMutableAttributedString(string: "Begin your run ")
        attributedText.append(NSAttributedString(attachment: attachment))
        
        button.setAttributedTitle(attributedText, for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    

    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addRoundedCornerAndShadow()
        backgroundColor = UIColor(white: 1, alpha: 1)
        alpha = 0.75
        addSubview(startButton)
        startButton.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,  paddingLeft: 8, paddingBottom: 20, paddingRight: 8, height: 60)
        
    }
    
}
