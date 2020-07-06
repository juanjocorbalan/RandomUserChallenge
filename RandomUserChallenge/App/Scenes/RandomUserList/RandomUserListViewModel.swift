//
//  RandomUserListViewModel.swift
//  RandomUserChallenge
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation
import RxSwift

struct RandomUserListViewModel {
    
    // MARK: - Inputs
    
    let userSelected: AnyObserver<IndexPath>
    let userDeleted: AnyObserver<IndexPath>
    let reload: AnyObserver<Void>

    // MARK: - Outputs
    
    let title: Observable<String>
    let users: Observable<[RandomUserCellViewModel]>
    let showUser: Observable<RandomUser>
    let errorMessage: Observable<String>
    let isLoading: Observable<Bool>

    init(getUserUseCase: GetUsersUseCase, deleteUserUseCase: DeleteUserUseCase) {
        self.title = Observable.of("Random User Inc.")

        let _reload = PublishSubject<Void>()
        self.reload = _reload.asObserver()
        
        let _errorMessage = PublishSubject<String>()
        self.errorMessage = _errorMessage.asObservable()
        
        let loadedUsers = _reload.startWith(()).flatMapLatest { _ in
            return getUserUseCase.execute()
                .catchError { error in
                    _errorMessage.onNext(error.localizedDescription)
                    return Observable.empty()
                }
        }
        
        
        let _userSelected = PublishSubject<IndexPath>()
        self.userSelected = _userSelected.asObserver()
        self.showUser = _userSelected.withLatestFrom(loadedUsers) { indexPath, users in
            return users[indexPath.row]
        }

        let _userDeleted = PublishSubject<IndexPath>()
        self.userDeleted = _userDeleted.asObserver()
        let updatedUsers = _userDeleted.withLatestFrom(loadedUsers) { indexPath, users in
            return (indexPath, users)
            }.flatMapLatest { (indexPath, users) in
                return deleteUserUseCase.execute(with: indexPath, on: users)
                    .catchError { error in
                        _errorMessage.onNext(error.localizedDescription)
                        return Observable.of([])
                }
            }
        
        self.users = Observable.merge(loadedUsers, updatedUsers).map { $0.map(RandomUserCellViewModel.init) }

        self.isLoading = Observable.merge(_reload.map { _ in true },
                                          errorMessage.map { _ in false },
                                          users.map { users in users.count == 0 })
    }
}

