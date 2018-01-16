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

//    collectionView?.register(ArticleViewCell.self, forCellWithReuseIdentifier: cellId)
//    collectionView?.backgroundColor = .white

    @IBOutlet weak var collectionView: NSCollectionView!
    @IBOutlet weak var timerLabel: NSTextField!
    @IBOutlet weak var startBtn: NSButton!
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
    
    @IBAction func resetButtonClicked(_ sender: Any) {
        pomodoro.invalidate()
        timerLabel.stringValue = timeString(time: TimeInterval(pomodoro.timerSeconds))
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
        
        timerLabel.stringValue = timeString(time: TimeInterval(pomodoro.seconds))
//        configureCollectionView()
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}

