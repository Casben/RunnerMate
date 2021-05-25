//
//  TimerViewModel.swift
//  RunnerMate
//
//  Created by Herbert Dodge on 5/24/21.
//

import Foundation

typealias Time = (Int, Int, Int)

struct TimerViewModel {
    
    var time: Time = (0, 0, 0) {
        didSet {
            makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
        }
    }
    
    var timeString: String = ""
    
    mutating func secondsToHoursMinutesSeconds(seconds: Int) {
        time = ((seconds / 3600), ((seconds % 3600) / 60), ((seconds % 3600) % 60))
    }
    
    mutating func makeTimeString(hours: Int, minutes: Int, seconds: Int) {
        timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += " : "
        timeString += String(format: "%02d", minutes)
        timeString += " : "
        timeString += String(format: "%02d", seconds)
    }
}
