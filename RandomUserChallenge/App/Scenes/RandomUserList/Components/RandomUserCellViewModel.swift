//
//  RandomUserCellViewModel.swift
//  RandomUserChallenge
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation
import RxSwift

struct RandomUserCellViewModel {
    
    // MARK: - Inputs
    let removeSelected: AnyObserver<Void>

    // MARK: - Outputs
    let name: Observable<String>
    let city: Observable<String>
    let avatar: Observable<(URL?, String)>
    let background: Observable<(URL?, String)>
    let removeDidTap: Observable<Void>
    
    // MARK: - Init

    init(user: RandomUser) {
        let removeSubject = PublishSubject<Void>()
        self.removeSelected = removeSubject.asObserver()
        self.removeDidTap = removeSubject.asObservable()

        self.name = Observable.of("\(user.firstName) \(user.lastName)")
        self.city =  Observable.of(user.city)
        self.avatar = Observable.of((URL(string: user.avatar), user.id))
        self.background =  Observable.of((URL(string: user.background), user.id))
    }
}
