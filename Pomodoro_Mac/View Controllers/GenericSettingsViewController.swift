//
//  GenericSettingsViewController.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 01/05/18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Cocoa

class GenericSettingsViewController: NSViewController {

    static func initFromNib() -> GenericSettingsViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "GenericSettingsViewController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? GenericSettingsViewController else {
            fatalError("Why cant i find GenericSettingsViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
