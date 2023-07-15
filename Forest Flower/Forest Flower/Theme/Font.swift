//
//  Font.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 14/06/23.
//

import SwiftUI

struct FontSyle: ViewModifier {
    let fontSyle: FontSyleType
    let weight: Font.Weight


    func body(content: Content) -> some View {
        content.font(fontSyle.font(weight: weight))
    }
}

extension View {
    func setFont(style: FontSyleType, weight: Font.Weight = .regular) -> some View {
        modifier(FontSyle(fontSyle: style, weight: weight))
    }
}

enum FontSyleType: CGFloat {
    case headerLarge = 25.0
    case header = 20.0
    case title = 18.0
    case subTitle = 16.0
    case body = 14.0
    case small = 12.0
    case extraSmall = 10.0

    func font(weight: Font.Weight = .regular) -> Font {
        .system(size: self.rawValue, weight: weight)
    }
}
