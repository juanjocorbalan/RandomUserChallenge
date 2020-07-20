//
//  Observable+Extensions.swift
//  RandomUserCombine
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation

extension Sequence where Iterator.Element: DomainConvertibleEntity {
    func toDomain() -> [Iterator.Element.DomainEntity] {
        return map {
            return $0.toDomain()
        }
    }
}
