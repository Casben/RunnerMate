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
        button.layer.cornerRadius = 20
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "figure.walk")?.withTintColor(.white, renderingMode: .alwaysTemplate)
        
        let attributedText = NSMutableAttributedString(string: "Begin your run ")
        attributedText.append(NSAttributedString(attachment: attachment))
        
        button.setAttributedTitle(attributedText, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        return button
    }()
    
    var timer = Timer()
    var count = 0
    var timerCounting = false
    
    let timerLabel: UILabel = {
       let label = UILabel()
        label.text = "00 : 00 : 00"
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
        addSubview(startButton)
        startButton.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,  paddingLeft: 8, paddingBottom: 10, paddingRight: 8, height: 60)
        
        addSubview(timerLabel)
        timerLabel.centerX(inView: self)
        timerLabel.anchor(bottom: startButton.topAnchor, paddingBottom: 8)
        
    }
    
    @objc private func startButtonTapped() {
        if timerCounting {
            timerCounting = false
            timer.invalidate()
        } else {
            timerCounting = true
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimerLabel), userInfo: nil, repeats: true)
            startButton.setAttributedTitle(nil, for: .normal)
            startButton.setTitle("STOP", for: .normal)
        }
    }
    
    @objc func updateTimerLabel() {
        count += 1
        let time = secondsToHoursMinutesSeconds(seconds: count)
        let timeString = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        
        timerLabel.text = timeString
        
    }
    
    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int) {
        return ((seconds / 3600), ((seconds % 3600) / 60), ((seconds % 3600) % 60))
    }
    
    
    func makeTimeString(hours: Int, minutes: Int, seconds: Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += " : "
        timeString += String(format: "%02d", minutes)
        timeString += " : "
        timeString += String(format: "%02d", seconds)
        
        return timeString
    }
    
}
