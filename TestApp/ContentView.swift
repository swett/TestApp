//
//  ContentView.swift
//  TestApp
//
//  Created by Mykyta Kurochka on 28.04.2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var coordinator = Router()
    @StateObject private var mainViewModel: TabViewModel
    
    // Initialize `mainViewModel` separately to avoid capturing `self`
    init() {
        let router = Router() // Temporary instance
        _coordinator = StateObject(wrappedValue: router)
        _mainViewModel = StateObject(wrappedValue: TabViewModel(coordinator: router))
    }
    var body: some View {
        Group {
            switch coordinator.root {
            case .launch:
                NavigationStack(path: $coordinator.path) {
                    PreloaderView(viewModel: PreloaderViewModel(coordinator: coordinator))
                        .navigationDestination(for: Router.Destination.self) { destination in
                            destinationView(for: destination)
                        }
                        .navigationBarBackButtonHidden()
                }
            case .main:
                NavigationStack(path: $coordinator.path) {
                    TabBarView(viewModel: mainViewModel)
                        .navigationDestination(for: Router.Destination.self) { destination in
                            destinationView(for: destination)
                        }
                        .navigationBarBackButtonHidden()
                }
            }
        }
    }
    
    @ViewBuilder
       private func destinationView(for destination: Router.Destination) -> some View {
           switch destination {
           case .networkError:
               EthernetErrorView(viewModel: EthernetErrorViewModel(coordinator: coordinator))
                   .navigationBarBackButtonHidden()
           }
       }
}

#Preview {
    ContentView()
}
