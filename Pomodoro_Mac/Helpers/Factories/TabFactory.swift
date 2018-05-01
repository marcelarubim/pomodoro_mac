//
//  TabFactory.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 01/05/18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Cocoa

class TabFactory {
    
    struct TabItem {
        var label: String
        var controller: NSViewController
    }
    
    static func settings() -> [NSTabViewItem] {
        var tabViewItems: [NSTabViewItem] = []
        let tabItems = [TabItem(label: "General", controller: GenericSettingsViewController.initFromNib()),
                        TabItem(label: "Notifications", controller: GenericSettingsViewController.initFromNib()),
                        TabItem(label: "Sounds", controller: GenericSettingsViewController.initFromNib())]
        for item in tabItems {
            let tabItem = NSTabViewItem(viewController: item.controller)
            tabItem.label = item.label
            tabViewItems.append(tabItem)
        }
        return tabViewItems
    }
}
