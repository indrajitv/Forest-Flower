//
//  CategoryGrid.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 25/06/23.
//

import SwiftUI

enum SearchCategory: CaseIterable {

    case wallpaper
    case rendering
    case nature
    case texture
    case arch
    case animal
    case food
    case art

    func getTitle() -> String {

        switch self {
            case .wallpaper:
                return "Wallpaper"
            case .rendering:
                return "3D Renders"
            case .nature:
                return "Nature"
            case .texture:
                return "Textures & Patterns"
            case .arch:
                return "Architecture & Interiors"
            case .animal:
                return "Animals"
            case .food:
                return "Food & Drink"
            case .art:
                return "Arts & Culture"
        }
    }

    func getThumb() -> Image {

        switch self {
            case .wallpaper:
                return Image("wallpaper")
            case .rendering:
                return Image("rendering")
            case .nature:
                return Image("nature")
            case .texture:
                return Image("texture")
            case .arch:
                return Image("architecture")
            case .animal:
                return Image("animals")
            case .food:
                return Image("food")
            case .art:
                return Image("art")
        }
    }
}

struct CategoryGrid: View {

    var onSelection: ((_ category: SearchCategory) -> ())

    var body: some View {
        ScrollView {
            LazyVGrid(columns: [.init(spacing: 8)], spacing: 4) {
                ForEach(SearchCategory.allCases, id: \.self) { category in
                    ZStack {
                        category.getThumb()
                            .resizable()
                            .scaledToFill()

                        Text(category.getTitle())
                            .shadow(color: .black, radius: 10, x: 1, y: 1)
                            .setFont(style: .header, weight: .heavy)
                            .padding()
                    }
                    .foregroundColor(.white)
                    .onTapGesture {
                        self.onSelection(category)
                    }
                }
            }
            .frame(width: UIScreen.main.bounds.width)
            .frame(maxHeight: .infinity)
        }
    }
}

struct CategoryGrid_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultView()
    }
}
