//
//  CoreDataManager.swift
//  Forest Flower
//
//  Created by Indrajit Chavda on 17/06/23.
//

import CoreData

class CoreDataManager {

    static let shared = CoreDataManager()

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer.init(name: "ForestFlower")
        container.loadPersistentStores { _, error in
            if let error = error {
                assertionFailure("\(error)")
            }
        }
        return container
    }()

    func save() throws {
        try persistentContainer.viewContext.save()
    }

    var context: NSManagedObjectContext {
        persistentContainer.viewContext
    }
}
