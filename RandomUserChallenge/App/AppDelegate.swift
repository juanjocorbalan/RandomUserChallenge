//
//  AppDelegate.swift
//  RandomUserChallenge
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import UIKit
import RxSwift

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    private var mainCoordinator: RandomUserListCoordinator!
    private var dependencies = DependencyContainer()
    private let disposeBag = DisposeBag()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        
        mainCoordinator = dependencies.resolve(window: window!)
        mainCoordinator.start()
            .subscribe()
            .disposed(by: disposeBag)
        
        setupAppearance()

        return true
    }
    
    private func setupAppearance() {
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.tintColor = Styles.Colors.accentColor
        navigationBarAppearace.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Styles.Colors.accentColor
        ]
        UIActivityIndicatorView.appearance().color = Styles.Colors.accentColor
        UIRefreshControl.appearance().tintColor = Styles.Colors.accentColor
    }
}
