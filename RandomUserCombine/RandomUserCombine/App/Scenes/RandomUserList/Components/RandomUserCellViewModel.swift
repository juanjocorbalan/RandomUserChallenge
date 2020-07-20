//
//  RandomUserCellViewModel.swift
//  RandomUserCombine
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation
import Combine

struct RandomUserCellViewModel {
    
    // MARK: - Inputs
    let removeSelected = PassthroughSubject<Void, Never>()

    // MARK: - Outputs
    private(set) var name: AnyPublisher<String, Never>
    private(set) var city: AnyPublisher<String, Never>
    private(set) var avatar: AnyPublisher<(URL?, String), Never>
    private(set) var background: AnyPublisher<(URL?, String), Never>
    private(set) var removeDidTap: AnyPublisher<RandomUser, Never>
    
    private let user: RandomUser
    
    var id: String {
        user.id
    }
    
    // MARK: - Init

    init(user: RandomUser) {
        self.user = user
        
        self.removeDidTap = self.removeSelected.map { user }.eraseToAnyPublisher()
        self.name = Just("\(user.firstName) \(user.lastName)").eraseToAnyPublisher()
        self.city =  Just(user.city).eraseToAnyPublisher()
        self.avatar = Just((URL(string: user.avatar), user.id)).eraseToAnyPublisher()
        self.background = Just((URL(string: user.background), user.id)).eraseToAnyPublisher()
    }
}


extension RandomUserCellViewModel: Hashable {

    static func == (lhs: RandomUserCellViewModel, rhs: RandomUserCellViewModel) -> Bool {
        return lhs.user.id == rhs.user.id
    }

    func hash(into hasher: inout Hasher) {
        return hasher.combine(user.id)
    }
}
