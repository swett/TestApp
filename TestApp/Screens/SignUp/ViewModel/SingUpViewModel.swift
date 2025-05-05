//
//  SingUpViewModel.swift
//  TestApp
//
//  Created by Mykyta Kurochka on 02.05.2025.
//

import Foundation
import UIKit

class SingUpViewModel: ObservableObject {
    @Published var phoneNumber: String = ""
    @Published var isValidPhoneNumber: Bool = false
    @Published var showPhoneNumberError: Bool = false
    @Published var errorMessagePhoneNumber: String = ""
    
    @Published var email: String = ""
    @Published var isValidEmail: Bool = false
    @Published var showEmailError: Bool = false
    @Published var errorMessageEmail: String = ""
    
    @Published var name: String = ""
    @Published var isValidName: Bool = false
    @Published var showNameError: Bool = false
    @Published var errorMessageName: String = ""
    
    @Published var token: String = ""
    
    
    @Published var positionsArray: [PositionModel] = []
    @Published var showPhotoError: Bool = false
    @Published var errorMessagePhoto: String = ""
    @Published var pendingImage: UIImage?
    @Published var selectedPosition: PositionModel?
    
    @Published var userResponse: CreateUserResponse?
    
    @Published var isAllInputed: Bool = false
    
    
    @Published var showFinishView: Bool = false
    
    var networkManager: NetworkManager
    
    init(networkManager: NetworkManager = NetworkManager.shared) {
        self.networkManager = networkManager
        self.getPositions()
    }
}


extension SingUpViewModel {
    func getPositions() {
        networkManager.fetchPositions { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let positions):
                    self?.positionsArray = positions
                case .failure(let error):
                    print("Failed to fetch positions:", error)
                }
            }
        }
    }
    
    func getToken() {
        networkManager.fetchToken { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let success):
                    self?.token = success
                case .failure(let failure):
                    print("Failed to fetch token:", failure)
                }
            }
        }
    }
    
    func createUser() {
        guard let image = pendingImage,
              let photoData = image.jpegData(compressionQuality: 0.8),
              let position = selectedPosition else {
            print("Missing image or position")
            return
        }
        let cleanNumber = phoneNumber.replacingOccurrences(of: " ", with: "")
        networkManager.createUser(name: name, email: email.lowercased(), phone: cleanNumber, positionId: 1, photo: photoData, token: token) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let response):
                    self?.userResponse = response
                    if response.success {
                        print("User created with ID: \(response.user_id ?? -1)")
                    } else {
                        if let errors = response.fails {
                            for (field, messages) in errors {
                                print("Validation error for \(field): \(messages.joined(separator: ", "))")
                                switch field {
                                case "phone": 
                                    self?.showPhotoError = true
                                    self?.errorMessagePhoneNumber = "\(messages)"
                                case "name":
                                    self?.showNameError = true
                                    self?.errorMessageName = "\(messages)"
                                case "email":
                                    self?.showEmailError = true
                                    self?.errorMessageEmail = "\(messages)"
                                case "photo":
                                    self?.showPhotoError = true
                                    self?.errorMessagePhoto = "\(messages)"
                                default: break
                                }
                            }
                        } else {
                            print("Failed to create user: \(response.message)")
                        }
                    }
                    self?.showFinishView = true
                case .failure(let failure):
                    print("Failed to fetch token:", failure)
                    
                }
            }
        }
    }
}


extension SingUpViewModel {
    
    
    func validatePhoneNumber(_ number: String) {
        // Strip all non-numeric characters
        let digitsOnly = number.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        
        // Expect format: +380 XX XXX XX XX → so digitsOnly should be 12 digits starting with "380"
        guard digitsOnly.hasPrefix("380"), digitsOnly.count == 12 else {
            isValidPhoneNumber = false
            showPhoneNumberError = true
            checkIsValid()
            return
        }
        
        // Extract operator code from digits after "380"
        let operatorCode = digitsOnly.dropFirst(3).prefix(2) // e.g., "99"
        
        let validOperatorCodes: Set<String> = [
            "50", "63", "66", "67", "68", "73", "89", "91", "92", "93",
            "94", "95", "96", "97", "98", "99"
        ]
        
        let isValidOperator = validOperatorCodes.contains(String(operatorCode))
        
        isValidPhoneNumber = isValidOperator
        showPhoneNumberError = !isValidPhoneNumber
        checkIsValid()
    }
    
    
    
    func isValidEmail(email: String) {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        isValidEmail =  emailPred.evaluate(with: email)
        showEmailError = !isValidEmail
        checkIsValid()
    }
    
    func validateName(_ name: String) {
        isValidName = name.count >= 2
        showNameError = !isValidName // Show error if invalid
        checkIsValid()
    }
    
    func checkIsValid() {
        isAllInputed = isValidPhoneNumber && isValidName && isValidEmail && selectedPosition != nil && pendingImage != nil
    }
}
