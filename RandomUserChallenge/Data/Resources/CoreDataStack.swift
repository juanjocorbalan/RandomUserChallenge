//
//  CoreDataStack.swift
//  RandomUserChallenge
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {

    static let shared: CoreDataStack = CoreDataStack()

    private let persistentContainer: NSPersistentContainer

    lazy private(set) var backgroundContext: NSManagedObjectContext = {
        return persistentContainer.newBackgroundContext()
    }()
    
    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    init(model: String = "RandomUserChallenge", url: URL? = nil, inMemory: Bool = false) {
        if let url = url {
            let objectModel = NSManagedObjectModel(contentsOf: url)!
            self.persistentContainer = NSPersistentContainer(name: model, managedObjectModel: objectModel)
        } else {
            self.persistentContainer = NSPersistentContainer(name: model)
        }

        if inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            description.shouldAddStoreAsynchronously = false
            self.persistentContainer.persistentStoreDescriptions = [description]
        }
     
        self.persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
