//
//  AppDelegate.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 03.01.18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    let applicationManager = ApplicationManager.standard
    let popoverManager = PopoverManager()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        applicationManager.launch()
        popoverManager.launch()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }        
}
