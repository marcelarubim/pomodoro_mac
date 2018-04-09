//
//  AlertFactory.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 08/04/18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Cocoa

class AlertFactory: NSAlert {
    static func warningOKAlert(message: String, information: String) -> NSAlert {
        let alert = NSAlert()
        alert.messageText = message
        alert.informativeText = information
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        return alert
    }
}
