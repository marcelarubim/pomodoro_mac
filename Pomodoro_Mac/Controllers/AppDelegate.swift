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
    
    @IBOutlet weak var contextMenu: NSMenu!
//
//    @IBAction func clickReport(_ sender: Any) {
//        let alert: NSAlert = NSAlert()
//        alert.messageText = "Message"
//        alert.informativeText = "Text"
//        alert.alertStyle = .warning
//        alert.addButton(withTitle: "OK")
//        alert.runModal()
//    }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
            button.action = #selector(togglePopover(_:))
            button.target = self
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        popover.contentViewController = PopoverViewController.freshController()
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
            statusItem.menu = self.contextMenu
            statusItem.popUpMenu(contextMenu)
            statusItem.menu = nil
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

