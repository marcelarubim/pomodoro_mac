//
//  ViewController.Timer.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 06.01.18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Foundation

extension PopoverViewController
{
    func startPomodoro() {
        txtTimer.stringValue = timeString(time: TimeInterval(pomodoro.timerSeconds))
        pomodoro.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        pomodoro.run()
        btnStart.isEnabled = false
        btnStop.isEnabled = true
    }
    
    @objc func updateTimer() {
        pomodoro.updateTimer()
        txtTimer.stringValue = timeString(time: TimeInterval(pomodoro.seconds))
        if(!pomodoro.isValid)
        {
            btnStart.isEnabled = true
            btnStop.isEnabled = false
//            pomodoro.name = txtName.stringValue
            try? db.insert(pomodoro: pomodoro)
            pomodoro.name = "New name"
            try? db.update(pomodoro: pomodoro)
        }
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }    
}
