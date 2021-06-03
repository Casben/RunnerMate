//
//  MapControlView.swift
//  RunnerMate
//
//  Created by Herbert Dodge on 5/23/21.
//

import UIKit

protocol RunControlViewDelegate: AnyObject {
    func runDidBegin()
    func runDidEnd()
    func resetButtonTapped()
}

class RunControlView: UIView {
    
    let startButton: StartButton = {
        let button = StartButton(type: .system)
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let distanceSegmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Miles", "Kilometers"])
        control.backgroundColor = .systemIndigo
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        control.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(updateDistanceRunLabel), for: .valueChanged)
        return control
    }()
    
    let distanceRanLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .systemIndigo
        return button
    }()
    
    let resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.clockwise"), for: .normal)
        button.tintColor = .systemIndigo
        button.addTarget(self, action: #selector(resetButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let runTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Run Time:"
        label.font = UIFont.boldSystemFont(ofSize: 26)
        return label
    }()
    
    let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "00 : 00 : 00"
        
        if let storedTime = RunControlViewModel.shared.confiugreTimerLabelWithStoredTime(), storedTime.isEmpty == false  {
            label.text = storedTime
        }
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .systemIndigo
        return label
    }()
    
    weak var delegate: RunControlViewDelegate?
    
    var runDistanceInMiles: Double?
    var runDistancecInKilometers: Double?
    
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
        
        addSubviews(distanceSegmentedControl, resetButton, shareButton, distanceRanLabel, startButton, runTimeLabel, timerLabel)
        
        distanceSegmentedControl.centerX(inView: self)
        distanceSegmentedControl.anchor(top: self.topAnchor, paddingTop: 8)
        
        shareButton.anchor(top: self.topAnchor, right: self.rightAnchor, paddingTop: 8, paddingRight: 20)
        resetButton.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 8, paddingLeft: 20)
        
        distanceRanLabel.centerX(inView: self)
        distanceRanLabel.anchor(top: distanceSegmentedControl.bottomAnchor, paddingTop: 20)
        
        startButton.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,  paddingLeft: 8, paddingBottom: 10, paddingRight: 8, height: 60)

        runTimeLabel.centerX(inView: self)
        runTimeLabel.anchor(bottom: startButton.topAnchor, paddingBottom: 8)
        
        timerLabel.anchor(bottom: startButton.topAnchor, right: startButton.rightAnchor, paddingBottom: 8, paddingRight: 8)
        
        RunControlViewModel.shared.loadTimeData()
        configureNotificationObservers()
        shouldRunCompletionUI(beHidden: true)
    }
    
    func configureNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidenterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    func setupTimer() {
        DispatchQueue.main.async {
            RunControlViewModel.shared.timer.invalidate()
            RunControlViewModel.shared.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateTimerLabel), userInfo: nil, repeats: true)
        }
    }
    
    func reset() {
        startButton.isInStartingPosition = true
        timerLabel.text = "00 : 00 : 00"
    }
    
    func shouldRunCompletionUI(beHidden value: Bool) {
        distanceSegmentedControl.isHidden = value
        shareButton.isHidden = value
        resetButton.isHidden = value
        distanceRanLabel.isHidden = value
        
        startButton.isEnabled = value
        
    }
    
    func calculateForMilesAndKilometers(withDistance distance: Double) {
        runDistancecInKilometers = distance / 1000
        runDistanceInMiles = distance / 1609
        
        let miles = String(format: "%.2f", runDistanceInMiles!)
        distanceRanLabel.text = "You ran \(miles) miles."
    }
    
    @objc private func startButtonTapped() {
        switch startButton.isInStartingPosition {
        case true:
            if RunControlViewModel.shared.timerIsRunning {
                RunControlViewModel.shared.timerIsRunning = false
                RunControlViewModel.shared.timer.invalidate()
                startButton.isInStartingPosition = true
                delegate?.runDidEnd()
            } else {
                RunControlViewModel.shared.timerIsRunning = true
                RunControlViewModel.shared.startTime = Date()
                setupTimer()
                startButton.isInStartingPosition = false
                delegate?.runDidBegin()
            }
        case false:
            DispatchQueue.main.async {
                RunControlViewModel.shared.timer.invalidate()
            }
            delegate?.runDidEnd()
            print("timer stopped and call delegate to finish run")
        }
    }
    
    @objc private func resetButtonTapped() {
        timerLabel.text = "00 : 00 : 00"
        startButton.isInStartingPosition = true
        shouldRunCompletionUI(beHidden: true)
        delegate?.resetButtonTapped()
    }
    
    @objc private func updateTimerLabel() {
        RunControlViewModel.shared.count += 1
        RunControlViewModel.shared.secondsToHoursMinutesSeconds()
        timerLabel.text = RunControlViewModel.shared.timeString
        
    }
    
    @objc private func updateDistanceRunLabel(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            let miles = String(format: "%.2f", runDistanceInMiles!)
            distanceRanLabel.text = "You ran \(miles) miles."
        case 1:
            let kilometers = String(format: "%.2f", runDistancecInKilometers!)
            distanceRanLabel.text = "You ran \(kilometers) kilometers."
        default:
            break
        }
    }
    
    @objc private func applicationDidenterBackground(_ notification: Notification) {
        if !RunControlViewModel.shared.timerIsRunning {
            DispatchQueue.main.async {
                RunControlViewModel.shared.timer.invalidate()
            }
            RunControlViewModel.shared.ellapsedTime = 0
            RunControlViewModel.shared.timerIsRunning = false
        }
        
    }
    
    @objc private func applicationDidBecomeActive(_ notification: Notification) {
        if RunControlViewModel.shared.timerIsRunning {
            RunControlViewModel.shared.ellapsedTime = 0
            RunControlViewModel.shared.count = 0
            setupTimer()
            RunControlViewModel.shared.ellapsedTime = Date().timeIntervalSince(RunControlViewModel.shared.startTime!)
            RunControlViewModel.shared.timerIsRunning = true
        }
    }
}

extension RunControlView: RunControlViewModelDelegate {
    func notifyTimeHasBeenRestored() {
        timerLabel.text = RunControlViewModel.shared.timeString
        startButton.isInStartingPosition = false
        setupTimer()
    }
}
