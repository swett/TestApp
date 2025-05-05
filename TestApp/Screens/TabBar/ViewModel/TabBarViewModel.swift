//
//  TabBarViewModel.swift
//  TestApp
//
//  Created by Mykyta Kurochka on 02.05.2025.
//

import Foundation
enum Tab: Int, CaseIterable, Identifiable {
    case users = 0,singUp = 1
    var iconNamePassive: String{
        switch self {
        case .users:
            return "usersPassive"
        case .singUp:
            return "singUpPassive"
        }
    }
    
    var iconNameActive: String{
        switch self {
        case .users:
            return "usersActive"
        case .singUp:
            return "singUpActive"
        }
    }
    var id: Self { self }
}

@MainActor
class TabViewModel: ObservableObject {
    @Published var hasInternetConnection: Bool = true
    @Published var usersViewModel: UsersViewModel?
    @Published var singUpViewModel: SingUpViewModel?
    @Published var selectedTab: Tab = .users
    @Published var previousTab: Tab = .users
    var networkMonitor: NetworkMonitor
    private let coordinator: Router?
    init(coordinator: Router? = nil, monitor: NetworkMonitor = NetworkMonitor.shared) {
        self.coordinator = coordinator
        self.networkMonitor = monitor
        self.updateModels()
        self.setupBindings()
    }
    
     func updateModels() {
         usersViewModel = UsersViewModel()
         singUpViewModel = SingUpViewModel()
    }
    
    private func setupBindings() {
        // Directly read initial state
        hasInternetConnection = networkMonitor.isConnected
        
        // Start observing for changes
        networkMonitor.monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
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
