//
//  ErrorHoarding.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 12/06/23.
//

import SwiftUI

struct ErrorHoarding: View {

    let systemImage: Image?
    let title: String?
    let subTitle: String?
    let retryButtonTitle: String?

    var onRetry: (() -> ())?

    var body: some View {

        ZStack {
            Image.init("Launch")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
                .background(
                    LinearGradient(gradient: Gradient(colors: [.white, .black]), startPoint: .top, endPoint: .bottom)
                )

            VStack {
                Spacer()
                Text("A rebellious forest flower")
                    .padding(.bottom)
                    .setFont(style: .small)
                    .padding(.bottom, 120)
                    .shadow(color: .white, radius: 1, x: 1, y: 1)
            }

            VStack(spacing: 7) {
                if let image = systemImage {
                    image
                        .setFont(style: .header)
                }

                if let title = title {
                    Text(title)
                        .setFont(style: .subTitle)
                }

                if let subTitle = subTitle {
                    Text(subTitle)
                        .setFont(style: .body)
                }

                if let retryButtonTitle = retryButtonTitle {
                    Button(retryButtonTitle) {
                        onRetry?()
                    }
                    .tint(.primary)
                    .setFont(style: .title)
                    .padding(.top, 10)
                }
            }
        }
        .foregroundColor(.white)
    }
}
