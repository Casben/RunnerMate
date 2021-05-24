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
        button.backgroundColor = UIColor(red: <#T##CGFloat#>, green: <#T##CGFloat#>, blue: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
        button.addRoundedCornerAndShadow()
        button.setTitle("Begin your run", for: .normal)
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
        backgroundColor = .systemBackground
        
        addSubview(startButton)
        startButton.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingRight: 8, height: 60)
        
    }
    
}
