//
//  Session.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 05.01.18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Foundation

class Session {
    var start: Date
    var end: Date
    var duration: TimeInterval {
        get {
            if start != end
            {
                return self.end.timeIntervalSince(self.start);
            }
            else
            {
                return -1;
            }
        }
    }
    
    init(start: Date) {
        self.start = start
        self.end = start
    }
}

extension Session {
    
}
