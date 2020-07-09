//
//  GetUsersUseCaseTests.swift
//  RandomUserChallengeTests
//
//  Created by Juanjo Corbalán on 09/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import XCTest
import RxSwift
import RxBlocking
@testable import RandomUserChallenge

class GetUsersUseCaseTests: XCTestCase {
    
    private var disposeBag = DisposeBag()

    var sut: GetUsersUseCase = mockDependencyContainer.resolve()
    
    override func setUp() {
        super.setUp()
        mockDependencyContainer.reset()
    }
    
    override func tearDown() {
        super.tearDown()
        disposeBag = DisposeBag()
    }

    func test_getUsers_ShouldSucceed() {
        
        let expectation = XCTestExpectation(description: "A valid resonse is expected by executing the use case")
       
        var result: [RandomUser] = []
        
        sut.execute()
            .subscribe(onNext: { users in
                result = users
            }, onCompleted: {
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 3.0)

        XCTAssertFalse(result.isEmpty, "An array of RandonUser objects was expected")
        XCTAssertEqual(result.count, 2, "Two users were expected as result bug got \(result.count) instead")
    }

    func test_getUsersOnBadResponse_ShouldFailWithError() {
        
        let expectation = XCTestExpectation(description: "An error is expected in case of bad response")
       
        var failedOnError = false
        
        mockDependencyContainer.mockApiClient.failWithError = true
        
        sut.execute()
            .subscribe(onError: { _ in
                failedOnError = true
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 3.0)

        XCTAssertTrue(failedOnError, "An error was expected due to a bad response")
    }
}
