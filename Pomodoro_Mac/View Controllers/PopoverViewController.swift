//
//  ViewController.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 03.01.18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Cocoa

class PopoverViewController: NSViewController {
    @IBOutlet weak var cbxName: NSComboBox!
    @IBOutlet weak var txtTimer: NSTextField!
    @IBOutlet weak var btnStart: NSButton!
    @IBOutlet weak var btnStop: NSButton!
    
    var start:(() -> ())?
    var stop:(() -> ())?
    var getUniqueNames:(() -> ())?
    var updateName:((String) -> ())?
    
    var names:[String] = []
    private var doubleClicked: Bool = false
    private var isUpdatingCouter: Int = 2
    private var lastString: String!
    
    @IBAction func btnStartClick(_ sender: Any) {
        start?()
    }
    
    @IBAction func btnStopClick(_ sender: Any) {
        stop?()
    }
    
    @objc func cbxNameDoubleClick(_ sender: NSGestureRecognizer) {

        cbxName.isEditable = true
        doubleClicked = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        updateUndefined()
        
        cbxName.usesDataSource = true
        cbxName.dataSource = self
        cbxName.delegate = self
        
        let gesture = ClickHelper.doubleClick(target: self,
                                              action: #selector(cbxNameDoubleClick(_ :)))
        cbxName.addGestureRecognizer(gesture)
    }
    
    func toggleSound(shouldBeep: Bool) {
        btnStart?.sound?.volume = getVolume(shouldBeep)
    }
    
    func setupStyle() {
        view.layer?.backgroundColor = NSColor.white.cgColor
        btnStart.attributedTitle = NSAttributedString(string: "Start", attributes: [.foregroundColor : NSColor.black,
                                                                                    .backgroundColor : NSColor.clear])
        btnStop.attributedTitle = NSAttributedString(string: "Stop", attributes: [.foregroundColor : NSColor.red,
                                                                                  .backgroundColor : NSColor.clear])
        btnStart?.sound?.volume = getVolume(UserDefaults.standard.bool(forKey: "Sound"))
        cbxName.isEditable = false
    }
    
    func updateTimeText(time: Int) {
        txtTimer.stringValue = TimeInterval(time).clockString
    }
    
    func update(status: TimerStatus) {
        switch status {
        case .undefined:
            updateUndefined()
        case .running:
            updateRunning()
        case .complete, .incomplete:
            updateComplete()
        }
    }
    
    private func updateUndefined() {
        updateTimeText(time: 0)
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
    
    private func getVolume(_ shouldBeep: Bool) -> Float {
        return shouldBeep ? 1.0 : 0.0
    }
    
}

// MARK: - initialization
extension PopoverViewController {
    static func initFromNib() -> PopoverViewController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "PopoverViewController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? PopoverViewController else {
            fatalError("Why cant i find ViewController? - Check Main.storyboard")
        }
        return viewcontroller
    }
}

extension PopoverViewController: NSComboBoxDataSource, NSComboBoxDelegate {
    func uniqueNames(callback: () -> ()) {
        getUniqueNames?()
        callback()
    }
    
    func numberOfItems(in comboBox: NSComboBox) -> Int {
        var numOfItems:Int = 0
        uniqueNames() {
            numOfItems = names.count
        }
        return numOfItems
    }

    func comboBox(_ comboBox: NSComboBox, objectValueForItemAt index: Int) -> Any? {
        return names[index]
    }
    
    func comboBox(_ comboBox: NSComboBox, indexOfItemWithStringValue string: String) -> Int {
        return names.index(of: string) ?? -1
    }
    
    func comboBoxSelectionDidChange(_ notification: Notification) {
        updateName?(names[cbxName.indexOfSelectedItem])
    }
    
    override func controlTextDidEndEditing(_ obj: Notification) {
        if let comboBox = obj.object as? NSComboBox {
            updateName?(comboBox.stringValue)
            isUpdatingCouter -= 1
        }
    }
    
    override func validateProposedFirstResponder(_ responder: NSResponder, for event: NSEvent?) -> Bool {
        let value = super.validateProposedFirstResponder(responder, for: event)
        if doubleClicked && isUpdatingCouter <= 0 {
            cbxName.unselect()
            isUpdatingCouter = 2
            doubleClicked = false
            return false
        }
        return value
    }
}

