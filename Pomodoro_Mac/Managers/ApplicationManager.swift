//
//  AppManager.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 04/04/18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Cocoa

class ApplicationManager {
    static let standard = ApplicationManager()
    
    private init() { }
    
    var currentManager: BaseManager!
    let popoverManager = PopoverManager()
    var windowManagers: [BaseManager] = []
    
    func launch() {
        popoverManager.launch()
        setupFeatureManagers()
        setupHandlers()
    }
    
    private func setupFeatureManagers() {
        windowManagers = ManagerFactory.setupWindowManagers()
    }
    
    private func setupHandlers() {
        popoverManager.requestWindow = {
            self.currentManager = self.windowManagers.first!
            self.currentManager.load()
        }
    }
}
