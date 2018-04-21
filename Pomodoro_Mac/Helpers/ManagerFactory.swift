//
//  ManagerFactory.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 18/04/18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Foundation

struct ManagerFactory {
    static func setupWindowManagers() -> [BaseManager] {
        var managers: [BaseManager] = []
        
        managers.append(WindowManager())
        
        return managers
    }
    
    static func setupFeatureManagers() -> [BaseManager] {
        var managers: [BaseManager] = []
        
//        managers.append()
        
        return managers
    }

}
