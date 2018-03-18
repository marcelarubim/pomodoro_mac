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

    // creates an application icon in the menu bar with a fixed length that the user will see and use
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let popover = NSPopover()
    var eventMonitor: EventMonitor?
    let timerSeconds: Int = 30
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
            button.action = #selector(togglePopover(_:))
            button.target = self
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        popover.contentViewController = PopoverViewController.freshController()
        UserDefaults.standard.register(defaults: ["TimerSeconds" : timerSeconds])
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if let strongSelf = self, strongSelf.popover.isShown {
                strongSelf.closePopover(sender: event)
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func togglePopover(_ sender: Any) {
        let button = sender as! NSStatusBarButton
        let event = NSApp.currentEvent!

        if event.type == NSEvent.EventType.rightMouseUp {
            closePopover(sender: nil)
            constructMenu()
            
        } else if popover.isShown {
            closePopover(sender: button)
        } else {
            showPopover(sender: button)
        }
    }
    
    func showPopover(sender: Any?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            eventMonitor?.start()
        }
    }

    func closePopover(sender: Any?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
}

// MARK: - Menu actions
extension AppDelegate {
    
    func constructMenu() {
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Report",
                                action: #selector(AppDelegate.clickReport(_:)),
                                keyEquivalent: "R"))
        menu.addItem(NSMenuItem(title: UserDefaults.standard.bool(forKey: "Sound") ? "Mute" : "Sound",
                                action: #selector(AppDelegate.toggleSound(_:)),
                                keyEquivalent: "m"))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit",
                                action: #selector(NSApplication.terminate(_:)),
                                keyEquivalent: "q"))
        
        statusItem.menu = menu
        statusItem.popUpMenu(statusItem.menu!)
        statusItem.menu = nil
    }
    
    @objc func clickReport(_ sender: Any) {
        let alert: NSAlert = NSAlert()
        alert.messageText = "Message"
        alert.informativeText = "Text"
        alert.alertStyle = .warning
        alert.addButton(withTitle: "OK")
        alert.runModal()
    }
    
    @objc func toggleSound(_ sender: Any) {
        let currentStatus = UserDefaults.standard.bool(forKey: "Sound")
        UserDefaults.standard.set(!currentStatus, forKey: "Sound")
    }
}

