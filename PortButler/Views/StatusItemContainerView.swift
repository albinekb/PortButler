//
//  StatusItemContainerView.swift
//  PortButler
//
//  Created by Albin Ekblom on 2020-07-28.
//  Copyright © 2020 Albin Ekblom. All rights reserved.
//

import Cocoa

class StatusItemContainerView: NSView {
    enum Constants {
        static let maxContainerSize: CGFloat = 22.0
        static let maxContentHeight: CGFloat = 18.0
    }

    func embed(_ view: NSView) {
        addSubview(view)

        let selfFrame = NSRect(
            x: 0,
            y: 0,
            width: max(NSWidth(view.bounds), Constants.maxContainerSize),
            height: Constants.maxContainerSize
        )
        let contentFrame = NSRect(
            x: 0,
            y: (Constants.maxContainerSize - Constants.maxContentHeight) / 2,
            width: NSWidth(view.bounds),
            height: Constants.maxContentHeight
        )

        frame = selfFrame
        view.frame = contentFrame
    }
}
