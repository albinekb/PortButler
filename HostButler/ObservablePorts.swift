//
//  ObservablePorts.swift
//  HostButler
//
//  Created by Albin Ekblom on 2020-07-26.
//  Copyright © 2020 Albin Ekblom. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import ShellOut
//let output = try shellOut(to: "echo", arguments: ["Hello world"])
//print(output) // Hello world

public struct NetstatEntry {
    var proto: String
    var recvQ: String
    var sendQ: String
    var localAddress: String
    var state: String
    var rhiwat: String
    var shiwat: String
    var pid: String

    var port: Int
}

public struct Port: Hashable {
    var netstat: NetstatEntry?
    var port: Int
    var state: String
    public static func == (lhs: Port, rhs: Port) -> Bool {
        return lhs.port == rhs.port
    }
    public func hash(into hasher: inout Hasher) {
        hasher.combine(port)
    }
}


class ObservablePorts: ObservableObject {
    @Published var ports: Array<Port> = []
    
    var timer = Timer()
    
    
    func scan () {
        do {
            let output = try shellOut(to: "netstat", arguments: ["-Watnlv"])
            let lines: Array<String> = output.components(separatedBy: "\n")
            let filteredLines: Array<String> = lines.filter{$0.contains("LISTEN")}
            let rows: Array<NetstatEntry> = filteredLines.map{ (line) -> NetstatEntry? in
                let cols = line.split(separator: " ", omittingEmptySubsequences: true)
                guard let port = String(cols[3]).split(separator: ".").last else {
                    return nil
                }
                
                return NetstatEntry(
                    proto: String(cols[0]),
                    recvQ: String(cols[1]),
                    sendQ: String(cols[2]),
                    localAddress: String(cols[3]),
                    state: String(cols[4]),
                    rhiwat: String(cols[5]),
                    shiwat: String(cols[6]),
                    pid: String(cols[7]),
                    port: Int(String(port)) ?? 0
                )
            }.filteredByType(NetstatEntry.self)
                
            let entries: Array<NetstatEntry> = rows.filter{ $0.port > 2999 && $0.port < 4999 }
            let ports: Array<Port> = entries.map{Port(netstat: $0, port: $0.port, state: $0.state)}
            
            self.ports = ports
        } catch {
            let error = error as! ShellOutError
            print(error.message) // Prints STDERR
            print(error.output) // Prints STDOUT
        }

    }
    
    func start() {
//        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
//            self.counter += 1
//        }
    }
    
    // 4.
    func stop() {
//        timer.invalidate()
    }
    
    // 5.
    func reset() {
//        counter = 0
//        timer.invalidate()
    }
}
