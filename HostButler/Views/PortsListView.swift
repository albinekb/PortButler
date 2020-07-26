//
//  ListView.swift
//  HostButler
//
//  Created by Albin Ekblom on 2020-07-26.
//  Copyright © 2020 Albin Ekblom. All rights reserved.
//

import Foundation



import SwiftUI

struct PortRowView: View {
    var port: Port
    
    var body: some View {
        HStack(alignment: .center, spacing: 20) {
            Text(String(self.port.port))
            Button(action: self.openUrl){Text("Open")}
        }
    }
    
    func openUrl() {
        let url = URL(string: "http://localhost:" + String(self.port.port))!
        NSWorkspace.shared.open(url)
    }
}

struct PortsListView: View {
    var ports: Array<Port>
    
    var body: some View {
        List(self.ports, id: \.self) { port in
              PortRowView(port: port)
                .padding(.horizontal, 4)
        }
//        .listStyle(DefaultListStyle())
  }
  
  func openLatestRelease() {
    let url = URL(string: "https://github.com/daneden/zeitgeist/releases/latest")!
    NSWorkspace.shared.open(url)
  }
}
