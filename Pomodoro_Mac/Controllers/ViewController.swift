//
//  ViewController.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 03.01.18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Cocoa
import SQLite

class ViewController: NSViewController {
    var db = Database()
    var pomodoro = Pomodoro(timerSeconds: 5)

//    collectionView?.register(ArticleViewCell.self, forCellWithReuseIdentifier: cellId)
//    collectionView?.backgroundColor = .white

    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var timerLabel: NSTextField!
    @IBOutlet weak var startBtn: NSButton!
    @IBOutlet weak var stopBtn: NSButton!
    {
        didSet {
            stopBtn.attributedTitle = NSAttributedString(string: "Stop", attributes: [NSAttributedStringKey.foregroundColor : NSColor.red])
        }
    }    
    
    @IBAction func startButtonClicked(_ sender: Any) {
        if !pomodoro.isValid {
            startPomodoro()            
        }
    }
    
    @IBAction func stopButtonClicked(_ sender: Any) {
        pomodoro.invalidate()
        startBtn.isEnabled = true
        stopBtn.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db.open()
        stopBtn.isEnabled = false
        timerLabel.stringValue = timeString(time: TimeInterval(pomodoro.seconds))
    }
    
    static func freshController() -> ViewController {
        //1.
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        //2.
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "ViewController")
        //3.
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? ViewController else {
            fatalError("Why cant i find ViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
    
}

