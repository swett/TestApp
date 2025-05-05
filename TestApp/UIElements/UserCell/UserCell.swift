//
//  UserCell.swift
//  TestApp
//
//  Created by Mykyta Kurochka on 28.04.2025.
//

import SwiftUI
import SDWebImageSwiftUI

struct UserCell: View {
    var model: User
    var body: some View {
        HStack {
            WebImage(url: URL(string: model.photo))
                .resizable()
                .frame(width: 50, height: 50)
                .cornerRadius(100)
            VStack(alignment: .leading) {
                Text(model.name)
                    .font(.style(.body2))
                    .foregroundStyle(Color.theme.color000000.opacity(0.87))
                Text(model.position)
                    .font(.style(.body3))
                    .foregroundStyle(Color.theme.color000000.opacity(0.6))
                Text(model.email)
                    .font(.style(.body3))
                    .foregroundStyle(Color.theme.color000000.opacity(0.87))
                Text(formatPhoneNumber(model.phone))
                    .font(.style(.body3))
                    .foregroundStyle(Color.theme.color000000.opacity(0.87))
            }
            Spacer()
        }
    }
    
    private func formatPhoneNumber(_ number: String) -> String {
        // Remove non-numeric characters
        let digits = number.filter { $0.isNumber }

        guard digits.count == 12 else {
            return number // Return as-is if unexpected format
        }

        let countryCode = "+\(digits.prefix(2))"         // +38
        let cityCode = String(digits[2..<5])             // 049
        let part1 = String(digits[5..<8])                // 654
        let part2 = String(digits[8..<10])               // 00
        let part3 = String(digits[10..<12])              // 23

        return "\(countryCode) (\(cityCode)) \(part1) \(part2) \(part3)"
    }
}

#Preview {
    UserCell(model: User(id: 30, name: "Angel", email: "angel.williams@example.com", phone: "+380496540023", position: "Designer", positionId: 4, registrationTimestamp: 1537777441, photo: "https://frontend-test-assignment-api.abz.agency/images/users/5b977ba13fb3330.jpeg"))
}


extension String {
    subscript (bounds: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start..<end]
    }

    subscript (bounds: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return self[start...end]
    }
}
