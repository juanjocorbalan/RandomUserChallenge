//
//  CacheClientType.swift
//  RandomUserChallenge
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation
import RxSwift

protocol CacheClientType {
    associatedtype T
    
    func getAll() -> Observable<[T]>
    func get<V>(key: String, value: V) -> Observable<[T]>
    func createOrUpdate(element: T) -> Observable<Void>
    func update<V>(key: String, value: V, with values: [String: Any]) -> Observable<Void>
    func delete<V>(key: String, value: V) -> Observable<Void>
    func deleteAll() -> Observable<Void>
}

enum CacheError: Error {
    case error
    case notFound
}
