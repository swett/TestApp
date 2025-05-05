//
//  EthernetErrorViewModel.swift
//  TestApp
//
//  Created by Mykyta Kurochka on 28.04.2025.
//

import Foundation


class EthernetErrorViewModel: ObservableObject {
    @Published var hasInternetConnection: Bool = true
    private let coordinator: Router?
    var networkMonitor: NetworkMonitor
    init(coordinator: Router? = nil, monitor: NetworkMonitor = NetworkMonitor.shared) {
        self.coordinator = coordinator
        self.networkMonitor = monitor
    }
}

extension EthernetErrorViewModel {
    private func setupNetworkMonitoring() {
            // Set initial state
            hasInternetConnection = networkMonitor.isConnected
            
            // Listen for future changes
            networkMonitor.monitor.pathUpdateHandler = { [weak self] path in
                DispatchQueue.main.async {
                    self?.hasInternetConnection = (path.status == .satisfied)
                }
            }
        }
        
        func tryAgain() {
            if networkMonitor.isConnected {
                coordinator?.showMain() // or move to Main screen if connected
            } else {
                // Re-check manually if you want, but NWPathMonitor is already live
                hasInternetConnection = false
            }
        }
}
