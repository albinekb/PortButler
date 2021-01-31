//
//  Constants.swift
//  PortButler
//
//  Created by Albin Ekblom on 2020-07-30.
//  Copyright © 2020 Albin Ekblom. All rights reserved.
//

import Foundation

struct PortConstants {
    static let lowerLimit: Int = 2999
    static let upperLimit: Int = 4999
}

extension PortConstants {
    static let portRangeFormatted = String(PortConstants.lowerLimit) + "-" + String(PortConstants.upperLimit)
}
