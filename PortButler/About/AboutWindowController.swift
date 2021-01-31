//
//  AboutWindowController.swift
//  PortButler
//
//  Created by Albin Ekblom on 2021-01-31.
//  Copyright © 2021 Albin Ekblom. All rights reserved.
//


import Cocoa

class AboutWindowController: NSWindowController {

    static let defaultController: AboutWindowController = {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("AboutWindow"), bundle:nil)
        guard let windowController = storyboard.instantiateInitialController() as? AboutWindowController else {
            fatalError("Storyboard inconsistency")
        }
        return windowController
    }()
    


    override func windowDidLoad() {
        super.windowDidLoad()
        self.window?.orderFrontRegardless()

        // Customize the window's overall appearance:
        self.window?.appearance = NSAppearance(named: .vibrantDark)
    }
    
    override func resignFirstResponder() -> Bool {
        
        self.window?.close()
        return super.resignFirstResponder()
    }
}
