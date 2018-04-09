//
//  PomodoroController.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 08/04/18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Foundation

class PomodoroController {
    
    private let timeInterval: TimeInterval = 1
    private var currentTime: Int = 0
    private var timer : Timer = Timer()
    private var pomodoro = Pomodoro()
    private var status: TimerStatus = .undefined {
        didSet {
            updateStatus(status)
        }
    }
    
    var updateTime:((Int) -> ())!
    var updateStatus:((TimerStatus) -> ())!
    
    func stop() {
        status = .incomplete
        invalidate()
    }
    
    func start() {
        if !timer.isValid {
            timer = Timer.scheduledTimer(timeInterval: timeInterval,
                                         target: self,
                                         selector: #selector(PomodoroController.updateTimer),
                                         userInfo: nil, repeats: true)
            pomodoro.start = timer.fireDate
            currentTime = pomodoro.period
            status = .running
        }
    }
    
    func updateName(name: String) {
        pomodoro.name = name
    }
    
    @objc func updateTimer() {
        if currentTime < 1 {
            invalidate()
            status = .complete
        } else {
            self.currentTime -= 1
        }
        updateTime(self.currentTime)
    }
    
    private func invalidate() {
        pomodoro.stop = Date()
        timer.invalidate()
        store()
    }
    
    private func store() {
        pomodoro.name = "New name"
        let db = Database()
        db.add(pomodoro: pomodoro)
    }
}

