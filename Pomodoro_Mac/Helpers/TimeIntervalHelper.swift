//
//  TimeIntervalHelper.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 09/04/18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Cocoa

extension TimeInterval {
    var clockString: String {
        let hours = Int(self) / 3600
        let minutes = Int(self) / 60 % 60
        let seconds = Int(self) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
}
