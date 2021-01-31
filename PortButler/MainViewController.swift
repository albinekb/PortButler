//
//  MainViewController.swift
//  PortButler
//
//  Created by Albin Ekblom on 2020-07-26.
//  Copyright © 2020 Albin Ekblom. All rights reserved.
//

import AppKit

class MainViewController: NSViewController {
    override func viewDidAppear() {
        super.viewDidAppear()

        // Needed so clicks outside the app trigger
        // events to close the popover
        // NSApp.activate(ignoringOtherApps: false)
        // You can use a notification and observe it in a view model where you want to fetch the data for your SwiftUI view every time the popover appears.

        ObservablePorts.shared.scan()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
