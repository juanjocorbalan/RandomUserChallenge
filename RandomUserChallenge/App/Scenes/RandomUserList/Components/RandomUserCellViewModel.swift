//
//  RandomUserCellViewModel.swift
//  RandomUserChallenge
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation
import RxSwift

struct RandomUserCellViewModel: Hashable {
    
    // MARK: - Inputs
    let removeSelected: AnyObserver<Void>

    // MARK: - Outputs
    let name: Observable<String>
    let city: Observable<String>
    let avatar: Observable<(URL?, String)>
    let background: Observable<(URL?, String)>
    let removeDidTap: Observable<RandomUser>
    
    private let user: RandomUser
    
    var id: String {
        self.user.id
    }
    
    func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    static func == (lhs: RandomUserCellViewModel, rhs: RandomUserCellViewModel) -> Bool {
        lhs.id == rhs.id
    }
    
    // MARK: - Init

    init(user: RandomUser) {
        self.user = user
        
        let removeSubject = PublishSubject<Void>()
        self.removeSelected = removeSubject.asObserver()
        self.removeDidTap = removeSubject.asObservable().map { user }

        self.name = Observable.of("\(user.firstName) \(user.lastName)")
        self.city =  Observable.of(user.city)
        self.avatar = Observable.of((URL(string: user.avatar), user.id))
        self.background =  Observable.of((URL(string: user.background), user.id))
    }
}
