//
//  NSEvent.swift
//  PortButler
//
//  Created by Albin Ekblom on 2020-07-27.
//  Copyright © 2020 Albin Ekblom. All rights reserved.
//

import AppKit

extension NSEvent {
    var isRightClickUp: Bool {
        let rightClick = (type == .rightMouseUp)
        let controlClick = modifierFlags.contains(.control)
        return rightClick || controlClick
    }
}

extension NSEvent {
    var isRightClickDown: Bool {
        let rightClick = (type == .rightMouseDown)
        let controlClick = modifierFlags.contains(.control)
        return rightClick || controlClick
    }
}
