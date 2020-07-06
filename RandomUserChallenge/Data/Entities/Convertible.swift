//
//  Convertible.swift
//  RandomUserChallenge
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation

protocol DomainConvertibleEntity {
    associatedtype DomainEntity
    
    func toDomain() -> DomainEntity
}

protocol ManagedConvertibleEntity {
    associatedtype ManagedEntity: DomainConvertibleEntity
    
    func toManaged() -> ManagedEntity
}
