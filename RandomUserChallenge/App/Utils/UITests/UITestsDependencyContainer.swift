//
//  UITestsDependencyContainer.swift
//  RandomUserChallenge
//
//  Created by Juanjo Corbalán on 09/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import CoreData
import RxSwift

class UITestsDependencyContainer: DependencyContainer {
    
    var mockApiClient = MockedAPIClient()
    
    override func resolve() -> APIClient {
        return MockedAPIClient()
    }
    
    override func resolve() -> CoreDataStack {
        return CoreDataStack(inMemory: true)
    }
}

class MockedAPIClient: APIClient {
    
    override func execute<R>(_ resource: R) -> Observable<R.ResponseType> where R : ResourceType {
        
        var stubResponseFileName = ""
        switch R.ResponseType.self {
        case is [RandomUserDTO].Type:
            stubResponseFileName = "randomUsers"
        default:
            return Observable<R.ResponseType>.error(APIError.serialization)
        }
        guard let results: R.ResponseType = decodeJSONFile(named: stubResponseFileName)
            else { return Observable<R.ResponseType>.error(APIError.serialization) }
        return Observable.just(results)
    }
}

func decodeJSONFile<T: Codable>(named fileName: String) -> T? {
    let path = Bundle.main.path(forResource: fileName, ofType: "json")!
    guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else { return nil }
    return try? JSONDecoder().decode(T.self, from: data)
}
