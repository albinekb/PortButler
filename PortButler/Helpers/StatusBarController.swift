//
//  StatusBarController.swift
//  PortButler
//
//  Created by Albin Ekblom on 2020-07-26.
//  Copyright © 2020 Albin Ekblom. All rights reserved.
//

import AppKit

//extension NSStatusBarButton {
//
//   public override func mouseDown(with: NSEvent) {
//
//    if (with.modifierFlags.contains(.control)) {
//            self.rightMouseDown(with: with)
//            return
//        }
//
//        self.highlight(true)
//
//    (self.target)?.togglePopover(sender:nil)
//    }
//}



class StatusBarController {
    private var statusBar: NSStatusBar
    private var statusItem: NSStatusItem
    private var popover: NSPopover
    private var eventMonitor: EventMonitor?
    
    init(_ popover: NSPopover)
    {
        self.popover = popover
        

        statusBar = NSStatusBar.init()
        statusItem = statusBar.statusItem(withLength: 32)
        
        

        //statusItem = statusBar.statusItem(withLength: NSStatusItem.squareLength)
        
        if let statusBarButton = statusItem.button {
            
            //statusBarButton.title = "🔗"
            let itemImage =  #imageLiteral(resourceName: "StatusIcon")
//            let itemImage = NSImage(named: "StatusBarIcon")
//            //statusBarButton.image = #imageLiteral(resourceName: "StatusBarIcon")
//
            itemImage.size = NSSize(width: 32, height: 22)
            
            itemImage.isTemplate = true

            statusBarButton.image = itemImage
            statusBarButton.image?.isTemplate = false
            statusBarButton.action = #selector(handleButton(sender:))
            statusBarButton.sendAction(on: [NSEvent.EventTypeMask.leftMouseDown, NSEvent.EventTypeMask.rightMouseDown])
            ///statusBarButton.isHighlighted = true
            //statusBarButton.isBordered = true
            
            //(statusBarButton.cell as? NSButtonCell)?.highlightsBy = .changeBackgroundCellMask
            //statusBarButton.highlight(false)
//            print(statusBarButton.type)
            statusBarButton.setButtonType(NSButton.ButtonType.onOff)
            statusBarButton.appearance = NSAppearance(named: NSAppearance.Name.aqua)
            

            //statusBarButton.cell?.showsFirstResponder = false

//            let bColor = NSColor(red: 230.0/255.0, green: 230.0/255.0, blue: 230.0/255.0, alpha: 1)
//            (statusBarButton.cell as! NSButtonCell).backgroundColor = bColor
//            statusBarButton.layer?.backgroundColor = bColor.cgColor
//
//            (statusBarButton.cell as! NSButtonCell).showsStateBy = .contentsCellMask
//            (statusBarButton.cell as! NSButtonCell).highlightsBy = .changeBackgroundCellMask

            
            statusBarButton.target = self
            
        }
        NSEvent.addLocalMonitorForEvents(matching: .leftMouseDown) { [weak self] event in
            if event.window == self?.statusItem.button?.window {
                // Your action:
                self?.togglePopover(sender: self?.statusItem.button)
                return nil
            }

            return event
        }

        
        eventMonitor = EventMonitor(mask: [.leftMouseDown, .rightMouseDown], handler: mouseEventHandler)
    }
    
    private func configureStatusBarButton(with view: NSView) {
        guard let button = self.statusItem.button else { return }
        button.target = self
        button.action = #selector(handleButton(sender:))

        let statusItemContainer = StatusItemContainerView()
        statusItemContainer.embed(view)
        button.addSubview(statusItemContainer)
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
        
        

    
        popover.show(relativeTo: statusBarButton.bounds, of: statusBarButton, preferredEdge: NSRectEdge.maxY)
        eventMonitor?.start()
        DispatchQueue.main.async {
            statusBarButton.highlight(true)
        }
    }
    
    func hidePopover(_ sender: AnyObject?) {
        guard let statusBarButton = statusItem.button else { return }
       
        popover.performClose(sender)
        eventMonitor?.stop()
        DispatchQueue.main.async(execute: {
            statusBarButton.highlight(false)
        })
    }
    
    func mouseEventHandler(_ event: NSEvent?) {
        if(popover.isShown) {
            hidePopover(event!)
        }
    }
}
