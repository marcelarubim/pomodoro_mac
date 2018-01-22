//
//  ViewController.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 03.01.18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Cocoa
import SQLite

class ViewController: NSViewController, NSComboBoxDataSource {
    var db = Database()
    var pomodoro = Pomodoro(timerSeconds: 10)
    var result = 0
//    let activity = NSBackgroundActivityScheduler(identifier: "com.pomodoro.DispatchRider.tasks")

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
            // This is set in seconds, but as background activities slop around in minutes, I only give the user the benefit of using minutes
//            activity.interval = TimeInterval(60)
//            activity.repeats = true
//            activity.qualityOfService = .default
//            activity.tolerance = 30
//            let theCmd = commandText.stringValue
//            let theParamStr = paramsText.stringValue
//            let theParamList = paramsText.stringValue.components(separatedBy: "&arg:")
//
//            activity.schedule() { (completion:
//                NSBackgroundActivityScheduler.CompletionHandler) in
//                self.txtTimer.stringValue = "\(self.result)"
//                self.result += 1
//                let task = Process()
//                task.launchPath = theCmd
//                if (theParamStr == "") {
//                    task.arguments = []
//                } else {
//                    task.arguments = theParamList
//                }
//                let outPipe = Pipe()
//                task.standardOutput = outPipe
//                task.launch()
//                task.waitUntilExit()
//                os_log("DispatchRider task ran.")
//                completion(NSBackgroundActivityScheduler.Result.finished)
//            }
        }
    }
    
    @IBAction func btnStopClick(_ sender: Any) {
        pomodoro.invalidate()
        btnStart.isEnabled = true
        btnStop.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        NotificationCenter.default.addObserver(self, selector: #selector(fieldTextDidChange), name: NSNotification.Name(rawValue: "NSTextDidEndEditingNotification"), object: nil)
    }

    override func viewWillAppear() {
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
        cbxName.usesDataSource = true
        cbxName.dataSource = self
    }
    
    static func freshController() -> ViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "ViewController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? ViewController else {
            fatalError("Why cant i find ViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        // anArray is an Array variable containing the objects
        return ["teste", "khvhgjh"].count
    }
    
    // Returns the object that corresponds to the item at the specified index in the combo box
    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        return ["teste", "khvhgjh"][index]
    }
}

