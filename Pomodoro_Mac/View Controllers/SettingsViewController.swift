//
//  SettingsViewController.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 28/04/18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Cocoa

class SettingsViewController: NSViewController {
    @IBOutlet weak var tabView: NSTabView!
    
    static func initFromNib() -> SettingsViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "SettingsViewController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? SettingsViewController else {
            fatalError("Why cant i find NavigationController? - Check Main.storyboard")
        }
        return viewcontroller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tabView.allowsTruncatedLabels = false
        tabView.tabViewBorderType = .bezel
        tabView.tabViewType = .topTabsBezelBorder
        setupTabs()
    }
    
    private func setupTabs() {
        TabFactory.settings().forEach {
            tabView.addTabViewItem($0)
        }
    }
}
