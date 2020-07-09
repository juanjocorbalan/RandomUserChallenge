//
//  APiClientTests.swift
//  RandomUserChallengeTests
//
//  Created by Juanjo Corbalán on 08/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import XCTest
import RxSwift
@testable import RandomUserChallenge

class APIClientTests: XCTestCase {
    
    private var disposeBag = DisposeBag()

    var url: URL!
    var resource: Resource<[RandomUserDTO]>!
    var sut: MockAPIClient!
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()

        url = RandomUserAPI.baseURL.appendingPathComponent(RandomUserAPI.paths.users)
        resource = Resource<[RandomUserDTO]>(url: url, parameters: nil, method: HTTPMethod.get)

        sut = MockAPIClient()
    }
    
    func test_getUsersFromAPI_ShouldSucceed() {
        
        let expectation = XCTestExpectation(description: "A valid resonse should is expected by executing a valid resource")
       
        var result: [RandomUserDTO] = []
        
        sut.execute(resource)
            .subscribe(onNext: { values in
                result = values
            }, onCompleted: {
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 3.0)

        XCTAssertFalse(result.isEmpty, "An array of RandonUserDTO objects was expected")
    }

    func test_getUsersWithBadResponse_ShouldFailWithError() {
        
        let expectation = XCTestExpectation(description: "An error is expected on a invalid response")
       
        var failedOnError = false
        
        sut.failWithError = true
        
        sut.execute(resource)
            .subscribe(onError: { _ in
                failedOnError = true
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 3.0)

        XCTAssertTrue(failedOnError, "An error was expected on a bad response")
    }
}
