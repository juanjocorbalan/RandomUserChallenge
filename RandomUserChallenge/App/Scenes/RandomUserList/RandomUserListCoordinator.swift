//
//  RandomUserListCoordinator.swift
//  RandomUserChallenge
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import UIKit
import RxSwift

class RandomUserListCoordinator: Coordinator<Void> {
    
    private let window: UIWindow
    private let dependencies: DependencyContainer
    
    init(window: UIWindow, dependencies: DependencyContainer) {
        self.window = window
        self.dependencies = dependencies
    }
    
    // MARK: - Creation

    override func start() -> Observable<Void> {
        let viewController: RandomUserListViewController = dependencies.resolve()
        let navigationController = UINavigationController(rootViewController: viewController)
        
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
        
        return Observable.never()
    }
}
