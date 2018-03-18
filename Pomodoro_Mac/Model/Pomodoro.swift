//
//  Timer.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 13.01.18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Foundation

class Pomodoro {
    var id : Int = -1
    var timerSeconds : Int = 10
    var timer : Timer = Timer()
    var start : Date = Date()
    var stop : Date = Date()
    var name : String?
    var isValid : Bool = false
    private var _seconds = 0
    
    let queryString = "INSERT INTO Pomodoro (name, start, end) VALUES (?,?,?)"
    
    var fireDate : Date {
        get {
            return timer.fireDate
        }
    }
    
    var seconds : Int {
        get {
            return _seconds
        }
    }
    
    init(timerSeconds : Int) {
        self.timerSeconds = timerSeconds
    }

    init(id: Int, name: String, start: Date, stop: Date, timer: Int) {
        self.id = id
        self.timerSeconds = timer
        self.start = start
        self.stop = stop
    }

    
    func invalidate() {
        timer.invalidate()
        isValid = timer.isValid
    }
    
    func run() {
        self.start = timer.fireDate
        self.isValid = timer.isValid
        self._seconds = self.timerSeconds
    }
    
    func updateTimer() {
        if self._seconds < 1 {
            self.stop = Date()
            self.invalidate()
        } else {
            self._seconds -= 1
        }
    }
}
