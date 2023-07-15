//
//  Color+Extensions.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 11/06/23.
//

import SwiftUI

extension Color {

    static var random: Color {
        return Color(red: .random(in: 0...1),
                     green: .random(in: 0...1),
                     blue: .random(in: 0...1))
    }

    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
            case 3: // RGB (12-bit)
                (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: // ARGB (32-bit)
                (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct LinearGradientBG: ViewModifier {
    let ignoresSafeArea: Bool
    let gradient = LinearGradient(colors: [.red, .white, .indigo], startPoint: .bottom, endPoint: .top)

    func body(content: Content) -> some View {
        content
            .background {
                if ignoresSafeArea {
                    gradient
                        .ignoresSafeArea()
                } else {
                    gradient
                }
            }
    }
}

extension View {
    func setLinearBG(ignoresSafeArea: Bool = true) -> some View {
        modifier(LinearGradientBG(ignoresSafeArea: ignoresSafeArea))
    }
}
