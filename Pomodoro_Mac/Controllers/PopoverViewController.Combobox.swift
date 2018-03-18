//
//  NameComboBox.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 18/03/18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Cocoa

extension PopoverViewController: NSComboBoxDataSource {
    // Returns the number of items that the data source manages for the combo box
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        // anArray is an Array variable containing the objects
        return ["teste", "khvhgjh"].count
    }
    
    // Returns the object that corresponds to the item at the specified index in the combo box
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        return ["teste", "khvhgjh"][index]
    }
}
