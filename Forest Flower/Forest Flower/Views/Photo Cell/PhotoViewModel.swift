//
//  PhotoCallViewModel.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 12/06/23.
//

import SwiftUI

final class PhotoViewModel: Identifiable, ObservableObject {

    @Published
    var downloadProgress: CGFloat = 0

    @Published
    var isLiked: Bool!

    let id = UUID()

    let photo: APIPhoto

    var smallImageCache: Data?

    var cachedOn: Date?

    private lazy var downloadSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration, delegate: nil, delegateQueue: .main)
    }()

    init(photo: APIPhoto) {
        self.photo = photo

        self.isLiked = self.isPhotoLiked()
        assert(self.isLiked != nil)
    }

    @MainActor
    func downloadImage() async -> Data? {
        self.downloadProgress = 0.0001 // To show downloading started.

        let downloader = Downloader(url: self.originalPhotoURL, downloadSession: self.downloadSession)

        for await event in downloader.events {
            switch event {
                case .progress(let currentBytes, let totalBytes):
                    self.downloadProgress = Double(currentBytes) / Double(totalBytes)
                case .success(let data):
                    // Delay allow us to show animation being completed gracefully.
                    _ = Task.delayed(byTimeInterval: 2, operation: {
                        DispatchQueue.main.async { self.downloadProgress = -2 }
                    })
                    //Animation delay will not impact saving the image.
                    return data
                case .failed:
                    self.downloadProgress = -1
            }
        }
        return nil
    }

    func getImageAspectRation(width: CGFloat) -> CGSize {
        return .init(width: width,
                     height: (CGFloat(self.photo.height) / CGFloat(self.photo.width)) * width)
    }

    func addInDownloads() throws {
        try? ManagedSavedPhoto.addPhoto(photoViewModel: self)
    }
    
    func isPhotoAlreadySaved() -> Bool {
        ManagedSavedPhoto.isPhotoAlreadySaved(for: self.originalPhotoURL)
    }

    func removeFromDownloadedList() throws {
        try ManagedSavedPhoto.deletePhoto(url: self.originalPhotoURL)
    }

    func isPhotoLiked() -> Bool {
        ManagedLikedPhoto.isPhotoAlreadySaved(for: self.originalPhotoURL)
    }

    func addAsLikedPhoto() throws {
        if !self.isPhotoLiked() {
            try ManagedLikedPhoto.addPhoto(photoViewModel: self)
        }
    }

    func removeFromLikedPhoto() throws {
        try ManagedLikedPhoto.deletePhoto(url: self.originalPhotoURL)
    }

    func isPhotoAlreadyDownloadedMakeProgressFull() {
        if isPhotoAlreadySaved() {
            // -2 indicates already downloaded or download finished.
            self.downloadProgress = -2
        }
    }

    func didTapHeart() {
        self.isLiked.toggle()

        if self.isLiked {
            try? self.addAsLikedPhoto()
        } else {
            try? self.removeFromLikedPhoto()
        }
    }
    
    enum DownloadingImageStatus {
        case data(Data)
        case progress(Double)
        case error(Error)
    }
}
