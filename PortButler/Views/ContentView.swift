//
//  ContentView.swift
//  PortButler
//
//  Created by Albin Ekblom on 2020-07-26.
//  Copyright © 2020 Albin Ekblom. All rights reserved.
//

import SwiftUI

struct ContentView: View {
     @ObservedObject var ports = ObservablePorts()
    
  
    var body: some View {
        Group {
            if self.ports.ports.count > 0 {
                PortsListView(ports: self.ports.ports)
            } else {
                HStack(alignment: .center){Text("No ports open")}.frame(maxHeight: .infinity)
            }
        }
    }
    
    public func scan () {
        ports.scan()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
