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

    var sut = MockAPIClient()
    
    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
    }
    
    func test_getUsersFromAPI_ShouldSucceed() {
        
        let url = RandomUserAPI.baseURL.appendingPathComponent(RandomUserAPI.paths.users)
        let resource = Resource<[RandomUserDTO]>(url: url, parameters: nil, method: HTTPMethod.get)

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
}
