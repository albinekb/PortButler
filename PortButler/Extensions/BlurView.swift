//
//  BlurView.swift
//  PortButler
//
//  Created by Albin Ekblom on 2020-07-27.
//  Copyright © 2020 Albin Ekblom. All rights reserved.
//

import Foundation
import SwiftUI
import Cocoa

struct BlurView: NSViewRepresentable {
  typealias NSViewType = NSVisualEffectView

  public func makeNSView(context: NSViewRepresentableContext<BlurView>) -> NSVisualEffectView {
    let view = NSVisualEffectView()
    view.blendingMode = .behindWindow
    view.material = .toolTip
    return view
  }

  public func updateNSView(_ nsView: NSVisualEffectView, context: NSViewRepresentableContext<BlurView>) {

  }
}

struct BlurView_Previews: PreviewProvider {
    static var previews: some View {
        BlurView()
    }
}
