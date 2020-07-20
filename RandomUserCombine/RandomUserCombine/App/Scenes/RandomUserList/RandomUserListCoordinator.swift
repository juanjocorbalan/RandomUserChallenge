//
//  RandomUserListCoordinator.swift
//  RandomUserCombine
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import UIKit
import Combine

class RandomUserListCoordinator: Coordinator<Void> {
    
    var cancellables = Set<AnyCancellable>()

    private let window: UIWindow
    private let dependencies: DependencyContainer
    
    init(window: UIWindow, dependencies: DependencyContainer) {
        self.window = window
        self.dependencies = dependencies
    }
    
    // MARK: - Creation

    override func start() -> AnyPublisher<Void, Never> {
        let viewController: RandomUserListViewController = dependencies.resolve()
        let navigationController = UINavigationController(rootViewController: viewController)
        
        viewController.viewModel.showUser
            .flatMap { [weak self] user -> AnyPublisher<Void, Never> in
                guard let strongSelf = self else { return Empty().eraseToAnyPublisher() }
                return strongSelf.showUser(user, in: navigationController)
            }
            .sink(receiveValue: { _ in })
            .store(in: &cancellables)

        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
        
        return Empty<Void, Never>(completeImmediately: false).eraseToAnyPublisher()
    }
    
    // MARK: - Navigation
    
     private func showUser(_ user: RandomUser, in navigationController: UINavigationController) -> AnyPublisher<Void, Never>{
        let coordinator = dependencies.resolve(user: user, navigationController: navigationController)
        return run(coordinator)
    }
}
