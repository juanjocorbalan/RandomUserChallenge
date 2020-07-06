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
    
    func resolve() -> RandomUserListViewController {
        return RandomUserListViewController.initFromStoryboard()
    }
    
    func resolve(user: RandomUser) -> RandomUserDetailViewController {
        return RandomUserDetailViewController.initFromStoryboard()
    }
    
    func resolve() -> RandomUserListViewModel {
        return RandomUserListViewModel()
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
}
