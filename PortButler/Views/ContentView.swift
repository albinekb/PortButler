//
//  ContentView.swift
//  PortButler
//
//  Created by Albin Ekblom on 2020-07-26.
//  Copyright © 2020 Albin Ekblom. All rights reserved.
//

import SwiftUI

struct EmptyState: View {
    var isLoading: Bool
    var scan: () -> Void

    var body: some View {
        HStack(alignment: .center) {
            VStack {
                VStack {
                    Text("No open ports found in range ").font(.system(.caption)).padding(10)
                    Text(PortConstants.portRangeFormatted).font(.system(.caption, design: .monospaced))
                }
                if isLoading {
                    ProgressIndicator {
                        $0.style = .spinning
                        $0.sizeToFit()
                        $0.usesThreadedAnimation = true
                        $0.startAnimation(nil)
                        $0.controlSize = .small
                    }
                } else {
                    Button(action: scan) { Text("Scan") }
                }
            }
        }.frame(minWidth: 200, maxHeight: .infinity)
    }
}

struct ContentView: View {
    @ObservedObject var ports = ObservablePorts.shared

    var body: some View {
        Group {
            if self.ports.ports.count > 0 {
                PortsListView(ports: self.ports.ports)
            } else {
                EmptyState(isLoading: self.ports.isLoading, scan: scan)
            }
        } 
    }

    public func scan() {
        ports.scan()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
