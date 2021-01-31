//
//  AppDelegate.swift
//  PortButler
//
//  Created by Albin Ekblom on 2020-07-26.
//  Copyright © 2020 Albin Ekblom. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    var popover = NSPopover()

    @IBOutlet var menu: NSMenu?
    @IBOutlet var refreshMenuItem: NSMenuItem?
    @IBOutlet var lastUpdatedMenuItem: NSMenuItem?

    var statusBar: StatusBarController?

    var contentView: ContentView?

    @IBAction func refreshAction(_: NSMenuItem) {
        ObservablePorts.shared.scan(true)
    }

    func applicationDidFinishLaunching(_: Notification) {
        NSApp.setActivationPolicy(.accessory)

        // Create the SwiftUI view that provides the contents
        contentView = ContentView()

        // Set the SwiftUI's ContentView to the Popover's ContentViewController
        popover.contentViewController = MainViewController()

        // popover.contentSize = NSSize(width: 320, height: 160)
        popover.contentViewController?.view = NSHostingView(rootView: contentView)
        
        // popover.appearance = NSAppearance(named: NSAppearance.Name.vibrantDark)
        
        popover.animates = true
        popover.behavior = .transient

        // Create the Status Bar Item with the Popover
        statusBar = StatusBarController(popover, menu: menu, lastUpdatedMenuItem: lastUpdatedMenuItem)

        popover.contentViewController?.view.window?.becomeKey()
    }

    func applicationWillTerminate(_: Notification) {
        // Insert code here to tear down your application
    }

    func applicationWillResignActive(_ notification: Notification) {
        statusBar?.handlePopoverRequestClose(notification)
        if let window = AboutWindowController.defaultController.window {
            window.close()
        }
        
    }

    func applicationWillBecomeActive(_: Notification) {
        ObservablePorts.shared.scan()
    }

    @IBAction func about(_: Any) {
        if let window = AboutWindowController.defaultController.window {
            window.orderFront(self)
            NSApp.activate(ignoringOtherApps: true)
        }
    }
}
