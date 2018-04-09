//
//  Timer.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 13.01.18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Foundation

struct Pomodoro: Codable {
    var name : String = ""
    var period : Int = 10 // seconds
    var start : Date = Date()
    var stop : Date = Date()
}
