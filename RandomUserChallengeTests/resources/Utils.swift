//
//  Utils.swift
//  RandomUserChallengeTests
//
//  Created by Juanjo Corbalán on 08/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation
import CoreData
@testable import RandomUserChallenge

class MockCoreDataClient: CoreDataClient<RandomUser> {
    init() {
        let bundle = Bundle.init(for: MockCoreDataClient.self)
        let modelURL = bundle.url(forResource: "TestModel", withExtension: "momd")!

        super.init(coreDataStack: CoreDataStack(model: "TestModel", url: modelURL, inMemory: true))
    }
}

let mockCoreDataClient = MockCoreDataClient()
let randomUser1 = RandomUser(id: "1", firstName: "name", lastName: "last", email: "email", gender: "gender", ipAddress: "ip", avatar: "", city: "", background: "", description: "")
let randomUser2 = RandomUser(id: "2", firstName: "name", lastName: "last", email: "email", gender: "gender", ipAddress: "ip", avatar: "", city: "", background: "", description: "")
