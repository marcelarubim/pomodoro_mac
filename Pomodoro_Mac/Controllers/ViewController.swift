//
//  ViewController.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 03.01.18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    fileprivate let cellId = "cellId"
    //Array of type Article to store articles data after parsing JSON
    var sessions:[Session]?

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
    
    let timerSeconds = 60
    var seconds = 0//This variable will hold a starting value of seconds. It could be any amount above 0.
    var timer = Timer()
    var isTimerRunning = false //This will be used to make sure only one timer is created at a time.
    var resumeClicked = false
    
    @IBAction func startButtonClicked(_ sender: Any) {
        if isTimerRunning == false {
            runTimer()
            self.startBtn.isEnabled = false
        }
    }
    
    @IBAction func pauseButtonClicked(_ sender: Any) {
        if self.resumeClicked == false {
            timer.invalidate()
            self.resumeClicked = true
            self.pauseBtn.attributedTitle = NSAttributedString(string: "Resume")
        } else {
            runTimer()
            self.resumeClicked = false
        }
    }
    
    @IBAction func resetButtonClicked(_ sender: Any) {
        timer.invalidate()
        seconds = timerSeconds
        timerLabel.stringValue = timeString(time: TimeInterval(seconds))
        isTimerRunning = false
        pauseBtn.isEnabled = false
        startBtn.isEnabled = true
    }
    
    fileprivate func configureCollectionView() {
        // 1
        let flowLayout = NSCollectionViewFlowLayout()
//        flowLayout.itemSize = NSSize(width: 160.0, height: 140.0)
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
        pauseBtn.isEnabled = false
        seconds = timerSeconds
        
        let pstyle = NSMutableParagraphStyle()
        pstyle.alignment = .center        
        timerLabel.stringValue = timeString(time: TimeInterval(seconds))
        
//        configureCollectionView()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}

