//
//  ListView.swift
//  PortButler
//
//  Created by Albin Ekblom on 2020-07-26.
//  Copyright © 2020 Albin Ekblom. All rights reserved.
//

import Foundation



import SwiftUI

struct PortRowView: View {
    var port: Port
    @State var isHovered: Bool = false

    
    var body: some View {
        VStack{
            GeometryReader { geometry in
                HStack {
                    HStack{
                        Text(String(self.port.port)).font(.system(.caption, design: .monospaced))
                        Spacer()
                    }.frame(width: geometry.size.width / 4)
                        HStack{
                            Text(String(self.port.netstat?.pid ?? "")).font(.system(.caption, design: .monospaced))
                            Spacer()
                        }.frame(width: geometry.size.width / 4)
                    HStack{Spacer()}.frame(width: geometry.size.width / 4)
                    //HStack{Image(nsImage: NSImage(imageLiteralResourceName: NSImage.followLinkFreestandingTemplateName)).onTapGesture(perform: self.openUrl)}.frame(width: geometry.size.width / 4, height: 50)
                    //Button(action: self.openUrl){Text("Open"}
                    HStack{
                        Spacer()
                        Button(action: self.openUrl){
                            Image(nsImage: NSImage(imageLiteralResourceName: NSImage.followLinkFreestandingTemplateName)).opacity(0.5)
                        }
                            .toolTip("Open URL")
                            .buttonStyle(PlainButtonStyle())
                            .onHover(perform: { hovered in
                              self.isHovered = hovered
                              if hovered {
                                NSCursor.pointingHand.push()
                              } else {
                                NSCursor.pop()
                              }
                            })
                        
                    }.frame(width: geometry.size.width / 4)
                }
            }
        }.onTapGesture(perform: self.openUrl)
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
          PortRowView(port: port).frame(height: 40)
        }.listStyle(SidebarListStyle())
    }

}
