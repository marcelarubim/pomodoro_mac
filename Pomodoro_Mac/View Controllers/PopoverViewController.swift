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
    private var pomodoro = PomodoroController()
    private var shouldBeep: Bool = false {
        didSet {
            btnStart?.sound?.volume = shouldBeep ? 1.0 : 0.0
        }
    }
    @IBOutlet weak var cbxName: NSComboBox!
    @IBOutlet weak var txtTimer: NSTextField!
    @IBOutlet weak var btnStart: NSButton!
    @IBOutlet weak var btnStop: NSButton!
    
    @IBAction func btnStartClick(_ sender: Any) {
        pomodoro.start()
    }
    
    @IBAction func btnStopClick(_ sender: Any) {
        pomodoro.stop()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setupCallbacks()
        
//        cbxName.usesDataSource = true
//        cbxName.dataSource = self
    }
    
    func toggleSound() {
        shouldBeep = UserDefaults.standard.bool(forKey: "Sound")
    }
    
    func setupStyle() {
        view.layer?.backgroundColor = NSColor.white.cgColor
        btnStart.attributedTitle = NSAttributedString(string: "Start", attributes: [.foregroundColor : NSColor.black,
                                                                                    .backgroundColor : NSColor.clear])
        btnStop.attributedTitle = NSAttributedString(string: "Stop", attributes: [.foregroundColor : NSColor.red,
                                                                                  .backgroundColor : NSColor.clear])
        shouldBeep = UserDefaults.standard.bool(forKey: "Sound")
    }
    
    private func setupCallbacks() {
        pomodoro.updateStatus = { status in
            self.update(status: status)
        }
        
        pomodoro.updateTime = { time in
            self.updateTimeText(time: time)
        }
    }
    
    private func updateTimeText(time: Int) {
        txtTimer.stringValue = TimeInterval(time).clockString
    }
    
    private func updateUndefined() {
        btnStart.isEnabled = true
        btnStop.isEnabled = false
    }
    
    private func updateRunning() {
        btnStart.isEnabled = false
        btnStop.isEnabled = true
    }
    
    private func updateComplete() {
        btnStart.isEnabled = true
        btnStop.isEnabled = false
    }
    
    private func update(status: TimerStatus) {
        switch status {
        case .undefined:
            updateUndefined()
        case .running:
            updateRunning()
        case .complete, .incomplete:
            updateComplete()
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
