//
//  Observable+Extensions.swift
//  RandomUserChallenge
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation
import RxSwift

extension Sequence where Iterator.Element: DomainConvertibleEntity {
    func toDomain() -> [Iterator.Element.DomainEntity] {
        return map {
            return $0.toDomain()
        }
    }
}
