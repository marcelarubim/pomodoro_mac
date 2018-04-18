//
//  NSComboboxExtension.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 18/04/18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Cocoa

extension NSComboBox {
    func unselect() {
        self.isEditable = false
        self.currentEditor()?.selectedRange = NSMakeRange(0, 0)
    }
}
