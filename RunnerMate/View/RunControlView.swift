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
        TimerViewModel.shared.delegate = self
        addRoundedCornerAndShadow()
        backgroundColor = UIColor(white: 1, alpha: 0.8)
        alpha = 0.75
        
        addSubviews(startButton, timerLabel)
        
        startButton.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,  paddingLeft: 8, paddingBottom: 10, paddingRight: 8, height: 60)
        
        timerLabel.centerX(inView: self)
        timerLabel.anchor(bottom: startButton.topAnchor, paddingBottom: 8)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidenterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
    }
    
    
    @objc private func startButtonTapped() {
        if TimerViewModel.shared.timerIsRunning {
            TimerViewModel.shared.timerIsRunning = false
            TimerViewModel.shared.timer.invalidate()
            startButton.isInStartingPosition = true
        } else {
            TimerViewModel.shared.timerIsRunning = true
            TimerViewModel.shared.startTime = Date()
            TimerViewModel.shared.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
            TimerViewModel.shared.loadTimeData()
            startButton.isInStartingPosition = false
        }
    }
    
    @objc private func updateTimerLabel() {
        TimerViewModel.shared.count += 1
        TimerViewModel.shared.secondsToHoursMinutesSeconds()
        timerLabel.text = TimerViewModel.shared.timeString
        
    }
    
    @objc func applicationDidenterBackground(_ notification: Notification) {
        if !TimerViewModel.shared.timerIsRunning {
            TimerViewModel.shared.timer.invalidate()
            TimerViewModel.shared.ellapsedTime = 0
            TimerViewModel.shared.timerIsRunning = false
        }
    }
    
    @objc func applicationDidBecomeActive(_ notification: Notification) {
        if TimerViewModel.shared.timerIsRunning {
            TimerViewModel.shared.ellapsedTime = 0
            TimerViewModel.shared.count = 0
            
            TimerViewModel.shared.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
            
            TimerViewModel.shared.ellapsedTime = Date().timeIntervalSince(TimerViewModel.shared.startTime!)
            TimerViewModel.shared.timerIsRunning = true
        }
    }
    
}

extension RunControlView: TimerViewlModelDelegate {
    func notifyTimeHasBeenRestored() {
        timerLabel.text = TimerViewModel.shared.timeString
    }
}
