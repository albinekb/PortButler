//
//  Array.swift
//  PortButler
//
//  Created by Albin Ekblom on 2020-07-26.
//  Copyright © 2020 Albin Ekblom. All rights reserved.
//

import Foundation


extension Array {
   func filteredByType<T> (_: T.Type) -> [T] {
       return compactMap({ (element) in
           return element as? T
       })
   }
}
