//
//  UsersViewModel.swift
//  TestApp
//
//  Created by Mykyta Kurochka on 28.04.2025.
//

import Foundation
@MainActor
class UsersViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var hasMorePages = true
    private var currentPage = 1
    
    func loadUsers() async {
        guard !isLoading, hasMorePages else { return }
        
        isLoading = true
        do {
            // Fetch users from the network
            let response = try await NetworkManager.shared.fetchUsers(page: currentPage, count: 6)
            
            // Decode the response into the UserResponse model
          
            
            // Append the users fetched
            users.append(contentsOf: response.users)
            
            // Check if there are more pages to load
            if currentPage >= response.totalPages {
                hasMorePages = false
            } else {
                currentPage += 1
            }
        } catch {
            // Handle any errors (e.g., network issues, 404, etc.)
            print("Failed to load users:", error)
            hasMorePages = false
        }
        isLoading = false
    }
       func refresh() async {
           currentPage = 1
           hasMorePages = true
           users = []
           await loadUsers()
       }
}
