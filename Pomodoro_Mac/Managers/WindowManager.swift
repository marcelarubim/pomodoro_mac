//
//  WindowManager.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 18/04/18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Foundation
import Cocoa

class WindowManager: BaseManager {
    var windowController: NSWindowController!
    var navigationController: NSTabViewController!

    override init() {
        super.init()
        windowController = MainWindowController.initFromNib()
        navigationController = MainTabViewController.initFromNib()
        windowController.contentViewController = navigationController
        setupHandlers()
    }
    
    override func load() {
        if !(windowController.window?.isVisible)! {
            windowController.showWindow(nil)
        }
    }
    
    private func setupHandlers() {
    }
}
