//
//  NavigationController.swift
//  Pomodoro_Mac
//
//  Created by Marcela Rubim on 28/04/18.
//  Copyright © 2018 Marcela Rubim. All rights reserved.
//

import Cocoa

class NavigationController: NSViewController {
    static func initFromNib() -> NavigationController {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        let identifier = NSStoryboard.SceneIdentifier(rawValue: "NavigationController")
        guard let viewcontroller = storyboard.instantiateController(withIdentifier: identifier) as? NavigationController else {
            fatalError("Why cant i find NavigationController? - Check Main.storyboard")
        }
        return viewcontroller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func changeViewController(next nextViewController: NSViewController) {
        addChildViewController(nextViewController)
        if let currentViewController = childViewControllers.last {
            transition(from: currentViewController, to: nextViewController, options: .crossfade) {
                currentViewController.removeFromParentViewController()
            }
        } else {
            view.addSubview(nextViewController.view)
            nextViewController.view.autoresizingMask = [.height, .width]
        }
        
    }
}
