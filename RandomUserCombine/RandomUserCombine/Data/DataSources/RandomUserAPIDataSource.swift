//
//  RandomUserAPIDataSource.swift
//  RandomUserCombine
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation
import Combine

protocol RandomUserAPIDataSourceType {
    func getUsers() -> AnyPublisher<[RandomUser], Error>
}

class RandomUserAPIDataSource: RandomUserAPIDataSourceType {
    
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getUsers() -> AnyPublisher<[RandomUser], Error> {
        
        let url = RandomUserAPI.baseURL.appendingPathComponent(RandomUserAPI.paths.users)
        
        let resource = Resource<[RandomUserDTO]>(url: url, parameters: nil, method: HTTPMethod.get)
        
        return apiClient.execute(resource)
            .map { $0.toDomain() }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
        
    }
}
