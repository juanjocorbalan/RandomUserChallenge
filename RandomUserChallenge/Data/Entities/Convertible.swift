//
//  Convertible.swift
//  RandomUserChallenge
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation
import CoreData

protocol DomainConvertibleEntity {
    associatedtype DomainEntity

    func toDomain() -> DomainEntity
}

protocol ManagedToDomainConvertibleEntity: DomainConvertibleEntity {
    func toDomain() -> DomainEntity
    func update(with object: DomainEntity)
}

protocol DomainToManagedConvertibleEntity {
    associatedtype ManagedEntity: ManagedToDomainConvertibleEntity

    func toManaged(in: NSManagedObjectContext) -> ManagedEntity
}



