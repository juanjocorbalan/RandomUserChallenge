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
    private var usersSubject = BehaviorSubject<[RandomUser]>(value: [])
    private var reloadSubject = PublishSubject<Void>()
    private var userSelectedSubject = PublishSubject<IndexPath>()
    private var userDeletedSubject = PublishSubject<IndexPath>()
    private var errorSubject = PublishSubject<String>()
    private let getUsersUseCase: GetUsersUseCase
    private let deleteUserUseCase: DeleteUserUseCase

    // MARK: - Inputs
    
    lazy var userSelected: AnyObserver<IndexPath> = userSelectedSubject.asObserver()
    lazy var userDeleted: AnyObserver<IndexPath> = userDeletedSubject.asObserver()
    lazy var reload: AnyObserver<Void> = reloadSubject.asObserver()

    // MARK: - Outputs
    
    lazy var title: Observable<String> = Observable.of("Random User Inc.")
    lazy var users: Observable<[RandomUserCellViewModel]> = self.usersSubject.map { $0.map(RandomUserCellViewModel.init) }
    lazy var errorMessage: Observable<String> = self.errorSubject.asObserver()
    lazy var showUser: Observable<RandomUser> = self.userSelectedSubject.asObservable().withLatestFrom(usersSubject.asObservable()) { indexPath, users in
                                                    return users[indexPath.row]
                                                }
    lazy var isLoading: Observable<Bool> = Observable.merge(reloadSubject.map { _ in true },
                                                            errorSubject.map { _ in false },
                                                            usersSubject.map { users in users.count == 0 })

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

        userDeletedSubject.asObservable().withLatestFrom(usersSubject.asObservable()) { indexPath, users in
            return (users[indexPath.item], users)
        }.flatMapLatest { (user, users) in
            return self.deleteUserUseCase.execute(with: user, on: users)
                .catchError { error in
                    self.errorSubject.onNext(error.localizedDescription)
                    return Observable.of([])
            }
        }.subscribe(onNext: { users in
            self.usersSubject.onNext(users)
        }).disposed(by: disposeBag)
    }
}

