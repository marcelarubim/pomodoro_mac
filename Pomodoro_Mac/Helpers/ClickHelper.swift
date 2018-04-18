//
//  ClickHelper.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 18/04/18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Cocoa

class ClickHelper: NSClickGestureRecognizer {

    static func doubleClick(target: AnyObject?, action: Selector?) -> NSClickGestureRecognizer {
        let gesture = NSClickGestureRecognizer()
        gesture.buttonMask = 0x1 // left mouse
        gesture.numberOfClicksRequired = 2
        gesture.target = target
        gesture.action = action
        return gesture
    }
}
