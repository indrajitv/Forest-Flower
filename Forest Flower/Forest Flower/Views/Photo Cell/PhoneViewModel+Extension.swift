//
//  PhoneViewModel+Extension.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 18/06/23.
//

import SwiftUI

extension PhotoViewModel {
    var backgroundColor: Color {
        if let color = self.photo.color {
            return Color.init(hex: color)
        } else {
            return .primary
        }
    }

    var blurImage: Image? {
        if let hash = self.photo.blur_hash,
           let blurImage = UIImage(blurHash: hash, size: .init(width: 50, height: 50)) {

            return Image(uiImage: blurImage)
        } else {
            return nil
        }
    }
    
    var remove: String { "Remove" }

    var uploaderTitle: String { "About " + self.photo.user.name.capitalized }

    var uploaderName: String { self.photo.user.name.capitalized }

    var photoDescription: String? { self.photo.description }

    var altPhotoDescription: String? { self.photo.alt_description }

    var userLocation: String { self.photo.user.location ?? "Near heart" }

    var profileImage: URL? { self.photo.user.profile_image?.large }

    var bio: String? { self.photo.user.bio?.trimmingCharacters(in: .whitespacesAndNewlines) }

    var instagram: URL? { URL(string: "https://instagram.com/" + (self.photo.user.social?.insta ?? "")) }

    var twitter: URL? { URL(string: "https://twitter.com/" + (self.photo.user.social?.twitter ?? "")) }

    var originalPhotoURL: URL { self.photo.urls.full }

    var smallPhotoURL: URL { self.photo.urls.small }

    var downloadedDateString: String? {
        if let date = self.cachedOn {
            let cal = Calendar.current
            if cal.isDateInToday(date) {
                return "Downloaded today"
            } else if cal.isDateInYesterday(date) {
                return "Downloaded yesterday"
            } else {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                return formatter.string(from: date)
            }
        }
        return nil
    }
}
