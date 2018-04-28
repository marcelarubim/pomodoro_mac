//
//  ContextMenu.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 18/04/18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Cocoa

class ContextMenu {
    private var menuItems: [NSMenuItem] = []
    var menu = NSMenu()
    
    var itemClicked:((item)->())!
    
    init() {
        setup()
    }
    
    private func setup() {
        menu.removeAllItems()
        menuItems = [NSMenuItem(title: "Report",
                                action: #selector(itemClick(_:)),
                                keyEquivalent: "r"),
                     NSMenuItem(title: UserDefaults.standard.bool(forKey: "Sound") ? "Mute" : "Sound",
                                action: #selector(itemClick(_:)),
                                keyEquivalent: "s"),
                     NSMenuItem(title: "Preferences",
                                action: #selector(itemClick(_:)),
                                keyEquivalent: ","),
                     NSMenuItem.separator(),
                     NSMenuItem(title: "Quit",
                                action: #selector(itemClick(_:)),
                                keyEquivalent: "q")]
        menuItems.forEach({
            $0.target = self
            menu.addItem($0)
        })
    }
    
    @objc private func itemClick(_ sender: Any) {
        if let index = menuItems.index(where: { $0 === sender as! NSMenuItem}) {
            if let item = item(rawValue: index) {
                itemClicked?(item)
            }
        }
    }
    
    enum item: Int {
        case report = 0, sound = 1, preferences = 2, quit = 4
    }
    
    func updateMenu() {
        setup()
    }
}
