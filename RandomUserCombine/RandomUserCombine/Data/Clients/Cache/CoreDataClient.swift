//
//  CoreDataClient.swift
//  RandomUserCombine
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Combine
import CoreData

class CoreDataClient<T>: CacheClientType where T: DomainToManagedConvertibleEntity, T: Identifiable, T.ManagedEntity: NSManagedObject, T == T.ManagedEntity.DomainEntity {
    
    private let stack: CoreDataStack
    
    private var context: NSManagedObjectContext {
        return self.stack.backgroundContext
    }
    
    private var request: NSFetchRequest<T.ManagedEntity>
    
    init(coreDataStack: CoreDataStack) {
        self.stack = coreDataStack
        self.request = T.ManagedEntity.fetchRequest() as! NSFetchRequest<T.ManagedEntity>
    }
    
    //MARK: - Get
    
    func getAll() -> AnyPublisher<[T], CacheError> {
   
        request.predicate = nil
        
        return Future<[T], CacheError> { [weak self] promise in
            guard let strongSelf = self else {
                promise(.failure(.error))
                return
            }
            
            do {
                let results = try strongSelf.context.fetch(strongSelf.request)
                promise(.success(results.toDomain()))
            } catch {
                promise(.failure(.error))
            }
        }.eraseToAnyPublisher()
    }
    
    func get<V>(key: String, value: V) -> AnyPublisher<[T], CacheError> {
        
        return Future<[T], CacheError> { [weak self] promise in
            guard let strongSelf = self else {
                promise(.failure(.error))
                return
            }
            
            if let results = strongSelf.find(key: key, value: value) {
                promise(.success(results.toDomain()))
            } else {
                promise(.failure(.error))
            }
        }.eraseToAnyPublisher()
    }
    
    private func find<V>(key: String, value: V) -> [T.ManagedEntity]? {
        
        request.predicate = NSPredicate(format: "\(key) == %@", argumentArray: [value])
        
        do {
            return try context.fetch(request)
        } catch {
            return nil
        }
    }
    
    //MARK: - Create/Update
    
    func createOrUpdate(element: T) -> AnyPublisher<Void, CacheError> {
        
        return Future<Void, CacheError> { [weak self] promise in
            
            guard let strongSelf = self else {
                promise(.failure(.error))
                return
            }
            
            if let object = strongSelf.find(key: RandomUserCache.keys.id, value: element.id)?.first {
                object.update(with: element)
            } else {
                _ = element.toManaged(in: strongSelf.context)
            }
            
            do {
                try strongSelf.context.save()
                promise(.success(()))
            } catch {
                promise(.failure(.error))
            }
        }.eraseToAnyPublisher()
    }
    
    //MARK: - Partial Update
    
    func update<V>(key: String, value: V, with values: [String: Any]) -> AnyPublisher<Void, CacheError> {
        
        return Future<Void, CacheError> { [weak self] promise in
            
            guard let strongSelf = self else {
                promise(.failure(.error))
                return
            }
            
            if let object = strongSelf.find(key: key, value: value)?.first {
                values.forEach { (key, value) in
                    object.setValue(value, forKey: key)
                }
            } else {
                promise(.failure(.notFound))
            }
            
            do {
                try strongSelf.context.save()
                promise(.success(()))
                
            } catch {
                promise(.failure(.error))
            }
        }.eraseToAnyPublisher()
    }

    //MARK: - Remove
    
    func delete<V>(key: String, value: V) -> AnyPublisher<Void, CacheError> {
        
        return Future<Void, CacheError> { [weak self] promise in
            
            guard let strongSelf = self else {
                promise(.failure(.error))
                return
            }
            
            if let object = strongSelf.find(key: key, value: value)?.first {
                strongSelf.context.delete(object)
            }
            
            do {
                try strongSelf.context.save()
                promise(.success(()))
            } catch {
                promise(.failure(.error))
            }
        }.eraseToAnyPublisher()
    }
    
    func deleteAll() -> AnyPublisher<Void, CacheError> {
        
        request.predicate = nil
        
        return Future<Void, CacheError> { [weak self] promise in
            
            guard let strongSelf = self else {
                promise(.failure(.error))
                return
            }
            
            do {
                let results = try strongSelf.context.fetch(strongSelf.request)
                
                results.forEach {
                    strongSelf.context.delete($0)
                }
                
                try strongSelf.context.save()
                promise(.success(()))
            } catch {
                promise(.failure(.error))
            }
        }.eraseToAnyPublisher()
    }
}
