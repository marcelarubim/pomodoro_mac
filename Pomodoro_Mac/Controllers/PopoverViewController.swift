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
    var db = Database.standard
    var pomodoro: Pomodoro!
    var isMuted: Bool = false {
        didSet {
            btnStart.sound?.volume = isMuted ? 0.0 : 1.0
        }
    }
    
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
        pomodoro = Pomodoro(timerSeconds: UserDefaults.standard.integer(forKey: "TimerSeconds"))
        UserDefaults.standard.addObserver(self, forKeyPath: "Sound", options: .new, context: nil)
        isMuted = !UserDefaults.standard.bool(forKey: "Sound")
        
        view.layer?.backgroundColor = NSColor.white.cgColor
        cbxName.usesDataSource = true
        cbxName.dataSource = self
        if(!db.isOpened)
        {
            db.open()
        }
        if(!pomodoro.isValid)
        {
            btnStop.isEnabled = false
        }
    }

    deinit {
        UserDefaults.standard.removeObserver(self, forKeyPath: "Sound")
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "Sound" {
            isMuted = !UserDefaults.standard.bool(forKey: "Sound")
        }
    }

}



// MARK: - initialization
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

