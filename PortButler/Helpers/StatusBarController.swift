//
//  StatusBarController.swift
//  PortButler
//
//  Created by Albin Ekblom on 2020-07-26.
//  Copyright © 2020 Albin Ekblom. All rights reserved.
//

import AppKit

extension NSStatusBarButton {

   public override func mouseDown(with: NSEvent) {

    if (with.modifierFlags.contains(.control)) {
            self.rightMouseDown(with: with)
            return
        }

        self.highlight(true)

    (self.target)?.togglePopover(sender:nil)
    }
}

class StatusBarController {
    private var statusBar: NSStatusBar
    private var statusItem: NSStatusItem
    private var popover: NSPopover
    private var eventMonitor: EventMonitor?
    
    init(_ popover: NSPopover)
    {
        self.popover = popover
        

        statusBar = NSStatusBar.init()
        statusItem = statusBar.statusItem(withLength: 28.0)


        //statusItem = statusBar.statusItem(withLength: NSStatusItem.squareLength)
        
        if let statusBarButton = statusItem.button {
            
            statusBarButton.title = "😎"
            let itemImage = NSImage(named: "StatusBarIcon")
            //statusBarButton.image = #imageLiteral(resourceName: "StatusBarIcon")
            
            itemImage?.size = NSSize(width: 20.0, height: 20.0)
            itemImage?.isTemplate = true
            
            statusBarButton.image = itemImage
            statusBarButton.image?.isTemplate = true
            statusBarButton.action = #selector(handleButton(sender:))
            statusBarButton.sendAction(on: [NSEvent.EventTypeMask.leftMouseDown, NSEvent.EventTypeMask.rightMouseDown])

            
            //(statusBarButton.cell as? NSButtonCell)?.highlightsBy = .changeBackgroundCellMask
            //statusBarButton.highlight(true)
            //statusBarButton.setButtonType(NSButton.ButtonType.pushOnPushOff)
            //statusBarButton.state = .off
            
            statusBarButton.target = self
        }
        
        
        

        
        
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown], handler: mouseEventHandler)
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
        NSRunningApplication.current.activate(options:NSApplication.ActivationOptions.activateIgnoringOtherApps)
        guard let statusBarButton = statusItem.button else { return }
        
        

        DispatchQueue.main.async(execute: {
            statusBarButton.highlight(true)
        })
        popover.show(relativeTo: statusBarButton.bounds, of: statusBarButton, preferredEdge: NSRectEdge.maxY)
        eventMonitor?.start()
    }
    
    func hidePopover(_ sender: AnyObject?) {
        guard let statusBarButton = statusItem.button else { return }
        DispatchQueue.main.async(execute: {
            statusBarButton.highlight(false)
        })
        popover.performClose(sender)
        eventMonitor?.stop()
    }
    
    func mouseEventHandler(_ event: NSEvent?) {
        if(popover.isShown) {
            hidePopover(event!)
        }
    }
}
