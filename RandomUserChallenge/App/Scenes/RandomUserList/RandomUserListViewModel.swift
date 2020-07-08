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
    
    private var disposeBag = DisposeBag()
    private var usersSubject = PublishSubject<[RandomUser]>()
    private var reloadSubject = PublishSubject<Void>()
    private var userSelectedSubject = PublishSubject<IndexPath>()
    private var userDeletedSubject = PublishSubject<RandomUser>()
    private var errorSubject = PublishSubject<String>()
    private let getUsersUseCase: GetUsersUseCase
    private let deleteUserUseCase: DeleteUserUseCase

    // MARK: - Inputs
    
    lazy var userSelected: AnyObserver<IndexPath> = self.userSelectedSubject.asObserver()
    lazy var userDeleted: AnyObserver<RandomUser> = self.userDeletedSubject.asObserver()
    lazy var reload: AnyObserver<Void> = self.reloadSubject.asObserver()

    // MARK: - Outputs
    
    lazy var title: Observable<String> = Observable.of("Random User Inc.")
    lazy var users: Observable<[RandomUserCellViewModel]> = self.usersSubject.map { $0.map(RandomUserCellViewModel.init) }
    lazy var errorMessage: Observable<String> = self.errorSubject.asObservable()
    lazy var showUser: Observable<RandomUser> = self.userSelectedSubject.asObservable().withLatestFrom(usersSubject.asObservable()) { indexPath, users in
                                                    return users[indexPath.row]
                                                }
    lazy var isLoading: Observable<Bool> = Observable.merge(reloadSubject.map { _ in true },
                                                            errorSubject.map { _ in false },
                                                            usersSubject.map { _ in false })

    init(getUsersUseCase: GetUsersUseCase, deleteUserUseCase: DeleteUserUseCase) {
        self.getUsersUseCase = getUsersUseCase
        self.deleteUserUseCase = deleteUserUseCase
        setupRx()
    }
    
    private func setupRx() {

        reloadSubject.asObservable().startWith(()).flatMapLatest { _ in
            return self.getUsersUseCase.execute()
                .catchError { error in
                    self.errorSubject.onNext(error.localizedDescription)
                    return Observable.empty()
                }
        }.subscribe(onNext: { users in
            self.usersSubject.onNext(users)
        }).disposed(by: disposeBag)

        userDeletedSubject.asObservable().withLatestFrom(usersSubject.asObservable()) { user, users in
            return (user, users)
        }.flatMapLatest { (user, users) -> Observable<[RandomUser]> in
            var mutableUsers = users
            return self.deleteUserUseCase.execute(with: user)
                .map { _ in
                    mutableUsers.removeAll(where: { $0.id == user.id} )
                    return mutableUsers
                }
                .catchError { error in
                    self.errorSubject.onNext(error.localizedDescription)
                    return Observable.of(users)
            }
        }.subscribe(onNext: { users in
            self.usersSubject.onNext(users)
        }).disposed(by: disposeBag)
    }
}

