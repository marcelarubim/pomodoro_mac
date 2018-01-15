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
    
    fileprivate let cellId = "cellId"

    var db = Database()
    var pomodoro = Pomodoro()
    var resumeClicked = false
    
    var dateFormatter: DateFormatter = {
        let _formatter = DateFormatter()
        _formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
        _formatter.locale = Locale(identifier: "en_US_POSIX")
        _formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return _formatter
    }()
//    collectionView?.register(ArticleViewCell.self, forCellWithReuseIdentifier: cellId)
//    collectionView?.backgroundColor = .white

    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var timerLabel: NSTextField!
    @IBOutlet weak var startBtn: NSButton!
    @IBOutlet weak var pauseBtn: NSButton!
    @IBOutlet weak var restartBtn: NSButton!
    {
        didSet {
            restartBtn.attributedTitle = NSAttributedString(string: "Restart", attributes: [NSAttributedStringKey.foregroundColor : NSColor.red])
        }
    }    
    
    @IBAction func startButtonClicked(_ sender: Any) {
        if !pomodoro.isValid {
            startPomodoro()
        }
    }
    
    @IBAction func pauseButtonClicked(_ sender: Any) {
        if self.resumeClicked == false {
            self.resumeClicked = true
            self.pauseBtn.attributedTitle = NSAttributedString(string: "Resume")
            pomodoro.invalidate()
        } else {
            startPomodoro()
            self.resumeClicked = false
        }
    }
    
    @IBAction func resetButtonClicked(_ sender: Any) {
        pomodoro.invalidate()
        timerLabel.stringValue = timeString(time: TimeInterval(pomodoro.seconds))
        pauseBtn.isEnabled = false
        startBtn.isEnabled = true
    }
    
    fileprivate func configureCollectionView() {
        // 1
        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.sectionInset = NSEdgeInsets(top: 10.0, left: 20.0, bottom: 10.0, right: 20.0)
        flowLayout.minimumInteritemSpacing = 10.0
        flowLayout.minimumLineSpacing = 10.0
        collectionView.collectionViewLayout = flowLayout
        // 2
        collectionView.wantsLayer = true
        // 3
        collectionView.backgroundColors = [NSColor.clear]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        db.open()
                
        pauseBtn.isEnabled = false
        timerLabel.stringValue = timeString(time: TimeInterval(pomodoro.seconds))
//        configureCollectionView()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}

