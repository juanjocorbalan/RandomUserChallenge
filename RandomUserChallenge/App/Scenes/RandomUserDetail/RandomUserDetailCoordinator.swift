
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
    private let animator: ZoomAnimator

    init(user: RandomUser, navigationController: UINavigationController, dependencies: DependencyContainer) {
        self.navigationController = navigationController
        self.user = user
        self.dependencies = dependencies
        self.animator = dependencies.resolve()
    }
    
    override func start() -> Observable<Void> {
        
        let viewController: RandomUserDetailViewController = dependencies.resolve(user: user)
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.transitioningDelegate = animator
                
        self.navigationController.present(navigationController, animated: true)
        
        return Observable.merge(viewController.rx.deallocated,
                                viewController.viewModel.didClose
                                    .do(onNext: { _ in
                                        self.navigationController.dismiss(animated: true)
                                    })
                )
                .take(1)
        
    }
    
    deinit {
        print("deinit")
    }
}
