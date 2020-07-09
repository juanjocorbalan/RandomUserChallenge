//
//  CoreDataClient.swift
//  RandomUserChallenge
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import RxSwift
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
    
    func getAll() -> Observable<[T]> {
   
        request.predicate = nil
        
        return Observable.create { [weak self] observer in
            
            guard let strongSelf = self else {
                observer.onError(CacheError.error)
                return Disposables.create()
            }
            
            do {
                let results = try strongSelf.context.fetch(strongSelf.request)
                observer.onNext(results.toDomain())
                observer.onCompleted()
                
            } catch {
                observer.onError(CacheError.error)
            }
            
            return Disposables.create()
        }
    }
    
    func get<V>(key: String, value: V) -> Observable<[T]> {
        
        return Observable.create { [weak self] observer in
            
            guard let strongSelf = self else {
                observer.onError(CacheError.error)
                return Disposables.create()
            }
            
            if let results = strongSelf.find(key: key, value: value) {
                observer.onNext(results.toDomain())
                observer.onCompleted()
            } else {
                observer.onError(CacheError.notFound)
            }
            
            return Disposables.create()
        }
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
    
    func createOrUpdate(element: T) -> Observable<Void> {
        
        return Observable.create { [weak self] observer in
            
            guard let strongSelf = self else {
                observer.onError(CacheError.error)
                return Disposables.create()
            }
            
            if let object = strongSelf.find(key: RandomUserCache.keys.id, value: element.id)?.first {
                object.update(with: element)
            } else {
                _ = element.toManaged(in: strongSelf.context)
            }
            
            do {
                try strongSelf.context.save()
                
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(CacheError.error)
            }
            
            return Disposables.create()
        }
    }
    
    //MARK: - Partial Update
    
    func update<V>(key: String, value: V, with values: [String: Any]) -> Observable<Void> {
        
        return Observable.create { [weak self] observer in
            
            guard let strongSelf = self else {
                observer.onError(CacheError.error)
                return Disposables.create()
            }
            
            if let object = strongSelf.find(key: key, value: value)?.first {
                values.forEach { (key, value) in
                    object.setValue(value, forKey: key)
                }
            } else {
                observer.onError(CacheError.notFound)
            }
            
            do {
                try strongSelf.context.save()
                
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(CacheError.error)
            }
            
            return Disposables.create()
        }
    }

    //MARK: - Remove
    
    func delete<V>(key: String, value: V) -> Observable<Void> {
        
        return Observable.create { [weak self] observer in
            
            guard let strongSelf = self else {
                observer.onError(CacheError.error)
                return Disposables.create()
            }
            
            if let object = strongSelf.find(key: key, value: value)?.first {
                strongSelf.context.delete(object)
            }
            
            do {
                try strongSelf.context.save()
                
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(CacheError.error)
            }
            
            return Disposables.create()
        }
    }
    
    func deleteAll() -> Observable<Void> {
        
        request.predicate = nil

        return Observable.create { [weak self] observer in
            
            guard let strongSelf = self else {
                observer.onError(CacheError.error)
                return Disposables.create()
            }
            
            do {
                let results = try strongSelf.context.fetch(strongSelf.request)
                
                results.forEach {
                    strongSelf.context.delete($0)
                }
                
                try strongSelf.context.save()
                
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(CacheError.error)
            }
            
            return Disposables.create()
        }
    }
}
