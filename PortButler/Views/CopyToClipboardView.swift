//
//  CopyToClipboardView.swift
//  PortButler
//
//  Created by Albin Ekblom on 2020-07-29.
//  Copyright © 2020 Albin Ekblom. All rights reserved.
//

import Foundation
import SwiftUI
import Cocoa
import AppKit
import Introspect

//private class TextFieldObserver: NSObject {
//    @objc
//    func textFieldDidBeginEditing(_ textField: NSTextField) {
//        textField.selectAll(nil)
//    }
//}

//            TextField("", text: .constant(self.text))
//            .textFieldStyle(PlainTextFieldStyle())
//            .padding(1)
//                .background(Rectangle().fill(Color.clear))
//                .frame(maxWidth: .infinity)
                
//                .introspectTextField { field in
//                    field.addTarget(
//                        self.textFieldObserver,
//                        action: #selector(TextFieldObserver.textFieldDidBeginEditing),
//                        for: .editingDidBegin
//                    )
//            }
//NSImageNameQuickLookTemplate
struct ClipboardIcon: View {
    var isCopied: Bool;
    var body: some View {
        HStack{
            if !isCopied {
//                Image(nsImage: NSImage(named: "paperclipCircle")!
                Image(nsImage: NSImage(named: "NSShareTemplate")!
                    .image(withTintColor: NSColor.systemBlue))
//                    .resizable()
//                    .frame(width: 16, height: 16)
            } else {
//                Image(nsImage: NSImage(named: "checkmarkCircle")!
                Image(nsImage: NSImage(named: "NSMenuOnStateTemplate")!
                    .image(withTintColor: NSColor.systemGray))
//                    .resizable()
//                    .frame(width: 16, height: 16)
            }
        }
    }
    
}

struct CopyToClipboard<Child>: View where Child: View {
    var text: String
    private var child: Child
    
    @State private var isHovered: Bool = false
    @State private var isCopied: Bool = false

//    private let textFieldObserver = TextFieldObserver()


    init(text: String, _ child: Child) {
        self.child = child
        self.text = text
    }

    var body: some View {
        HStack(alignment: .center){
            AnyView(self.child)
            Button(action: self.copyString){ ClipboardIcon(isCopied: self.isCopied).toolTip("Copy port to clipboard") }
                
                .buttonStyle(PlainButtonStyle())
                .onHover(perform: { hovered in
                    if self.isCopied {
                        if self.isHovered {
                            self.isHovered = false
                            NSCursor.pop()
                        }
                        return
                    }
                    self.isHovered = hovered
                    if hovered { NSCursor.dragCopy.push() } else { NSCursor.pop() }
                })
                
                .opacity(self.isHovered ? 0.7 : 1)
        }
    }
    
    func copyString() {
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        pasteboard.setString(self.text, forType: NSPasteboard.PasteboardType.string)
        self.isCopied = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.isCopied = false
        }
        //NotificationCenter.default.post(name: NSNotification.PopoverRequestClose, object: nil)
    }
}
