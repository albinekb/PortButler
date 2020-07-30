//
//  ProgressIndicator.swift
//  PortButler
//
//  Created by Albin Ekblom on 2020-07-30.
//  Copyright © 2020 Albin Ekblom. All rights reserved.
//

import Foundation
import AppKit
import Cocoa
import SwiftUI

struct ProgressIndicator: NSViewRepresentable {
    
    typealias TheNSView = NSProgressIndicator
    var configuration = { (view: TheNSView) in }
    
    func makeNSView(context: NSViewRepresentableContext<ProgressIndicator>) -> NSProgressIndicator {
        TheNSView()
    }
    
    func updateNSView(_ nsView: NSProgressIndicator, context: NSViewRepresentableContext<ProgressIndicator>) {
        configuration(nsView)
    }
}
