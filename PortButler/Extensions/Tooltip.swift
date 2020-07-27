//
//  Tooltip.swift
//  PortButler
//
//  Created by Albin Ekblom on 2020-07-27.
//  Copyright © 2020 Albin Ekblom. All rights reserved.
//

import Foundation
import SwiftUI

public extension View {
    /// Overlays this view with a view that provides a Help Tag.
    func toolTip(_ toolTip: String) -> some View {
        self.overlay(TooltipView(toolTip: toolTip))
    }
}

private struct TooltipView: NSViewRepresentable {
    let toolTip: String

    func makeNSView(context: NSViewRepresentableContext<TooltipView>) -> NSView {
        NSView()
    }

    func updateNSView(_ nsView: NSView, context: NSViewRepresentableContext<TooltipView>) {
        nsView.toolTip = self.toolTip
    }
}
