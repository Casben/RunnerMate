//
//  MapControlView.swift
//  RunnerMate
//
//  Created by Herbert Dodge on 5/23/21.
//

import UIKit

protocol RunControlViewDelegate: AnyObject {
    func runDidBegin()
}

class RunControlView: UIView {
    
    let startButton: StartButton = {
        let button = StartButton(type: .system)
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "00 : 00 : 00"
        
        if let storedTime = RunControlViewModel.shared.confiugreTimerLabelWithStoredTime(), storedTime.isEmpty == false  {
            label.text = storedTime
        }
        return label
    }()
    
    weak var delegate: RunControlViewDelegate?
    
    init() {
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        RunControlViewModel.shared.delegate = self
        addRoundedCornerAndShadow()
        backgroundColor = UIColor(white: 1, alpha: 0.8)
        alpha = 0.75
        
        addSubviews(startButton, timerLabel)
        
        startButton.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,  paddingLeft: 8, paddingBottom: 10, paddingRight: 8, height: 60)
        
        timerLabel.centerX(inView: self)
        timerLabel.anchor(bottom: startButton.topAnchor, paddingBottom: 8)
        
        configureNotificationObservers()
    }
    
    func configureNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidenterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    
    @objc private func startButtonTapped() {
        if RunControlViewModel.shared.timerIsRunning {
            RunControlViewModel.shared.timerIsRunning = false
            RunControlViewModel.shared.timer.invalidate()
            startButton.isInStartingPosition = true
            
        } else {
            RunControlViewModel.shared.timerIsRunning = true
            RunControlViewModel.shared.startTime = Date()
            RunControlViewModel.shared.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
            RunControlViewModel.shared.loadTimeData()
            startButton.isInStartingPosition = false
        }
        delegate?.runDidBegin()
    }
    
    @objc private func updateTimerLabel() {
        RunControlViewModel.shared.count += 1
        RunControlViewModel.shared.secondsToHoursMinutesSeconds()
        timerLabel.text = RunControlViewModel.shared.timeString
        
    }
    
    @objc func applicationDidenterBackground(_ notification: Notification) {
        if !RunControlViewModel.shared.timerIsRunning {
            RunControlViewModel.shared.timer.invalidate()
            RunControlViewModel.shared.ellapsedTime = 0
            RunControlViewModel.shared.timerIsRunning = false
        }
    }
    
    @objc func applicationDidBecomeActive(_ notification: Notification) {
        if RunControlViewModel.shared.timerIsRunning {
            RunControlViewModel.shared.ellapsedTime = 0
            RunControlViewModel.shared.count = 0
            
            RunControlViewModel.shared.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
            
            RunControlViewModel.shared.ellapsedTime = Date().timeIntervalSince(RunControlViewModel.shared.startTime!)
            RunControlViewModel.shared.timerIsRunning = true
        }
    }
    
}

extension RunControlView: RunControlViewModelDelegate {
    func notifyTimeHasBeenRestored() {
        timerLabel.text = RunControlViewModel.shared.timeString
    }
}
