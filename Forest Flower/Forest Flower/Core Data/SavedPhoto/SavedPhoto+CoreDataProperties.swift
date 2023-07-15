//
//  ManagedSavedPhoto+CoreDataProperties.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 17/06/23.
//
//

import CoreData

extension ManagedSavedPhoto {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ManagedSavedPhoto> {
        return NSFetchRequest<ManagedSavedPhoto>(entityName: "ManagedSavedPhoto")
    }

    @NSManaged public var id: UUID
    @NSManaged public var image: Data
    @NSManaged public var model: Data
    @NSManaged public var timeStamp: Date
    @NSManaged public var url: String
}

extension ManagedSavedPhoto : Identifiable { }

extension ManagedSavedPhoto {

    class func addPhoto(photoViewModel: PhotoViewModel) throws {
        if let photoData = photoViewModel.smallImageCache {
            let photo = ManagedSavedPhoto(context: CoreDataManager.shared.context)
            photo.url = photoViewModel.originalPhotoURL.absoluteString
            photo.timeStamp = Date()
            photo.id = UUID()
            photo.image = photoData // We are saving small/thumb data.
            photo.model = try JSONEncoder().encode(photoViewModel.photo)

            CoreDataManager.shared.persistentContainer.viewContext.insert(photo)
            try CoreDataManager.shared.save()
        }
    }

    class func deletePhoto(url: URL) throws {
        let fetchRequest = ManagedSavedPhoto.fetchRequest()
        fetchRequest.predicate = .init(format: "url LIKE %@", url.absoluteString)
        if let result = try? CoreDataManager.shared.context.fetch(fetchRequest) {
            result.forEach { CoreDataManager.shared.context.delete($0) }
        }
        try CoreDataManager.shared.save()
    }

    class func getPhotos() throws ->  [PhotoViewModel] {
        let result = try CoreDataManager.shared.context.fetch(ManagedSavedPhoto.fetchRequest())
        return try result.compactMap {
            let photoModel = try JSONDecoder().decode(APIPhoto.self, from: $0.model)
            let viewModel = PhotoViewModel(photo: photoModel)
            viewModel.smallImageCache = $0.image
            viewModel.cachedOn = $0.timeStamp
            return viewModel
        }
    }

    class func isPhotoAlreadySaved(for url: URL) -> Bool {
        let fetchRequest = ManagedSavedPhoto.fetchRequest()
        fetchRequest.predicate = .init(format: "url LIKE %@", url.absoluteString)
        if let result = try? CoreDataManager.shared.context.fetch(fetchRequest) {
            return !result.isEmpty
        }
        return false
    }
}
