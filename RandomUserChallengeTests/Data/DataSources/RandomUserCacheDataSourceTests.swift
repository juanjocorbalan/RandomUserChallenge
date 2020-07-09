//
//  RandomUserChallengeTests.swift
//  RandomUserChallengeTests
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import XCTest
import RxSwift
@testable import RandomUserChallenge

class RandomUserCacheDataSourceTests: XCTestCase {
    
    private var disposeBag = DisposeBag()

    var sut = RandomUserCacheDataSource<CoreDataClient>(cacheClient: mockDependencyContainer.resolve())
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
    }
    
    override func tearDown() {
        super.tearDown()
        mockDependencyContainer.reset()
    }

    func test_getObjectsFromEmptyCache_ShouldCompleteWithoutValue() {
        
        let expectation = XCTestExpectation(description: "An empty dataSource should complete without found values")
        var result: [RandomUser] = []
        
        sut.get(where: "id", equals: "1")
            .subscribe(onNext: { values in
                result = values
            }, onCompleted: {
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 3.0)

        XCTAssertTrue(result.isEmpty, "Inexistent object shouldn't be found but got \(result.count) results instead")
    }
    
    func test_insertObjectInCache_ShouldSucceed() {
        let expectation = XCTestExpectation(description: "A valid object should be inserted correctly into cache")
        var error = false
        
        sut.createOrUpdate(user: randomUser1)
            .subscribe(onError: { _ in
                error = true
            }, onCompleted: {
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 3.0)

        XCTAssertFalse(error, "A valid object should have been inserted into cache but got an error")
    }

    func test_getObjectInCacheByID_ShouldSucceed() {
        sut.createOrUpdate(user: randomUser1).subscribe().disposed(by: disposeBag)

        let expectation = XCTestExpectation(description: "A valid inserted object should be found into cache")

        var result: [RandomUser] = []

        sut.get(where: "id", equals: "1")
            .subscribe(onNext: { values in
                result = values
            }, onCompleted: {
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 3.0)

        XCTAssertTrue(result.count == 1, "Existent object should be found")
    }

    func test_getObjectsInCache_ShouldFindAsManyAsPreviouslyInserted() {
        sut.createOrUpdate(user: randomUser1).subscribe().disposed(by: disposeBag)
        sut.createOrUpdate(user: randomUser2).subscribe().disposed(by: disposeBag)

        let expectation = XCTestExpectation(description: "Two valid inserted objects should be found into cache")
        
        var result: [RandomUser] = []
        
        sut.get(where: "firstName", equals: "name")
            .subscribe(onNext: { values in
                result = values
            }, onCompleted: {
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 3.0)
        
        XCTAssertTrue(result.count == 2, "Two object were expected but got \(result.count) instead")
    }

    func test_deleteObjectInCacheByID_ShouldSucceed() {
        sut.createOrUpdate(user: randomUser1).subscribe().disposed(by: disposeBag)
        
        let expectation = XCTestExpectation(description: "Deleting an object should complete without error")
        
        var error = false

        sut.delete(by: "1")
            .subscribe(onError: { _ in
                error = true
            }, onCompleted: {
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 3.0)
        
        XCTAssertFalse(error, "Deleting an object should complete without error but got an error instead")
    }

    func test_deletingObjectInCacheByID_ShouldPreventFindingItAgain() {
        sut.createOrUpdate(user: randomUser1).subscribe().disposed(by: disposeBag)
        
        let expectation = XCTestExpectation(description: "An object shouldn't be found into cache after deletion")
        
        var result: [RandomUser] = []
        
        sut.delete(by: "1").subscribe().disposed(by: disposeBag)
        
        sut.get(where: "id", equals: "1")
            .subscribe(onNext: { values in
                result = values
            }, onCompleted: {
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 3.0)
        
        XCTAssertTrue(result.count == 0, "Deleted object shouldn't be found into cache but it was found")
    }

    func test_updatingAnObjectInCache_ShouldSucceed() {
      
        sut.createOrUpdate(user: randomUser1).subscribe().disposed(by: disposeBag)
        var updatedUser = randomUser1
        updatedUser.firstName = "modified"
        
        let expectation = XCTestExpectation(description: "Updating an object should complete without errors")
        
        var error = false
        
        sut.createOrUpdate(user: randomUser1)
            .subscribe(onError: { _ in
                error = true
            }, onCompleted: {
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 3.0)
        
        XCTAssertFalse(error, "Modifying an object into cache should complete without error")
    }

    func test_modifyingAnObjectIntoCache_ShouldPersistChanges() {
      
        sut.createOrUpdate(user: randomUser1).subscribe().disposed(by: disposeBag)
        var updatedUser = randomUser1
        updatedUser.firstName = "modified"
        sut.createOrUpdate(user: updatedUser).subscribe().disposed(by: disposeBag)
        
        let expectation = XCTestExpectation(description: "The updated object should be found into cache after it has been modified")
        
        var results: [RandomUser] = []
        
        sut.get(where: "id", equals: updatedUser.id)
            .subscribe(onNext: { values in
                results = values
            }, onCompleted: {
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 3.0)
        
        XCTAssertTrue(results.count == 1, "Only one updated object should be found into cache but got \(results.count) instead")
        XCTAssertTrue(results[0].firstName == "modified", "'\("modified")' was expcted as user name but got \(results[0].firstName) instead")
    }
}
