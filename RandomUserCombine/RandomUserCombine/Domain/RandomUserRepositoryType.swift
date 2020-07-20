//
//  RandomUserRepositoryType.swift
//  RandomUserCombine
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation
import Combine

protocol RandomUserRepositoryType {
    func getUsers() -> AnyPublisher<[RandomUser], Error>
    func deleteUserBy(id: String) -> AnyPublisher<Void, Error>
}
