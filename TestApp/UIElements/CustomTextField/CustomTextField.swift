//
//  CustomTextField.swift
//  TestApp
//
//  Created by Mykyta Kurochka on 28.04.2025.
//

import Foundation
import SwiftUI

struct CustomTextField: View {
    @Binding var text: String
    @Binding var errorMessage: String
    @Binding var showError: Bool
    var focusedField: FocusState<Field?>.Binding
    var fieldType: Field
    var placeholder: String
    var keyboardType: UIKeyboardType = .default
    var validate: ((String) -> Bool)? = nil
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            fieldContainer
            errorText
        }
        .onChange(of: text) { _ in
            validateInput()
        }
    }
    
    // Extract the label
    private var fieldLabel: some View {
        HStack {
            Text(fieldType.rawValue)
                .font(.style(.body4))
                .foregroundStyle(isError ? Color.theme.colorCB3D40 : Color.theme.color000000.opacity(0.48))
            Spacer()
        }
    }
    
    // Extract the text field container
    private var fieldContainer: some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(isError ? Color.theme.colorCB3D40.opacity(0.1) :  Color.theme.colorD0CFCF, lineWidth: 1)
            .frame(height: 56)
            .overlay {
                VStack(spacing: 5) {
                    if !text.isEmpty {
                        fieldLabel
                    }
                    textField
                }
                .padding(.horizontal, 16)
            }
    }
    
  
    
    // Extract the text field
    private var textField: some View {
        TextField("", text: $text, onEditingChanged: { isEditing in
            if isEditing {
                showError = false
            } else {
                validateInput()
            }
        })
        .keyboardType(keyboardType)
        .focused(focusedField, equals: fieldType)
        .foregroundColor(Color.theme.color000000)
        .font(.style(.body1))
        .multilineTextAlignment(.leading)
        .onTapGesture {
            focusedField.wrappedValue = fieldType
        }
        .onChange(of: text) { newValue in
            formatInput()
        }
        .placeholder(when: text.isEmpty) {
            HStack {
                Text(placeholder)
                    .font(.style(.body1))
                    .foregroundStyle(Color.theme.color000000.opacity(0.48))
            }
        }
    }
    
    
    
    // Extract the error message
    private var errorText: some View {
        Group {
            if showError && isError {
                Text(errorMessage)
                    .font(.style(.body4))
                    .foregroundColor(Color.theme.colorCB3D40)
            } else {
                if fieldType == .phone {
                    Text("+38 (XXX) XXX - XX - XX")
                        .font(.style(.body4))
                        .foregroundStyle(Color.theme.color000000.opacity(0.6))
                }
            }
        }
    }
    
    private var isError: Bool {
        !errorMessage.isEmpty
    }
    
    private var isFocused: Bool {
        focusedField.wrappedValue == fieldType
    }
    
    private func validateInput() {
        if let validate = validate {
            let isValid = validate(text)
            switch fieldType {
            case .phone:
                errorMessage = isValid ? "" : "Required field"
            case .name:
                errorMessage = isValid ? "" : "Required field"
            case .email:
                errorMessage = isValid ? "" : "Invalid email format"
            }
           
            if !isFocused {
                showError = !isValid
            }
        }
    }
    
    private func formatInput() {
        switch fieldType {
        case .phone:
            formatPhoneNumber()
        default: break
        }
    }
    
    private func formatPhoneNumber() {
        // Remove all non-numeric characters
        var rawValue = text.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)

        // If text already starts with +380, remove it from processing
        if rawValue.hasPrefix("380") {
            rawValue = String(rawValue.dropFirst(3))
        }

        // Limit to 9 digits max (Ukrainian number excluding +380)
        if rawValue.count > 9 {
            rawValue = String(rawValue.prefix(9))
        }

        // Split into parts
        let firstPart = rawValue.prefix(2) // operator code
        let secondPart = rawValue.dropFirst(2).prefix(3)
        let thirdPart = rawValue.dropFirst(5).prefix(2)
        let fourthPart = rawValue.dropFirst(7)

        // Combine with +380 prefix
        text = "+380 \(firstPart) \(secondPart) \(thirdPart) \(fourthPart)"
            .trimmingCharacters(in: .whitespaces)
    }

    private func formatAmount() {
        let rawValue = text.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        text = rawValue.isEmpty ? "" : rawValue
    }

}



extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            if shouldShow {
                placeholder()
            }
            self
        }
    }
}


enum Field: String, CaseIterable {
    case phone = "Phone"
    case name = "Your name"
    case email = "Email"
}
