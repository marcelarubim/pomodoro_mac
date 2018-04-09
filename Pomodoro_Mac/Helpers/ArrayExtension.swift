//
//  Array.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 18/03/18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Cocoa

extension Array where Element: Equatable {
    func unique() -> Array {
        return reduce(into: []) { result, element in
            if !result.contains(element) {
                result.append(element)
            }
        }
    }
}
