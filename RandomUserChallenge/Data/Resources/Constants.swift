//
//  Constants.swift
//  RandomUserChallenge
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation

struct RandomUserAPI {
    static let baseURL = URL(string: "https://my-json-server.typicode.com/Karumi/codetestdata")!

    struct paths {
        static let users = "users"
    }
}

struct RandomUserCache {
    struct keys {
        static let identifier = "identifier"
    }
}
