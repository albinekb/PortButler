//
//  StatusBarController.swift
//  PortButler
//
//  Created by Albin Ekblom on 2020-07-26.
//  Copyright © 2020 Albin Ekblom. All rights reserved.
//

import AppKit

extension NSNotification {
    static let PopoverRequestClose = NSNotification.Name("PopoverRequestClose")
    static let RefreshWebView = NSNotification.Name("RefreshWebView")
    static let ViewDidAppear = Notification.Name("ViewDidAppear")
}

class StatusBarController {
    // private var statusBar: NSStatusBar
    private var statusItem: NSStatusItem
    private var lastUpdatedMenuItem: NSMenuItem?
    private var popover: NSPopover
    private var menu: NSMenu?

    let NC = NotificationCenter.default

    init(_ popover: NSPopover, menu: NSMenu?, lastUpdatedMenuItem: NSMenuItem?) {
        self.popover = popover
        self.menu = menu
        self.lastUpdatedMenuItem = lastUpdatedMenuItem

        statusItem = NSStatusBar.system.statusItem(withLength: 28)
        initButton()
    }

    fileprivate func initButton() {
        let itemImage = #imageLiteral(resourceName: "StatusIcon")
        itemImage.size = NSSize(width: 16, height: 16)
        itemImage.isTemplate = true
        if let statusBarButton = statusItem.button {
            statusBarButton.image = itemImage
            statusBarButton.sendAction(on: [NSEvent.EventTypeMask.leftMouseUp, NSEvent.EventTypeMask.rightMouseUp])
            statusBarButton.target = self
            statusBarButton.action = #selector(handleButton(sender:))
        }
    }

    @objc func handleButton(sender: NSStatusItem?) {
        let event = NSApp.currentEvent!

        if event.type == NSEvent.EventType.rightMouseUp {
            showMenu(sender)
        } else if event.type == NSEvent.EventType.leftMouseUp {
            if popover.isShown {
                hidePopover(sender)
            } else {
                showPopover(sender)
            }
        }
    }

    @objc func rightMouseDown(sender _: AnyObject?) {}

    @objc func togglePopover(sender: AnyObject?) {
        if popover.isShown {
            hidePopover(sender)
        } else {
            showPopover(sender)
        }
    }

    func showPopover(_: AnyObject?) {
//        NSRunningApplication.current.activate(options:NSApplication.ActivationOptions.activateIgnoringOtherApps)
        guard let statusBarButton = statusItem.button else { return }

        popover.show(relativeTo: statusBarButton.bounds, of: statusBarButton, preferredEdge: NSRectEdge.maxY)
    }

    func showMenu(_ sender: AnyObject?) {
        if popover.isShown {
            hidePopover(sender)
        }

        self.updateLastUpdateItem()
        statusItem.menu = menu
        statusItem.button?.performClick(nil)
        statusItem.menu = nil
    }
    
    func updateLastUpdateItem () {
        if let menuItem = lastUpdatedMenuItem {
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "HH:mm:SS"

            let ports = ObservablePorts.shared.ports
            if let lastUpdated = ObservablePorts.shared.lastUpdated {
                menuItem.title = "Last scan \(lastUpdated.timeAgoDisplay()) - \(ports.count) ports"
            }
        }
    }

    func hidePopover(_ sender: AnyObject?) {
        popover.performClose(sender)
    }

    func handlePopoverRequestClose(_: Notification) {
        hidePopover(nil)
    }

    func mouseEventHandler(_ event: NSEvent?) {
        if popover.isShown {
            hidePopover(event!)
        }
    }
}
