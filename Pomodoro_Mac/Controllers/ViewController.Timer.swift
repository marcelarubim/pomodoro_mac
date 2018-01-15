//
//  ViewController.Timer.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 06.01.18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Foundation
import Cocoa

extension ViewController
{
    func startPomodoro() {
        pomodoro.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
        pomodoro.run()
        resumeClicked = false
        self.startBtn.isEnabled = false
        self.pauseBtn.isEnabled = true
        self.pauseBtn.attributedTitle = NSAttributedString(string: "Pause")
    }
    
    @objc func updateTimer() {
        pomodoro.updateTimer()
        timerLabel.stringValue = timeString(time: TimeInterval(pomodoro.seconds))
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }    
}
