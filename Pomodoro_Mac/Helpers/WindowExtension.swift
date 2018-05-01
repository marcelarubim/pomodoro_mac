//
//  WindowExtension.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 01/05/18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Cocoa

extension NSWindowController {
    func bringWindowToFront() {
        window?.makeKey()
        NSApp.activate(ignoringOtherApps: true)
    }
}
