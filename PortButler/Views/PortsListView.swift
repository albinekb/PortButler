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
    var port: AnyView
    var pid: () -> Child
    var title: AnyView
    var action: AnyView
    private let columns: CGFloat = 3

    var body: some View {
        VStack(alignment: .leading) {
            GeometryReader { geometry in
                HStack(alignment: .top) {
                    HStack{AnyView(self.port);Spacer(minLength: 0)}.frame(width: ((geometry.size.width / 12) * 2.5))
                    HStack{AnyView(self.action)}.frame(width: ((geometry.size.width / 12) * 1.5))
                    //HStack{Group(content: self.pid);Spacer(minLength: 0)}.frame(width: geometry.size.width / 4)
                    HStack{AnyView(self.title);Spacer(minLength: 0)}.frame(minWidth: ((geometry.size.width / 12) * 7), maxWidth: .infinity)
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
            Image(nsImage:
                NSImage(imageLiteralResourceName: NSImage.followLinkFreestandingTemplateName).image(withTintColor: NSColor.controlAccentColor)
            ).opacity(self.isHovered ? 0.7 : 1)
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
            port: AnyView(
                CopyToClipboard(text:String(self.port.port), Text(String(self.port.port)).font(.system(.caption, design: .monospaced)).bold())
            ),
            pid: {Text(String(self.port.netstat?.pid ?? "")).font(.system(.caption, design: .monospaced))},
            title: AnyView(HStack(alignment: .top){
                BrowserTitleView(port: self.port.port)
            }),
            action: AnyView(OpenPageButton(title: "Open URL", action: self.openUrl))
        )
            .frame(minHeight: 42, maxHeight: 80)
    }
    
    
    func openUrl() {
        let url = URL(string: "http://localhost:" + String(self.port.port))!
        NSWorkspace.shared.open(url)
    }
}

struct PortsListView: View {
    var ports: Array<Port>
    private let headerInsets = EdgeInsets(top: 0, leading: 12, bottom: 0, trailing: 12)
    private let listInsets = EdgeInsets(top: 0, leading: -5, bottom: 0, trailing: 0)

    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            RowView(
                port: AnyView(Text("Port").font(.system(.caption))),
                pid: {Text("Pid").font(.system(.caption))},
                title: AnyView(Text("Title").font(.system(.caption))),
                action: AnyView(Text("URL").font(.system(.caption))))
                .padding(self.headerInsets)
                .frame(maxHeight: 24)
            
            List(self.ports, id: \.self){ port in PortRowView(port: port) }
                .listStyle(SidebarListStyle())
                .padding(self.listInsets)
               
        }.frame(minWidth: 300, idealWidth: 320, maxWidth: 600, minHeight: 50,  maxHeight: 600, alignment: .top)
    }

}
