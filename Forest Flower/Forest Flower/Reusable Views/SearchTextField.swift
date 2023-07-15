//
//  SearchTextField.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 24/06/23.
//

import SwiftUI
import Combine

struct SearchTextField: View {

    @Binding
    var searchText: String

    var placeholder: String
    let height: CGFloat = 50

    var searchTextField: some View {
        TextField("", text: $searchText)
    }

    var closeButton: some View {
        Button {
            self.searchText = ""
        } label: {
            SystemImage.close
        }
        .frame(width: height, height: height)
    }

    var clearSearchButton: some View {
        Text(placeholder)
            .foregroundColor(.white.opacity(0.7))
            .allowsHitTesting(false)
            .autocorrectionDisabled(true)
    }

    var body: some View {
        HStack {
            Spacer()
            SystemImage.search

            ZStack(alignment: .leading) {
                searchTextField

                if searchText.isEmpty {
                    clearSearchButton
                }
            }

            if !searchText.isEmpty {
                closeButton
            }
        }
        .frame(height: height)
        .background(.white.opacity(0.3))
        .cornerRadius(12)
        .foregroundColor(.white)
        .padding([.leading, .trailing], 8)
        .setFont(style: .subTitle, weight: .regular)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultView.init()
    }
}

