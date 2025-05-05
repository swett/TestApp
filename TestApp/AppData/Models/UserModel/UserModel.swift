//
//  UserModel.swift
//  TestApp
//
//  Created by Mykyta Kurochka on 28.04.2025.
//


struct UserResponse: Decodable {
    let success: Bool
    let totalPages: Int
    let totalUsers: Int
    let count: Int
    let page: Int
    let links: Links
    let users: [User]
    
    enum CodingKeys: String, CodingKey {
        case success
        case totalPages = "total_pages"  // Mapping "total_pages" to totalPages
        case totalUsers = "total_users" // Mapping "total_users" to totalUsers
        case count
        case page
        case links
        case users
    }
}

struct Links: Codable {
    let nextUrl: String?
    let prevUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case nextUrl = "next_url"
        case prevUrl = "prev_url"
    }
}

struct User: Codable, Identifiable, Equatable {
    let id: Int
    let name: String
    let email: String
    let phone: String
    let position: String
    let positionId: Int
    let registrationTimestamp: Int
    let photo: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, email, phone, position
        case positionId = "position_id"
        case registrationTimestamp = "registration_timestamp"
        case photo
    }
}
