//
//  NSTextField.swift
//  PortButler
//
//  Created by Albin Ekblom on 2020-07-29.
//  Copyright © 2020 Albin Ekblom. All rights reserved.
//

import Foundation
import AppKit

extension NSTextField { // << workaround !!!
    open override var focusRingType: NSFocusRingType {
        get { .none }
        set { }
    }
}
