//
//  ColorExtension.swift
//  TestApp
//
//  Created by Mykyta Kurochka on 28.04.2025.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        var cleanHexCode = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        cleanHexCode = cleanHexCode.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        
        Scanner(string: cleanHexCode).scanHexInt64(&rgb)
        
        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue)
    }
}

extension Color {
    static let theme = ColorTheme()
}


struct ColorTheme {
    let colorF4E041 = Color(hex: "#F4E041")
    let color00BDD3 = Color(hex: "#00BDD3")
    let colorFFFFFF = Color(hex: "#FFFFFF")
    let colorD0CFCF = Color(hex: "#D0CFCF")
    let color000000 = Color(hex: "#000000")
    let colorCB3D40 = Color(hex: "#CB3D40")
    let color009BBD = Color(hex: "#009BBD")
    let colorDEDEDE = Color(hex: "#DEDEDE")
    let colorF8F8F8 = Color(hex: "#F8F8F8")
}
