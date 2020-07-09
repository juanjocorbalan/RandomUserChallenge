//
//  RandomUserChallengeUITests.swift
//  RandomUserChallengeUITests
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import XCTest

class RandomUserChallengeUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUp() {
        app = XCUIApplication()
        continueAfterFailure = false
        app.launchArguments = ["-UITests"]
        app.launch()
    }

    func test_UserListDisplaysData() throws {
        
        let userCollectionView = app.collectionViews["collectionViewUsers"]
        
        XCTAssertEqual(userCollectionView.cells.count, 2, "User list should contain 2 elements")
    }

    func test_UserDisplayeModallyWithUsernameAsNavigationTitle() throws {
        
        let userCollectionView = app.collectionViews["collectionViewUsers"]
        
        let cell = userCollectionView.children(matching: .cell).matching(identifier: "collectionCellUser").element(boundBy: 1)
        
        cell.tap()
        
        XCTAssert(app.navigationBars["Giffard Giacomuzzi"].exists)
    }
}
