//
//  BaseManager.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 04/04/18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Cocoa

class BaseManager: INavigation {
    func loadManager() { }
    
    func unloadManager() { }
    
    func changeVC(vc: NSViewController) { }
    
    var storyboard: AppStoryboard!
}

protocol INavigation {
    func loadManager()
    func unloadManager()
    func changeVC(vc: NSViewController)
}
