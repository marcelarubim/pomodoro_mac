//
//  ViewController.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 03.01.18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Cocoa
import SQLite

class PopoverViewController: NSViewController {
    var db = Database()
    var pomodoro = Pomodoro(timerSeconds: 10)
    
    @IBOutlet weak var cbxName: NSComboBox!
    @IBOutlet weak var txtTimer: NSTextField!
    @IBOutlet weak var btnStart: NSButton!
    {
        didSet {
            btnStart.attributedTitle = NSAttributedString(string: "Start", attributes: [NSAttributedStringKey.foregroundColor : NSColor.black, NSAttributedStringKey.backgroundColor : NSColor.clear])
        }
    }
    @IBOutlet weak var btnStop: NSButton!
    {
        didSet {
            btnStop.attributedTitle = NSAttributedString(string: "Stop", attributes: [NSAttributedStringKey.foregroundColor : NSColor.red, NSAttributedStringKey.backgroundColor : NSColor.clear])
        }
    }    
    
    @IBAction func btnStartClick(_ sender: Any) {
        if !pomodoro.isValid {
            startPomodoro()
        }
    }
    
    @IBAction func btnStopClick(_ sender: Any) {
        pomodoro.invalidate()
        btnStart.isEnabled = true
        btnStop.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layer?.backgroundColor = NSColor.white.cgColor
        if(!db.isOpened)
        {
            db.open()
        }
        if(!pomodoro.isValid)
        {
            btnStop.isEnabled = false
        }
        txtTimer.stringValue = timeString(time: TimeInterval(pomodoro.seconds))
    }
    
//    func numberOfItems(in comboBox: NSComboBox) -> Int {
//        // anArray is an Array variable containing the objects
//        return ["teste", "khvhgjh"].count
//    }
//    
//    // Returns the object that corresponds to the item at the specified index in the combo box
//    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
//        return ["teste", "khvhgjh"][index]
//    }
}

extension PopoverViewController {
    static func freshController() -> PopoverViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "PopoverViewController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? PopoverViewController else {
            fatalError("Why cant i find ViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}

