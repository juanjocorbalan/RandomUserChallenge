//
//  DependencyContainer.swift
//  RandomUserChallenge
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import UIKit

class DependencyContainer {
    
    func resolve(window: UIWindow) -> RandomUserListCoordinator {
        return RandomUserListCoordinator(window: window, dependencies: self)
    }
    
    func resolve(user: RandomUser, navigationController: UINavigationController) -> RandomUserDetailCoordinator {
        return RandomUserDetailCoordinator(user: user, navigationController: navigationController, dependencies: self)
    }

    func resolve() -> RandomUserListViewController {
        let viewController = RandomUserListViewController.initFromStoryboard()
        viewController.viewModel = resolve()
        return viewController
    }
    
    func resolve(user: RandomUser) -> RandomUserDetailViewController {
        let viewController = RandomUserDetailViewController.initFromStoryboard()
        viewController.viewModel = resolve(user: user)
        viewController.imageFetcher = resolve()
        return viewController
    }
    
    func resolve() -> RandomUserListViewModel {
        return RandomUserListViewModel(getUsersUseCase: resolve(), deleteUserUseCase: resolve())
    }
    
    func resolve(user: RandomUser) -> RandomUserDetailViewModel {
        return RandomUserDetailViewModel(user: user)
    }

    func resolve() -> GetUsersUseCase {
        return GetUsersUseCase(repository: resolve())
    }

    func resolve() -> DeleteUserUseCase {
        return DeleteUserUseCase(repository: resolve())
    }
    
    func resolve() -> RandomUserRepositoryType {
        return RandomUserRepository(apiDataSource: resolve(), cacheDataSource: resolve())
    }
    
    func resolve() -> RandomUserAPIDataSourceType {
        return RandomUserAPIDataSource(apiClient: resolve())
    }
    
    func resolve() -> RandomUserCacheDataSourceType {
        return RandomUserCacheDataSource<CoreDataClient<RandomUser>>(cacheClient: resolve())
    }
    
    func resolve() -> APIClient {
        return APIClient()
    }
    
    func resolve() -> CoreDataClient<RandomUser> {
        return CoreDataClient<RandomUser>()
    }
    
    func resolve() -> ImageFetcher {
        return ImageFetcher.shared
    }
}
