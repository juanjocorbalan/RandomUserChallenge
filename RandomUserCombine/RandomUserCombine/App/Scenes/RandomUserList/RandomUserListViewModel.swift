//
//  RandomUserListViewModel.swift
//  RandomUserCombine
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation
import Combine

class RandomUserListViewModel: ObservableObject {
    
    private var cancellables = Set<AnyCancellable>()
    private var usersSubject = CurrentValueSubject<[RandomUser], Never>([])
    private let getUsersUseCase: GetUsersUseCase
    private let deleteUserUseCase: DeleteUserUseCase

    // MARK: - Inputs
    
    let userSelected = PassthroughSubject<String, Never>()
    let userDeleted = PassthroughSubject<RandomUser, Error>()
    let reload = PassthroughSubject<Void, Error>()

    // MARK: - Outputs
    
    @Published private(set) var title = "Random User Inc."
    @Published private(set) var users: [RandomUserCellViewModel] = []
    @Published private(set) var errorMessage: String? = nil
    @Published private(set) var isLoading = true
    private(set) lazy var showUser: AnyPublisher<RandomUser, Never> = self.userSelected
        .compactMap { selected in return self.usersSubject.value.first(where: { $0.id == selected}) }
        .eraseToAnyPublisher()
    
    init(getUsersUseCase: GetUsersUseCase, deleteUserUseCase: DeleteUserUseCase) {
        self.getUsersUseCase = getUsersUseCase
        self.deleteUserUseCase = deleteUserUseCase
        setupRx()
    }
    
    private func setupRx() {
        
        Publishers.Merge3(reload.map { _ in true }.assertNoFailure(),
                         $errorMessage.map { _ in false }.assertNoFailure(),
                         $users.map { _ in false }.assertNoFailure())
            .assign(to: \.isLoading, on: self)
            .store(in: &cancellables)

        usersSubject
            .map { users in users.map { RandomUserCellViewModel(user: $0) } }
            .assign(to: \.users, on: self)
            .store(in: &cancellables)
        
        reload
            .map { _ in self.getUsersUseCase.execute() }
            .switchToLatest()
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] users in
                self?.usersSubject.send(users)
            })
            .store(in: &cancellables)
        
        userDeleted
            .flatMap { user in self.deleteUserUseCase.execute(with: user).map { _ in user } }
            .sink(receiveCompletion: { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            }, receiveValue: { [weak self] user in
                self?.usersSubject.value.removeAll(where: { $0.id == user.id} )
            })
            .store(in: &cancellables)
    }
}

