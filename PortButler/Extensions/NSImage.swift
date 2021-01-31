//
//  NSImage.swift
//  PortButler
//
//  Created by Albin Ekblom on 2020-07-29.
//  Copyright © 2020 Albin Ekblom. All rights reserved.
//

import AppKit
import Foundation

// extension NSImage {
//    func tint(color: NSColor) -> NSImage {
//        let image = self.copy() as! NSImage
//        image.lockFocus()
//
//        color.set()
//
//        let imageRect = NSRect(origin: NSZeroPoint, size: image.size)
//        imageRect.fill(using: .sourceAtop)
//
//        image.unlockFocus()
//
//        return image
//    }
// }

extension NSImage {
    func image(withTintColor tintColor: NSColor) -> NSImage {
        guard isTemplate else { return self }
        guard let copiedImage = copy() as? NSImage else { return self }
        copiedImage.lockFocus()
        tintColor.set()
        let imageBounds = NSMakeRect(0, 0, copiedImage.size.width, copiedImage.size.height)
        imageBounds.fill(using: .sourceAtop)
        copiedImage.unlockFocus()
        copiedImage.isTemplate = false
        return copiedImage
    }
}
