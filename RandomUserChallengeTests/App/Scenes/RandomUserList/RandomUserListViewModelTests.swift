//
//  RandomUserListViewModelTests.swift
//  RandomUserChallengeTests
//
//  Created by Juanjo Corbalán on 09/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import XCTest
import RxSwift
@testable import RandomUserChallenge

class RandomUserListViewModelTests: XCTestCase {
    
    private var disposeBag = DisposeBag()

    var sut: RandomUserListViewModel!
    
    override func setUp() {
        super.setUp()
        mockDependencyContainer.reset()
        sut = mockDependencyContainer.resolve()
    }
    
    func test_viewModel_shouldProvideTitleObservable() {

        let expectation = XCTestExpectation(description: "RandomUserListViewModel should provide a title observable")
        
        sut.title
            .subscribe(onNext: { title in
                XCTAssertEqual(title, "Random User Inc.")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 3.0)
    }

    func test_viewModel_shouldPovidesUsersObservableOnReload() {
        
        let expectation = XCTestExpectation(description: "RandomUserListViewModel should provide a users observable on reload")
        
        sut.users
            .subscribe(onNext: { users in
                XCTAssertEqual(users.count, 2, "Two RandomUserCellViewModel were exepcted but got \(users.count) instead")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        sut.reload.onNext(())
        
        wait(for: [expectation], timeout: 3.0)
    }

    func test_onUserSelection_viewModelShouldFireShowUserObservable() throws {
        
        let expectation = XCTestExpectation(description: "RandomUserListViewModel should fire shouw user after user selection")
        
        sut.reload.onNext(())
        _ = try sut.users.subscribeOn(scheduler).toBlocking().first()!

        sut.showUser
            .subscribe(onNext: { user in
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        sut.userSelected.onNext(IndexPath(item: 0, section: 0))

        wait(for: [expectation], timeout: 3.0)
    }

    func test_onError_viewModelShouldProvideErrorMessageObservable() throws {
        
        let expectation = XCTestExpectation(description: "RandomUserListViewModel should provide an error message observable")
        
        mockDependencyContainer.mockApiClient.failWithError = true
        
        var errorMessageReceived = false
        sut.errorMessage
            .subscribe(onNext: { message in
                errorMessageReceived = true
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        sut.reload.onNext(())
        
        wait(for: [expectation], timeout: 3.0)
        
        XCTAssertTrue(errorMessageReceived, "An error message should have been provided after failing reload data")
    }
    
    func test_viewModel_shouldProvideIsLoadingObservableInitiallyTrue() {

        let expectation = XCTestExpectation(description: "RandomUserListViewModel should provide is loading observable and emit true at the beginning")
        
        sut.isLoading
            .subscribe(onNext: { value in
                XCTAssertTrue(value)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        wait(for: [expectation], timeout: 3.0)
    }

    func test_viewModel_shouldProvideIsLoadingObservableFalseAfterLoadingData() {

        let expectation = XCTestExpectation(description: "RandomUserListViewModel should provide is loading observable and emit false after loading data")
        
        sut.reload.onNext(())

        sut.isLoading.skip(1)
            .subscribe(onNext: { value in
                XCTAssertFalse(value)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        
        wait(for: [expectation], timeout: 3.0)
    }

    func test_viewModel_shouldProvideIsLoadingObservableFalseAfterAnError() {

        let expectation = XCTestExpectation(description: "RandomUserListViewModel should provide is loading observable and emit false after an error occurs")
        
        mockDependencyContainer.mockApiClient.failWithError = true
        
        sut.reload.onNext(())

        sut.isLoading.skip(1)
            .subscribe(onNext: { value in
                XCTAssertFalse(value)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        
        wait(for: [expectation], timeout: 3.0)
    }
}
