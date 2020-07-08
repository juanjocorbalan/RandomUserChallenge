//
//  RandomUserRepositoryType.swift
//  RandomUserChallenge
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation
import RxSwift

protocol RandomUserRepositoryType {
    func getUsers() -> Observable<[RandomUser]>
    func deleteUserBy(id: String) -> Observable<Void>
}
