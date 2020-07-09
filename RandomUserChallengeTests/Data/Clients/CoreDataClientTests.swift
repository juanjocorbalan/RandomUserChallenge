//
//  CoreDataClientTests.swift
//  RandomUserChallengeTests
//
//  Created by Juanjo Corbalán on 08/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
@testable import RandomUserChallenge

class CoreDataClientTests: XCTestCase {
    
    var sut: CoreDataClient = mockDependencyContainer.resolve()
    
    override func setUp() {
        super.setUp()
        _ = sut.deleteAll().subscribeOn(scheduler).toBlocking().materialize()
    }
    
    func test_getObjectsWhileEmpty_ShouldCompleteWithoutValues() throws {
        
        let results = try sut.getAll().subscribeOn(scheduler).toBlocking().first()!
        
        XCTAssertTrue(results.isEmpty, "Expecting 0 results but got \(results.count) results instead")
    }

    func test_createObject_ShouldSucceed() throws {
        
        _ = sut.createOrUpdate(element: randomUser1).subscribeOn(scheduler).toBlocking().materialize()
            
        let results = try sut.get(key: RandomUserCache.keys.id, value: randomUser1.id).subscribeOn(scheduler).toBlocking().first()!

        XCTAssertTrue(results.count == 1, "A valid object should have been inserted into core data storage")
    }

    func test_getInexistentObject_ShouldFail() throws {

        let results = try sut.get(key: RandomUserCache.keys.id, value: randomUser1.id).subscribeOn(scheduler).toBlocking().first()!

        XCTAssertTrue(results.count == 0, "An inexistent object shouldn't have been found")
    }

    func test_deleteObject_ShouldSucceedAndRemoveFromStorage() throws {
        
        _ = sut.createOrUpdate(element: randomUser1).subscribeOn(scheduler).toBlocking().materialize()
        _ = sut.delete(key: RandomUserCache.keys.id, value: randomUser1.id).subscribeOn(scheduler).toBlocking().materialize()

        let results = try sut.get(key: RandomUserCache.keys.id, value: randomUser1.id).subscribeOn(scheduler).toBlocking().first()!

        XCTAssertTrue(results.count == 0, "A deleted object shouldn't have been found")
    }

    func test_deletingAllObject_ShouldEmptyStorage() throws {
       
        _ = sut.createOrUpdate(element: randomUser1).subscribeOn(scheduler).toBlocking().materialize()
        _ = sut.createOrUpdate(element: randomUser2).subscribeOn(scheduler).toBlocking().materialize()
        _ = sut.deleteAll().subscribeOn(scheduler).toBlocking().materialize()

        let results = try sut.getAll().subscribeOn(scheduler).toBlocking().first()!

        XCTAssertTrue(results.count == 0, "After deleting all objects shouldn't have found any of them")
    }

    func test_updatingAnObject_ShouldSucceed() throws {
      
        _ = sut.createOrUpdate(element: randomUser1).subscribeOn(scheduler).toBlocking().materialize()
        var updatedUser = randomUser1
        updatedUser.firstName = "modified"
        _ = sut.createOrUpdate(element: updatedUser).subscribeOn(scheduler).toBlocking().materialize()

        let results = try sut.get(key: RandomUserCache.keys.id, value: randomUser1.id).subscribeOn(scheduler).toBlocking().first()!

        XCTAssertTrue(results.count == 1, "Only one object should have been found")
        XCTAssertTrue(results.first?.firstName == "modified", "The found object should have a modified firstName")
    }
}
