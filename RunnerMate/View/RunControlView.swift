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
        if let storedTime = TimerViewModel.shared.confiugreTimerLabelWithStoredTime() {
            label.text = storedTime
        } else {
            label.text = "00 : 00 : 00"
        }
        return label
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
        backgroundColor = UIColor(white: 1, alpha: 0.8)
        alpha = 0.75
        
        addSubviews(startButton, timerLabel)
        
        startButton.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,  paddingLeft: 8, paddingBottom: 10, paddingRight: 8, height: 60)
        
        timerLabel.centerX(inView: self)
        timerLabel.anchor(bottom: startButton.topAnchor, paddingBottom: 8)
        
    }
    
    
    @objc private func startButtonTapped() {
        if TimerViewModel.shared.timerIsRunning {
            TimerViewModel.shared.timerIsRunning = false
            TimerViewModel.shared.timer.invalidate()
            startButton.isInStartingPosition = true
        } else {
            TimerViewModel.shared.timerIsRunning = true
            TimerViewModel.shared.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
            startButton.isInStartingPosition = false
        }
    }
    
    @objc private func updateTimerLabel() {
        TimerViewModel.shared.count += 1
        TimerViewModel.shared.secondsToHoursMinutesSeconds()
        timerLabel.text = TimerViewModel.shared.timeString
        
    }
    
    
    
}
