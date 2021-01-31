//
//  ProgressIndicator.swift
//  PortButler
//
//  Created by Albin Ekblom on 2020-07-30.
//  Copyright © 2020 Albin Ekblom. All rights reserved.
//

import AppKit
import Cocoa
import Foundation
import SwiftUI

struct ProgressIndicator: NSViewRepresentable {
    typealias TheNSView = NSProgressIndicator
    var configuration = { (_: TheNSView) in }

    func makeNSView(context _: NSViewRepresentableContext<ProgressIndicator>) -> NSProgressIndicator {
        TheNSView()
    }

    func updateNSView(_ nsView: NSProgressIndicator, context _: NSViewRepresentableContext<ProgressIndicator>) {
        configuration(nsView)
    }
}
