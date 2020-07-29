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

struct CopyToClipboard<Child>: View where Child: View {
    var text: String
    private var child: Child
    
    @State var isHovered: Bool = false

//    private let textFieldObserver = TextFieldObserver()


    init(text: String, _ child: Child) {
        self.child = child
        self.text = text
    }

    var body: some View {
        HStack{
            AnyView(self.child).onTapGesture {
                self.copyString()
            }
            Button(action: self.copyString) {
                Image(nsImage: NSImage(named: NSImage.shareTemplateName)!.image(withTintColor: NSColor.systemBlue)).opacity(self.isHovered ? 1 : 0.8)
            }
                .toolTip("Copy port to clipboard")
                .buttonStyle(PlainButtonStyle())
                .onHover(perform: { hovered in
                    self.isHovered = hovered
                    if hovered { NSCursor.pointingHand.push() } else { NSCursor.pop() }
                })
                .onTapGesture(perform: self.copyString)
        }
    }
    
    func copyString() {
        let pasteboard = NSPasteboard.general
        pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
        pasteboard.setString(self.text, forType: NSPasteboard.PasteboardType.string)
    }
}
