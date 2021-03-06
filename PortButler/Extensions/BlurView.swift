//
//  BlurView.swift
//  PortButler
//
//  Created by Albin Ekblom on 2020-07-27.
//  Copyright © 2020 Albin Ekblom. All rights reserved.
//

import Cocoa
import Foundation
import SwiftUI

struct BlurView: NSViewRepresentable {
    typealias NSViewType = NSVisualEffectView

    public func makeNSView(context _: NSViewRepresentableContext<BlurView>) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.blendingMode = .behindWindow
        view.material = .toolTip
        return view
    }

    public func updateNSView(_: NSVisualEffectView, context _: NSViewRepresentableContext<BlurView>) {}
}

struct BlurView_Previews: PreviewProvider {
    static var previews: some View {
        BlurView()
    }
}
