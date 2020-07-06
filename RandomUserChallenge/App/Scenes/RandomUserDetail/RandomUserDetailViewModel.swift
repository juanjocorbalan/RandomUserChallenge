//
//  RandomUserDetailViewModel.swift
//  RandomUserChallenge
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation

import Foundation
import RxSwift

struct RandomUserDetailViewModel {
    
    // MARK: - Inputs
    

    // MARK: - Outputs
    
    let name: Observable<String>
    let gender: Observable<String>
    let city: Observable<String>
    let email: Observable<String>
    let description: Observable<String>
    let avatar: Observable<URL?>
    let background: Observable<URL?>

    private let user: RandomUser
    
    init(user: RandomUser) {
        self.user = user

        self.name = Observable.of("\(user.firstName) \(user.lastName)")
        self.gender = Observable.of(user.gender)
        self.city = Observable.of(user.city)
        self.email = Observable.of(user.email)
        self.description = Observable.of(user.description)
        self.avatar = Observable.of(URL(string: user.avatar))
        self.background = Observable.of(URL(string: user.background))
    }
}
