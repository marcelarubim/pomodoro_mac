//
//  MainWindowController.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 18/04/18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController, NSWindowDelegate {
    static func initFromNib() -> MainWindowController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "MainWindowController")
        guard let windowcontroller = storyboard.instantiateController(withIdentifier: identifier) as? MainWindowController else {
            fatalError("Why cant i find ViewController? - Check Main.storyboard")
        }
        return windowcontroller
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
    }
}
