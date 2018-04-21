//
//  BaseManager.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 04/04/18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Cocoa

class BaseManager: INavigation {
    func load() {
        assert(false, "needs to implement load()")
    }
}

protocol INavigation {
    func load()
}
