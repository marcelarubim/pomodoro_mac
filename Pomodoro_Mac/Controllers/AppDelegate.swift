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

    var eventMonitor : EventMonitor?
    
//    @IBOutlet weak var contextMenu: NSMenu!

    @IBOutlet weak var contextMenu: NSMenu!
    
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    let popover = NSPopover()

    func applicationDidFinishLaunching(_ aNotification: Notification) {        
        if let button = statusItem.button {
            button.image = NSImage(named:NSImage.Name("StatusBarButtonImage"))
//            button.action = #selector(togglePopover(_:))
            button.action = #selector(self.statusBarButtonClicked(sender:))
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }
        popover.contentViewController = ViewController.freshController()
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown]) { [weak self] event in if let strongSelf = self, strongSelf.popover.isShown {
            strongSelf.closePopover(sender: event)
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func printQuote(_ sender: Any?) {
        let quoteText = "Never put off until tomorrow what you can do the day after tomorrow."
        let quoteAuthor = "Mark Twain"
        
        print("\(quoteText) — \(quoteAuthor)")
    }
    
    @objc func statusBarButtonClicked(sender: NSStatusBarButton)
    {
        let event = NSApp.currentEvent!
        
        if event.type == NSEvent.EventType.rightMouseUp {
            closePopover(sender: nil)
            statusItem.menu = self.contextMenu
            statusItem.popUpMenu(contextMenu)
            statusItem.menu = nil
        } else {
            togglePopover(sender: nil)
        }
    }
    
    func togglePopover(sender: Any?) {
        if popover.isShown {
            closePopover(sender: sender)
        } else {
            showPopover(sender: sender)
        }
    }
    
    func showPopover(sender: Any?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
        }
        eventMonitor?.start()
    }
    
    func closePopover(sender: Any?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }


}

