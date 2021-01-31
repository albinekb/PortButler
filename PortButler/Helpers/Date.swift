//
//  Date.swift
//  PortButler
//
//  Created by Albin Ekblom on 2021-01-31.
//  Copyright © 2021 Albin Ekblom. All rights reserved.
//

import Foundation
extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
        if diff < 1 {
            return "now"
        }
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}
