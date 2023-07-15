//
//  PhotoDetailsHeaderView.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 16/06/23.
//

import SwiftUI

struct PhotoDetailsHeaderView: View {

    @Environment(\.dismiss)
    private var dismiss

    @ObservedObject
    private(set) var viewModel: PhotoViewModel

    var closeButton: some View {
        Button {
            dismiss()
        } label: {
            SystemImage.close
                .foregroundColor(.white)
                .setFont(style: .header)
        }
        .shadow(color: .black, radius: 5, x: 1, y: 1)
    }

    var userName: some View {
        Text(self.viewModel.uploaderName)
            .foregroundColor(.white)
            .setFont(style: .title)
            .shadow(color: .black, radius: 5, x: 1, y: 1)
    }

    var body: some View {
        HStack() {
            self.closeButton
                .frame(width: 45, height: 45)
            Spacer()
            userName
            Spacer()
            PhotoDetailsRightSideNavigationButton(viewModel: self.viewModel)
                .frame(width: 45, height: 45)
        }
        .frame(height: 50)
        .padding([.trailing, .leading], 5)
        .onAppear {
            self.viewModel.isPhotoAlreadyDownloadedMakeProgressFull()
        }
    }
}

struct PhotoDetailsRightSideNavigationButton: View {

    @ObservedObject
    var viewModel: PhotoViewModel

    var body: some View {
        ZStack {

            let isDownloading: Bool = self.viewModel.downloadProgress > 0

            Button {
                Task {
                    if let downloadedData = await self.viewModel.downloadImage() {
                        try? self.viewModel.addInDownloads()
                        if let image = UIImage(data: downloadedData) {
                            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        }
                    }
                }
            } label: {
                let downloadingOrError: Image = (self.viewModel.downloadProgress == -1 ? SystemImage.triangle : SystemImage.download)
                let image: Image = self.viewModel.downloadProgress == -2 ? SystemImage.checkMark : downloadingOrError
                image
                    .foregroundColor(.white)
                    .setFont(style: isDownloading ? .body : .header)
            }
            .buttonStyle(.plain)
            .disabled(self.viewModel.downloadProgress != 0)
            .shadow(color: .black, radius: 5, x: 1, y: 1)

            if isDownloading {
                CircularProgress(progress: self.$viewModel.downloadProgress,
                                 foregroundThickness: 2,
                                 backgroundThickness: 3,
                                 colors: (background: [.gray], progress: [.blue]))
                .padding(5)
            }
        }
    }
}
