//
//  DisabledScroll.swift
//  PortButler
//
//  Created by Albin Ekblom on 2020-07-28.
//  Copyright © 2020 Albin Ekblom. All rights reserved.
//

import Cocoa
import Foundation

@IBDesignable
@objc(BCLDisablableScrollView)
public class DisablableScrollView: NSScrollView {
    @IBInspectable
    @objc(enabled)
    public var isEnabled: Bool = true

    override public func scrollWheel(with event: NSEvent) {
        if isEnabled {
            super.scrollWheel(with: event)
        } else {
            nextResponder?.scrollWheel(with: event)
        }
    }
}
