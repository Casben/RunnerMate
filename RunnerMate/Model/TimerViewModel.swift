//
//  TimerViewModel.swift
//  RunnerMate
//
//  Created by Herbert Dodge on 5/24/21.
//

import Foundation

typealias Time = (Int, Int, Int)

protocol TimerViewlModelDelegate: AnyObject {
    func notifyTimeHasBeenRestored()
}

class TimerViewModel {
    
    static let shared = TimerViewModel()
    let userDefaults = UserDefaults.standard
    
    var time: Time = (0, 0, 0) {
        didSet {
            makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        }
    }
    
    var timer = Timer()
    var count = 0
    
    var timeString: String = ""
    var timerIsRunning = false
    
    var startTime: Date?
    var ellapsedTime: TimeInterval = 0  {
        didSet {
            convertTimeInterval()
        }
    }
    
    weak var delegate: TimerViewlModelDelegate?
    
    func secondsToHoursMinutesSeconds() {
        time = ((count / 3600), ((count % 3600) / 60), ((count % 3600) % 60))
    }
    
    private func restoreTime(with storedString: String) {
        let trimmedString = storedString.replacingOccurrences(of: " : ", with: "")
        let hours = Int(trimmedString[0...1])!
        let mintues = Int(trimmedString[2...3])!
        let seconds = Int(trimmedString[4...5])!
        
        count = ((hours * 3600) + ((mintues * 3600) / 60) + seconds)
        secondsToHoursMinutesSeconds()
        delegate?.notifyTimeHasBeenRestored()
        print("time is \(time)")
        print("count is \(count)")
        
    }
    
    func makeTimeString(hours: Int, minutes: Int, seconds: Int) {
        timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += " : "
        timeString += String(format: "%02d", minutes)
        timeString += " : "
        timeString += String(format: "%02d", seconds)
    }
    
    func saveTimerString() {
        userDefaults.setValue(timeString, forKey: "timeString")
    }
    
    func loadTimerString() {
        guard let storedString = userDefaults.string(forKey: "timeString") else { return }
        timeString = storedString
        restoreTime(with: storedString)
    }
    
    func confiugreTimerLabelWithStoredTime() -> String? {
        guard let storedTime = userDefaults.string(forKey: "timeString") else { return nil }
        return storedTime
    }
    
    func convertTimeInterval() {
        let timePassed = abs(Int(ellapsedTime))
        print("count before \(count)")
        print("time passed is \(timePassed)")
        count += timePassed
        print("count after \(count)")
        print(time)
        secondsToHoursMinutesSeconds()
    }
}
