//
//  StatusBarController.swift
//  PortButler
//
//  Created by Albin Ekblom on 2020-07-26.
//  Copyright © 2020 Albin Ekblom. All rights reserved.
//

import AppKit


extension NSNotification {
    static let PopoverRequestClose = NSNotification.Name.init("PopoverRequestClose")
    static let ViewDidAppear = Notification.Name("ViewDidAppear")
}


class StatusBarController {
    //private var statusBar: NSStatusBar
    private var statusItem: NSStatusItem
    private var popover: NSPopover
    let NC = NotificationCenter.default


    
    init(_ popover: NSPopover)
    {
        self.popover = popover

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        let itemImage =  #imageLiteral(resourceName: "StatusIcon")
        itemImage.size = NSSize(width: 32, height: 22)
        itemImage.isTemplate = true
        if let statusBarButton = statusItem.button {
            statusBarButton.image = itemImage
            statusBarButton.sendAction(on: [NSEvent.EventTypeMask.leftMouseDown, NSEvent.EventTypeMask.rightMouseDown])
            statusBarButton.target = self
            statusBarButton.action = #selector(handleButton(sender:))
        }
    }
    
    
    @objc func handleButton(sender: NSStatusItem?) {
        let event = NSApp.currentEvent!
        
        
        

        if event.type == NSEvent.EventType.rightMouseDown {
            self.hidePopover(nil)
        } else if event.type == NSEvent.EventType.leftMouseDown {
            self.togglePopover(sender: sender)
        }
    }
    
    @objc func rightMouseDown (sender: AnyObject?) {
        
    }

    
    @objc func togglePopover(sender: AnyObject?) {
        if(popover.isShown) {
            hidePopover(sender)
        }
        else {
            showPopover(sender)
        }
    }
    
    func showPopover(_ sender: AnyObject?) {
        //NSRunningApplication.current.activate(options:NSApplication.ActivationOptions.activateIgnoringOtherApps)
        guard let statusBarButton = statusItem.button else { return }
        
        

    
        popover.show(relativeTo: statusBarButton.bounds, of: statusBarButton, preferredEdge: NSRectEdge.maxY)
    }
    
    func hidePopover(_ sender: AnyObject?) {
        popover.performClose(sender)
    }
    
    func handlePopoverRequestClose(_ notification: Notification) {
        self.hidePopover(nil)
    }
    
    func mouseEventHandler(_ event: NSEvent?) {
        if(popover.isShown) {
            hidePopover(event!)
        }
    }
}
