//
//  WindowManager.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 18/04/18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Foundation
import Cocoa

class SettingsManager: BaseManager {
    var windowController: NSWindowController!
    var mainController: SettingsViewController!
    let windowTitle = "Settings"

    override init() {
        super.init()
        setupWindow()
        setupMainViewController()
        setupHandlers()
    }
    
    override func load() {
        if let _ = windowController.window {
            windowController.showWindow(nil)
        } else {
            windowController.loadWindow()
        }
        windowController.bringWindowToFront()
    }
    
    private func setupWindow() {
        windowController = MainWindowController.initFromNib()
        windowController.window?.title = windowTitle
    }
    
    private func setupMainViewController() {
        mainController = SettingsViewController.initFromNib()
        windowController.contentViewController = mainController
    }
    
    private func setupHandlers() {
    }
}
