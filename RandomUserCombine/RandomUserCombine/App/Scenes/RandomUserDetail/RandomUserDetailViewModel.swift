//
//  RandomUserDetailViewModel.swift
//  RandomUserCombine
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation
import Combine

class RandomUserDetailViewModel: ObservableObject {
    
    // MARK: - Inputs
    let close = PassthroughSubject<Void, Never>()

    // MARK: - Outputs
    
    @Published private(set) var name: String
    @Published private(set) var gender: String
    @Published private(set) var city: String
    @Published private(set) var email: String
    @Published private(set) var description: String
    @Published private(set) var avatar: (URL?, String)
    @Published private(set) var background: (URL?, String)
    private(set) var didClose: AnyPublisher<Void, Never>

    init(user: RandomUser) {
        self.name = "\(user.firstName) \(user.lastName)"
        self.gender = user.gender
        self.city = user.city
        self.email = user.email
        self.description = user.description
        self.avatar = (URL(string: user.avatar), user.id)
        self.background = (URL(string: user.background), user.id)
        self.didClose = self.close.eraseToAnyPublisher()
    }
}
