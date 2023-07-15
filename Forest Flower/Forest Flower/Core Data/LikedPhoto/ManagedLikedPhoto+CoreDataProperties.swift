//
//  ManagedLikedPhoto+CoreDataProperties.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 02/07/23.
//
//

import Foundation
import CoreData


extension ManagedLikedPhoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedLikedPhoto> {
        return NSFetchRequest<ManagedLikedPhoto>(entityName: "ManagedLikedPhoto")
    }

    @NSManaged public var model: Data
    @NSManaged public var isLiked: Bool
    @NSManaged public var id: UUID?
    @NSManaged public var url: String?
    @NSManaged public var timeStamp: Date?
}

extension ManagedLikedPhoto : Identifiable {

    class func addPhoto(photoViewModel: PhotoViewModel) throws {
        let photo = ManagedLikedPhoto(context: CoreDataManager.shared.context)
        photo.url = photoViewModel.originalPhotoURL.absoluteString
        photo.timeStamp = Date()
        photo.id = UUID()
        photo.model = try JSONEncoder().encode(photoViewModel.photo)

        CoreDataManager.shared.persistentContainer.viewContext.insert(photo)
        try CoreDataManager.shared.save()
    }

    class func deletePhoto(url: URL) throws {
        let fetchRequest = ManagedLikedPhoto.fetchRequest()
        fetchRequest.predicate = .init(format: "url LIKE %@", url.absoluteString)
        if let result = try? CoreDataManager.shared.context.fetch(fetchRequest) {
            result.forEach { CoreDataManager.shared.context.delete($0) }
        }
        try CoreDataManager.shared.save()
    }

    class func getPhotos() throws ->  [PhotoViewModel] {
        let result = try CoreDataManager.shared.context.fetch(ManagedLikedPhoto.fetchRequest())
        return try result.compactMap {
            let photoModel = try JSONDecoder().decode(APIPhoto.self, from: $0.model)
            let viewModel = PhotoViewModel(photo: photoModel)
            viewModel.cachedOn = $0.timeStamp
            viewModel.isLiked = true
            return viewModel
        }
    }

    class func isPhotoAlreadySaved(for url: URL) -> Bool {
        let fetchRequest = ManagedLikedPhoto.fetchRequest()
        fetchRequest.predicate = .init(format: "url LIKE %@", url.absoluteString)
        if let result = try? CoreDataManager.shared.context.fetch(fetchRequest) {
            return !result.isEmpty
        }
        return false
    }
}
