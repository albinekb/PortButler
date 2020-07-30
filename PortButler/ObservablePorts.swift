//
//  ObservablePorts.swift
//  PortButler
//
//  Created by Albin Ekblom on 2020-07-26.
//  Copyright © 2020 Albin Ekblom. All rights reserved.
//

import Foundation
import SwiftUI
import Combine
import ShellOut

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

func getFolderFromPid(pid: String) {
    do {
        let output = try shellOut(to: "lsof", arguments: ["-p 6501"])
        let lines: Array<String> = output.components(separatedBy: "\n")
       print(lines)
    } catch {
        let error = error as! ShellOutError
        print(error.message) // Prints STDERR
        print(error.output) // Prints STDOUT
    }
    
}


class ObservablePorts: ObservableObject {
    @Published var ports: Array<Port> = []
    @Published var isLoading: Bool = false
    
    var timer = Timer()
    
    private func runScan () {
        self.isLoading = true
        do {
            let output = try shellOut(to: "netstat", arguments: ["-Watnlv"])
            let lines: Array<String> = output.components(separatedBy: "\n")
            let filteredLines: Array<String> = lines.filter{$0.contains("LISTEN")}
            let rows: Array<NetstatEntry> = filteredLines.map{ (line) -> NetstatEntry? in
                let cols = line.split(separator: " ", omittingEmptySubsequences: true)
                guard let port = String(cols[3]).split(separator: ".").last else {
                    return nil
                }
                
                let pid = String(cols[8])
                //getFolderFromPid(pid: pid)
                
                return NetstatEntry(
                    proto: String(cols[0]),
                    recvQ: String(cols[1]),
                    sendQ: String(cols[2]),
                    localAddress: String(cols[3]),
                    state: String(cols[4]),
                    rhiwat: String(cols[5]),
                    shiwat: String(cols[6]),
                    pid: pid,
                    port: Int(String(port)) ?? 0
                )
            }.filteredByType(NetstatEntry.self)
                
            let entries: Array<NetstatEntry> = rows.filter{ $0.port > PortConstants.lowerLimit && $0.port < PortConstants.upperLimit }
            let ports: Array<Port> = entries.map{Port(netstat: $0, port: $0.port, state: $0.state)}
            
            self.ports = ports
            self.isLoading = false
        } catch {
            self.isLoading = false
            let error = error as! ShellOutError
            print(error.message) // Prints STDERR
            print(error.output) // Prints STDOUT
        }
    }
    
    
    func scan () {
        print("Start: scan()")
        self.runScan()
        print("Finish: scan()")
    }
}
