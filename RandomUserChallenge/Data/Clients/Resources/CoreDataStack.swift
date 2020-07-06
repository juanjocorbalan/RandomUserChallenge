//
//  CoreDataStack.swift
//  RandomUserChallenge
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation
import CoreData

final class CoreDataStack {

    static let shared: CoreDataStack = CoreDataStack()

    private let persistentContainer: NSPersistentContainer

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {
        self.persistentContainer = NSPersistentContainer(name: "RandomUserChallenge")
        self.persistentContainer.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
