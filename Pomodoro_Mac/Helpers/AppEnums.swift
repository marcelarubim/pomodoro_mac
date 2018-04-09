//
//  AppEnums.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 04/04/18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Foundation
import Cocoa

enum AppStoryboard: String {
    case Main, Popover
    
    var instance : NSStoryboard {
        return NSStoryboard(name: NSStoryboard.Name(rawValue: self.rawValue), bundle: Bundle.main)
    }
    
    func viewController<T : NSViewController>(viewControllerClass : T.Type) -> T {
        let storyboardID = (viewControllerClass as NSViewController.Type).storyboardID
        return instance.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: storyboardID)) as! T
    }
    
    func initialViewController() -> NSViewController? {
        return instance.instantiateInitialController() as? NSViewController
    }
}

enum TimerStatus {
    case undefined, running, complete, incomplete
}
