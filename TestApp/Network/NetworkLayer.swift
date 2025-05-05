//
//  NetworkLayer.swift
//  TestApp
//
//  Created by Mykyta Kurochka on 28.04.2025.
//

import Foundation
import SwiftUI

final class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = "https://frontend-test-assignment-api.abz.agency/api/v1"
    
    private init() {}
    
    // MARK: - Get Token
    func fetchToken(completion: @escaping (Result<String, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/token") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }

            do {
                let decoded = try JSONDecoder().decode(TokenResponse.self, from: data)
                completion(.success(decoded.token))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    // MARK: - Fetch Positions
    func fetchPositions(completion: @escaping (Result<[PositionModel], Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/positions") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            
            do {
                let decoded = try JSONDecoder().decode(PositionResponse.self, from: data)
                completion(.success(decoded.positions))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }

    // MARK: - Create User
    func createUser(name: String, email: String, phone: String, positionId: Int, photo: Data, token: String, completion: @escaping (Result<CreateUserResponse, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/users") else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        request.setValue("\(token)", forHTTPHeaderField: "Token")
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let body = createMultipartBody(name: name, email: email, phone: phone, positionId: positionId, photo: photo, boundary: boundary)
        
        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }

            do {
                let decoded = try JSONDecoder().decode(CreateUserResponse.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // MARK: - Create Multipart Form Data
    private func createMultipartBody(name: String, email: String, phone: String, positionId: Int, photo: Data, boundary: String) -> Data {
        var body = Data()
        let boundaryPrefix = "--\(boundary)\r\n"
        
        body.append(Data(boundaryPrefix.utf8))
        body.append(Data("Content-Disposition: form-data; name=\"name\"\r\n\r\n".utf8))
        body.append(Data("\(name)\r\n".utf8))
        
        body.append(Data(boundaryPrefix.utf8))
        body.append(Data("Content-Disposition: form-data; name=\"email\"\r\n\r\n".utf8))
        body.append(Data("\(email)\r\n".utf8))
        
        body.append(Data(boundaryPrefix.utf8))
        body.append(Data("Content-Disposition: form-data; name=\"phone\"\r\n\r\n".utf8))
        body.append(Data("\(phone)\r\n".utf8))
        
        body.append(Data(boundaryPrefix.utf8))
        body.append(Data("Content-Disposition: form-data; name=\"position_id\"\r\n\r\n".utf8))
        body.append(Data("\(positionId)\r\n".utf8))
        
        body.append(Data(boundaryPrefix.utf8))
        body.append(Data("Content-Disposition: form-data; name=\"photo\"; filename=\"photo.jpg\"\r\n".utf8))
        body.append(Data("Content-Type: image/jpeg\r\n\r\n".utf8))
        body.append(photo)
        body.append(Data("\r\n".utf8))
        
        body.append(Data("--\(boundary)--\r\n".utf8))
        
        return body
    }
    
    
    func fetchUsers(page: Int, count: Int = 6) async throws -> UserResponse {
           guard let url = URL(string: "\(baseURL)/users?page=\(page)&count=\(count)") else {
               throw URLError(.badURL)
           }
           
           let (data, response) = try await URLSession.shared.data(from: url)
           
           guard let httpResponse = response as? HTTPURLResponse,
                 (200...299).contains(httpResponse.statusCode) else {
               throw URLError(.badServerResponse)
           }
           
           let decoder = JSONDecoder()
           return try decoder.decode(UserResponse.self, from: data)
       }
}
