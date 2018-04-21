//
//  MainTabViewController.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 18/04/18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Cocoa

class MainTabViewController: NSTabViewController {
    static func initFromNib() -> MainTabViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "MainTabViewController")
        guard let viewController = storyboard.instantiateController(withIdentifier: identifier) as? MainTabViewController else {
            fatalError("Why cant i find ViewController? - Check Main.storyboard")
        }
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
}
