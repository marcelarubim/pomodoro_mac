//
//  Style.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 04.01.18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Foundation
import Cocoa

let SelectedThemeKey = "SelectedTheme"
let pstyle = NSMutableParagraphStyle()
//pstyle.alignment = .center

public enum Theme: Int {
    case Default, Dark, Graphical
    
    var mainColor: NSColor {
        switch self {
        case .Default:
            return NSColor.gray
        case .Dark:
            return NSColor.black
        case .Graphical:
            return NSColor.blue
        }
    }
    
    var buttonStyle: [NSAttributedStringKey : Any] {
        switch self {
        case .Default:
            return [ NSAttributedStringKey.foregroundColor : NSColor.black,
                     NSAttributedStringKey.paragraphStyle : ThemeManager.pragraphStyle(alignment: 0),
                     NSAttributedStringKey.backgroundColor : NSColor.clear]
        case .Dark:
            return [ NSAttributedStringKey.foregroundColor : NSColor.white,
                     NSAttributedStringKey.paragraphStyle : ThemeManager.pragraphStyle(alignment: 0),
                     NSAttributedStringKey.backgroundColor : NSColor.clear]
//
//            button.attributedTitle = NSMutableAttributedString(string: "Hello World", attributes: [NSAttributedStringKey.foregroundColor: NSColor.white, NSAttributedStringKey.paragraphStyle: style, NSAttributedStringKey.font: NSFont.systemFont(ofSize: 18)])

        case .Graphical:
            return [ NSAttributedStringKey.foregroundColor : NSColor.blue,
                     NSAttributedStringKey.paragraphStyle : ThemeManager.pragraphStyle(alignment: 0),
                     NSAttributedStringKey.backgroundColor : NSColor.clear]
        }
    }
}

struct ThemeManager {
    static func currentTheme() -> Theme {
        if let storedTheme = UserDefaults.standard.object(forKey: SelectedThemeKey) as? Int? ?? Int(){
            return Theme(rawValue: storedTheme)!
        } else {
            return .Default
        }
    }
    
    static func applyTheme(theme: Theme) {
        UserDefaults.standard.set(theme.rawValue, forKey: SelectedThemeKey)
        UserDefaults.standard.synchronize()
        
        let sharedApplication = NSApplication.shared
        sharedApplication.keyWindow?.backgroundColor = NSColor.black
    }
    
    static func pragraphStyle(alignment: Int) -> NSMutableParagraphStyle {
        var pstyle = NSMutableParagraphStyle()
        switch alignment {
        case 1:
            pstyle.alignment = .left
        case 2:
            pstyle.alignment = .right
        case 0:
            pstyle.alignment = .center
        default:
            pstyle = NSMutableParagraphStyle.default as! NSMutableParagraphStyle
        }
        return pstyle
    }
}



