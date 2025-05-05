//
//  CreateUserResponse.swift
//  TestApp
//
//  Created by Mykyta Kurochka on 28.04.2025.
//


struct CreateUserResponse: Codable {
    let success: Bool
    let user_id: Int?
    let message: String
    let fails: [String: [String]]?
}
