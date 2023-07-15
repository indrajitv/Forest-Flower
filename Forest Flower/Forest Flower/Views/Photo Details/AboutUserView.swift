//
//  AboutUserView.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 16/06/23.
//

import SwiftUI

struct AboutUserView: View {

    let viewModel: PhotoViewModel

    var userAvatarAndName: some View {
        HStack() {
            self.viewModel.profileImage.flatMap {
                Rectangle()
                    .fill(.clear)
                    .background(
                        AsyncImage(url: $0)
                            .scaledToFill()
                    )
                    .frame(width: 20, height: 20)
                    .border(.primary, width: 0.4)
                    .cornerRadius(8)
            }
            Text(self.viewModel.uploaderTitle)
                .setFont(style: .small)
        }
    }

    var instagramButton: some View {
        Button {
            let application = UIApplication.shared
            if let url = self.viewModel.instagram {
                application.open(url)
            }
        } label: {
            RoundedRectangle(cornerSize: .init(width: 3, height: 3))
                .fill(.clear)
                .frame(width: 45, height: 45)
                .overlay {

                    let uiImage = #imageLiteral(resourceName: "instagram")
                    Image(uiImage: uiImage)
                        .resizable()
                        .cornerRadius(3)
                        .scaledToFill()
                }
        }
    }

    var twitterButton: some View {
        Button {
            let application = UIApplication.shared
            if let url = self.viewModel.twitter {
                application.open(url)
            }
        } label: {
            RoundedRectangle(cornerSize: .init(width: 3, height: 3))
                .fill(.clear)
                .frame(width: 40, height: 40)
                .overlay {
                    let uiImage = #imageLiteral(resourceName: "twitter")
                    Image(uiImage: uiImage)
                        .resizable()
                        .cornerRadius(8)
                        .scaledToFill()
                }
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            self.userAvatarAndName

            self.viewModel.bio.flatMap {
                Text($0)
                    .setFont(style: .small)
            }

            HStack() {
                self.instagramButton
                self.twitterButton
            }
            .padding(.leading, -3)
        }
    }
}
