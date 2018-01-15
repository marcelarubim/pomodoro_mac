//
//  Timer.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 13.01.18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Foundation

class Pomodoro {
    var timerSeconds : Int
    var timer : Timer
    var start : Date
    var stop : Date
    var name : String?
    var isValid : Bool
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
    
    init(){
        self.timer = Timer()
        self.timerSeconds = 10
        self.start = Date()
        self.stop = Date()
        self.isValid = false
    }
    
    init(timerSeconds : Int){
        self.timer = Timer()
        self.timerSeconds = timerSeconds
        self.start = Date()
        self.stop = Date()
        self.isValid = false
    }
    
    func invalidate() {
        timer.invalidate()
        self.isValid = timer.isValid
    }
    
    func run() {
        self.start = timer.fireDate
        self.isValid = timer.isValid
        self._seconds = self.timerSeconds
    }
    
    func updateTimer() {
        if self._seconds < 1 {
            self.stop = Date()
            self.timer.invalidate()
        } else {
            self._seconds -= 1
        }
    }
}
