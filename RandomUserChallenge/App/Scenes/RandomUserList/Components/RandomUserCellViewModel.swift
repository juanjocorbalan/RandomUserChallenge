//
//  RandomUserCellViewModel.swift
//  RandomUserChallenge
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation

struct RandomUserCellViewModel {
    let name: String
    let city: String
    let avatar: URL?
    let background: URL?

    init(user: RandomUser) {
        self.name = "\(user.firstName) \(user.lastName)"
        self.city = user.city
        self.avatar = URL(string: user.avatar)
        self.background = URL(string: user.background)
    }
}
