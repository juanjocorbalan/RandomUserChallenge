//
//  main.swift
//  RandomUserChallenge
//
//  Created by Juanjo Corbalán on 08/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import UIKit

let appDelegateClass: AnyClass = NSClassFromString("RandomUserChallengeTests.TestingAppDelegate") ?? AppDelegate.self
UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(appDelegateClass))
