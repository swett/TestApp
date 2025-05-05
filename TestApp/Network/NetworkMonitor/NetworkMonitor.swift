//
//  NetworkMonitor.swift
//  TestApp
//
//  Created by Mykyta Kurochka on 28.04.2025.
//

import Foundation
import Network

class NetworkMonitor {
    static let shared = NetworkMonitor()

     let monitor = NWPathMonitor()
     let queue = DispatchQueue(label: "NetworkMonitor")

    var isConnected: Bool = false

    private init() {
        monitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }
}
