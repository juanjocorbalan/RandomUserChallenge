
//
//  RandomUserDetailCoordinator.swift
//  RandomUserChallenge
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RandomUserDetailCoordinator: Coordinator<Void> {
    
    private let navigationController: UINavigationController
    private let user: RandomUser
    private let dependencies: DependencyContainer
    
    init(user: RandomUser, navigationController: UINavigationController, dependencies: DependencyContainer) {
        self.navigationController = navigationController
        self.user = user
        self.dependencies = dependencies
    }
    
    override func start() -> Observable<Void> {
        
        let viewController: RandomUserDetailViewController = dependencies.resolve(user: user)
                
        navigationController.pushViewController(viewController, animated: true)
        
        return viewController.rx.deallocated
    }
}
