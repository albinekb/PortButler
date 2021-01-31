//
//  NSTextField.swift
//  PortButler
//
//  Created by Albin Ekblom on 2020-07-29.
//  Copyright © 2020 Albin Ekblom. All rights reserved.
//

import AppKit
import Foundation

extension NSTextField { // << workaround !!!
    override open var focusRingType: NSFocusRingType {
        get { .none }
        set {}
    }
}
