//
//  CacheClientType.swift
//  RandomUserCombine
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation
import Combine

protocol CacheClientType {
    associatedtype T
    
    func getAll() -> AnyPublisher<[T], CacheError>
    func get<V>(key: String, value: V) -> AnyPublisher<[T], CacheError>
    func createOrUpdate(element: T) -> AnyPublisher<Void, CacheError>
    func update<V>(key: String, value: V, with values: [String: Any]) -> AnyPublisher<Void, CacheError>
    func delete<V>(key: String, value: V) -> AnyPublisher<Void, CacheError>
    func deleteAll() -> AnyPublisher<Void, CacheError>
}

enum CacheError: Error {
    case error
    case notFound
}
