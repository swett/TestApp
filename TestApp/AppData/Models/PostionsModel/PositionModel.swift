//
//  PositionModel.swift
//  TestApp
//
//  Created by Mykyta Kurochka on 28.04.2025.
//


struct PositionModel: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let name: String
}

struct PositionResponse: Codable {
    let success: Bool
    let positions: [PositionModel]
}
