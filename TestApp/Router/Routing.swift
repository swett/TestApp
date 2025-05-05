//
//  Routing.swift
//  TestApp
//
//  Created by Mykyta Kurochka on 28.04.2025.
//

import Foundation
import SwiftUI

final class Router: ObservableObject {
    @Published var path: [Destination] = []
    @Published var root: RootView = .launch
    @Published var onboardingCompleted = false  // Track if onboarding is completed
    enum RootView: Hashable, Equatable {
        case launch, main // root views
    }
    
    enum Destination: Hashable {
        case networkError
    }
    
    
    func showLaunchScreen() {
        root = .launch
        
    }
    func showMain() {
        root = .main
        path.removeAll()
    }
    
    func showErrorScreen() {
        path.append(.networkError)
    }
    
    func popToRoot() {
        root = .main
        path.removeAll()
    }
}
