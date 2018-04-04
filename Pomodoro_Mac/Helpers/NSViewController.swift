//
//  NSViewController.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 04/04/18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Cocoa

extension NSViewController {
    class var storyboardID:String {
        return "\(self)"
    }
    
    static func instantiate(from storyboard: AppStoryboard) -> Self {
        return storyboard.viewController(viewControllerClass: self)
    }
}
