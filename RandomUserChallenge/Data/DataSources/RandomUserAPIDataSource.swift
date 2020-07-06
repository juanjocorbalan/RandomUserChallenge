//
//  RandomUserAPIDataSource.swift
//  RandomUserChallenge
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation
import RxSwift

protocol RandomUserAPIDataSourceType {
    func getUsers() -> Observable<[RandomUser]>
}

class RandomUserAPIDataSource: RandomUserAPIDataSourceType {
    
    private let apiClient: APIClient
    
    init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
    
    func getUsers() -> Observable<[RandomUser]> {
        
        let url = RandomUserAPI.baseURL.appendingPathComponent(RandomUserAPI.paths.users)
        
        let resource = Resource<[RandomUserDTO]>(url: url, parameters: nil, method: HTTPMethod.get)
        
        return apiClient.execute(resource).map { $0.toDomain() }
    }
}
