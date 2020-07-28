//
//  ListView.swift
//  PortButler
//
//  Created by Albin Ekblom on 2020-07-26.
//  Copyright © 2020 Albin Ekblom. All rights reserved.
//

import Foundation
import Combine


import SwiftUI
import Introspect



struct RowView<Child>: View where Child: View {
    var port: () -> Child
    var pid: () -> Child
    var title: AnyView
    var action: AnyView
    private let columns: CGFloat = 3

    var body: some View {
        VStack(alignment: .leading) {
            GeometryReader { geometry in
                HStack(alignment: .top) {
                    HStack{Group(content: self.port);Spacer()}.frame(width: ((geometry.size.width / 12) * 2))
                    //HStack{Group(content: self.pid);Spacer()}.frame(width: geometry.size.width / 4)
                    HStack{AnyView(self.title);Spacer()}.frame(minWidth: ((geometry.size.width / 12) * 8), maxWidth: .infinity)
                    HStack{Spacer();AnyView(self.action);}.frame(width: ((geometry.size.width / 12) * 2))
                }
            }
        }
    }
}

struct OpenPageButton: View {
    var title: String
    var action: () -> Void
    @State var isHovered: Bool = false
    


    var body: some View {
        Button(action: self.action) {
            Image(nsImage: NSImage(imageLiteralResourceName: NSImage.followLinkFreestandingTemplateName)).opacity(self.isHovered ? 1 : 0.5)
            }
            .toolTip(self.title)
            .buttonStyle(PlainButtonStyle())
            .onHover(perform: { hovered in
              self.isHovered = hovered
              if hovered {
                NSCursor.pointingHand.push()
              } else {
                NSCursor.pop()
              }
            })
          .onTapGesture(perform: self.action)
    }
}

struct PortRowView: View {
    var port: Port
    
    var body: some View {
        RowView(
            port: {Text(String(self.port.port)).font(.system(.caption, design: .monospaced)).bold()},
            pid: {Text(String(self.port.netstat?.pid ?? "")).font(.system(.caption, design: .monospaced))},
            title: AnyView(BrowserTitleView(port: self.port.port)),
            action: AnyView(OpenPageButton(title: "Open URL", action: self.openUrl))
        )
    }
    
    
    func openUrl() {
        let url = URL(string: "http://localhost:" + String(self.port.port))!
        NSWorkspace.shared.open(url)
    }
}

struct PortsListView: View {
    var ports: Array<Port>

    
    var body: some View {
        Group{
            List{
                RowView(port: {Text("Port")}, pid: {Text("Pid")}, title: AnyView(Text("Title")), action: AnyView(Text("Open"))).frame(height: 40)
                .introspectScrollView { (scroll: NSScrollView) in scroll.hasVerticalScroller = false }
            }
            .listStyle(SidebarListStyle()).frame(maxHeight: 30)
            
            List(self.ports, id: \.self) { port in
              PortRowView(port: port).frame(height: 40)
            }
            .listStyle(SidebarListStyle())
        }
    }

}
