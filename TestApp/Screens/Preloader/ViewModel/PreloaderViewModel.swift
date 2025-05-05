//
//  PreloaderViewModel.swift
//  TestApp
//
//  Created by Mykyta Kurochka on 28.04.2025.
//

import Foundation

class PreloaderViewModel: ObservableObject {
    @Published var hasInternetConnection: Bool = true
    private let coordinator: Router?
    var networkMonitor: NetworkMonitor
    init(coordinator: Router? = nil, monitor: NetworkMonitor = NetworkMonitor.shared) {
        self.coordinator = coordinator
        self.networkMonitor = monitor
//        setupBindings()
    }
}

extension PreloaderViewModel {
    func showMain() {
            coordinator?.showMain()
    }
    
    func setupBindings() {
        // Directly read initial state
        hasInternetConnection = networkMonitor.isConnected
        // Start observing for changes
        networkMonitor.monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                print("called")
                let isConnected = path.status == .satisfied
                self?.hasInternetConnection = isConnected
                
                if isConnected {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        print("main")
                        self?.coordinator?.showMain()
                    }
                }  else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        print("error screen")
                        self?.coordinator?.showErrorScreen()
                    }
                }
            }
        }
        

    }
    
}
