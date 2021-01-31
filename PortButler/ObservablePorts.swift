//
//  ObservablePorts.swift
//  PortButler
//
//  Created by Albin Ekblom on 2020-07-26.
//  Copyright © 2020 Albin Ekblom. All rights reserved.
//

import Combine
import Foundation
import ShellOut
import SwiftUI

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

func getFolderFromPid(pid _: String) {
    do {
        let output = try shellOut(to: "lsof", arguments: ["-p 6501"])
        let lines: [String] = output.components(separatedBy: "\n")
        print(lines)
    } catch {
        let error = error as! ShellOutError
        print(error.message) // Prints STDERR
        print(error.output) // Prints STDOUT
    }
}

class ObservablePorts: ObservableObject {
    static let shared = ObservablePorts()

    @Published var ports: [Port] = []
    @Published var isLoading: Bool = false
    @Published var lastUpdated: Date? = nil

    var timer = Timer()

    private func runScan(_ override: Bool = false) {
        if override != true {
            if let lastUpdated = self.lastUpdated {
                let elapsedTime = Date().timeIntervalSince(lastUpdated)
                if elapsedTime < 5 {
                    print("Stopping")
                    return
                }
            }
        }

        isLoading = true
        do {
            let output = try shellOut(to: "netstat", arguments: ["-Watnlv"])
            let lines: [String] = output.components(separatedBy: "\n")
            let filteredLines: [String] = lines.filter { $0.contains("LISTEN") }
            let rows: [NetstatEntry] = filteredLines.map { (line) -> NetstatEntry? in
                let cols = line.split(separator: " ", omittingEmptySubsequences: true)
                guard let port = String(cols[3]).split(separator: ".").last else {
                    return nil
                }

                let pid = String(cols[8])
                // getFolderFromPid(pid: pid)

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

            let entries: [NetstatEntry] = rows.filter { $0.port > PortConstants.lowerLimit && $0.port < PortConstants.upperLimit }
            let ports: [Port] = entries.map { Port(netstat: $0, port: $0.port, state: $0.state) }

            self.ports = ports.sorted {
                $0.port < $1.port
            }
            let lastUpdated = Date()

            self.lastUpdated = lastUpdated
            isLoading = false
            NotificationCenter.default.post(name: Notification.Name("RefreshWebView"), object: nil)
        } catch {
            isLoading = false
            let error = error as! ShellOutError
            print(error.message) // Prints STDERR
            print(error.output) // Prints STDOUT
        }
    }

    func scan(_ override: Bool = false) {
        print("Start: scan()")
        runScan(override)
        print("Finish: scan()")
    }
}
