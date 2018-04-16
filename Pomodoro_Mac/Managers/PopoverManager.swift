//
//  PopoverManager.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 08/04/18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Foundation
import Cocoa

class PopoverManager {
    // creates an application icon in the menu bar with a fixed length that the user will see and use
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let popover = NSPopover()
    var eventMonitor: EventMonitor?
    let timerSeconds: Int = 30
    
    private var pomodoro = PomodoroController()
    private var popoverViewController: PopoverViewController!
    
    func launch() {
        if let button = statusItem.button {
            configureButton(button)
        }
        popoverViewController = PopoverViewController.initFromNib()
        popover.contentViewController = popoverViewController
        
        configHandlers()
        
        UserDefaults.standard.register(defaults: ["TimerSeconds" : timerSeconds])
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in
            if let strongSelf = self, strongSelf.popover.isShown {
                strongSelf.closePopover(sender: event)
            }
        }
    }
    
    private func configHandlers(){
        popoverViewController.start = {
            self.pomodoro.start()
        }
        
        popoverViewController.stop = {
            self.pomodoro.stop()
        }
        
        popoverViewController.updateName = {(name) in
            self.pomodoro.updateName(name: name)
        }
        
        popoverViewController.getUniqueNames = {
            self.popoverViewController.names = self.pomodoro.getUniqueNames()
        }
        
        pomodoro.updateStatus = { status in
            self.popoverViewController.update(status: status)
        }
        
        pomodoro.updateTime = { time in
            self.popoverViewController.updateTimeText(time: time)
        }
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
    
    func configureButton(_ button: NSButton) {
        button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
        button.action = #selector(togglePopover(_:))
        button.target = self
        button.sendAction(on: [.leftMouseUp, .rightMouseUp])
    }
}
extension PopoverManager {
    func constructMenu() {
        let menu = NSMenu()
        let menuItems = [NSMenuItem(title: "Report",
                                   action: #selector(clickReport(_:)),
                                   keyEquivalent: "R"),
                         NSMenuItem(title: UserDefaults.standard.bool(forKey: "Sound") ? "Mute" : "Sound",
                                    action: #selector(toggleSound(_:)),
                                    keyEquivalent: "m"),
                         NSMenuItem.separator(),
                         NSMenuItem(title: "Quit",
                                    action: #selector(NSApplication.terminate(_:)),
                                    keyEquivalent: "q")]

        for item in menuItems {
            if item.keyEquivalent != "q" {
                item.target = self
            }
            menu.addItem(item)
        }
        
        statusItem.menu = menu
        statusItem.popUpMenu(statusItem.menu!)
        statusItem.menu = nil
    }
    
    @objc func clickReport(_ sender: Any) {
        let alert = AlertFactory.warningOKAlert(message: "Message", information: "Text")
        alert.runModal()
    }
    
    @objc func toggleSound(_ sender: Any) {
        let currentStatus = UserDefaults.standard.bool(forKey: "Sound")
        UserDefaults.standard.set(!currentStatus, forKey: "Sound")
        popoverViewController.toggleSound(shouldBeep: !currentStatus)
    }
}
