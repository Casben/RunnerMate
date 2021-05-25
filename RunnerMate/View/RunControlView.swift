//
//  MapControlView.swift
//  RunnerMate
//
//  Created by Herbert Dodge on 5/23/21.
//

import UIKit

class RunControlView: UIView {
    
    let startButton: StartButton = {
        let button = StartButton(type: .system)
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let timerLabel: UILabel = {
       let label = UILabel()
        label.text = "00 : 00 : 00"
        return label
    }()
    
    var timerViewModel = TimerViewModel()
    
    
    

    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        addRoundedCornerAndShadow()
        backgroundColor = UIColor(white: 1, alpha: 0.8)
        alpha = 0.75
        
        addSubviews(startButton, timerLabel)
        
        startButton.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,  paddingLeft: 8, paddingBottom: 10, paddingRight: 8, height: 60)
        
        timerLabel.centerX(inView: self)
        timerLabel.anchor(bottom: startButton.topAnchor, paddingBottom: 8)
        
    }
    
    @objc private func startButtonTapped() {
        if timerViewModel.timerCounting {
            timerViewModel.timerCounting = false
            timerViewModel.timer.invalidate()
            startButton.isInStartingPosition = true
        } else {
            timerViewModel.timerCounting = true
            timerViewModel.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
            startButton.isInStartingPosition = false
        }
    }
    
    @objc func updateTimerLabel() {
        timerViewModel.count += 1
        timerViewModel.secondsToHoursMinutesSeconds()
        timerLabel.text = timerViewModel.timeString
        
    }
    
    
    
}
