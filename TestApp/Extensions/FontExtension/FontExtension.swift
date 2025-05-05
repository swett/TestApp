//
//  FontExtension.swift
//  TestApp
//
//  Created by Mykyta Kurochka on 28.04.2025.
//

import Foundation
import SwiftUI

extension Font {

    enum NunitoSans: String {
        case regular = "NunitoSans-Regular"
        case semibold = "NunitoSans-SemiBold"
    }

    static func nunitoSans(_ type: NunitoSans = .regular, size: CGFloat) -> Font {
        .custom(type.rawValue, size: size)
    }

    enum FontStyle {
        case header1    // 20
        case body1      // 16
        case body2      // 18
        case body3      // 14
        case body4      // 12
        case button1    // 18 semibold
        case button2    // 16 semibold
    }

    static func style(_ type: FontStyle) -> Font {
        switch type {
        case .header1:
            return nunitoSans(size: 20)
        case .body1:
            return nunitoSans(size: 16)
        case .body2:
            return nunitoSans(size: 18)
        case .body3:
            return nunitoSans(size: 14)
        case .body4:
            return nunitoSans(size: 12)
        case .button1:
            return nunitoSans(.semibold, size: 18)
        case .button2:
            return nunitoSans(.semibold, size: 16)
        }
    }
}
