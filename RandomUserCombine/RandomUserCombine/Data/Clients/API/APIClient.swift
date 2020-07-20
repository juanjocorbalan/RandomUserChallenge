//
//  APIClient.swift
//  RandomUserCombine
//
//  Created by Juanjo Corbalán on 06/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation
import Combine

struct APIClientConstants {
    static let retries = 3
    static let timeout = DispatchTimeInterval.seconds(15)
}

enum APIError: Error {
    case error(String)
    case serialization
    case unauthorized
    case serverError
    case unknown
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol ResourceType {
    associatedtype ResponseType: Codable
    var url: URL { get set }
    var parameters: [String: String]? { get set }
    var method: HTTPMethod { get }
    
    init(url: URL, parameters: [String: String]?, method: HTTPMethod)
}

struct Resource<T: Codable>: ResourceType {
    typealias ResponseType = T
    public var url: URL
    public var parameters: [String: String]?
    public var method: HTTPMethod
    
    public init(url: URL, parameters: [String: String]? = nil, method: HTTPMethod) {
        self.url = url
        self.parameters = parameters
        self.method = method
    }
}

class APIClient {
    
    private var configuration: URLSessionConfiguration
    
    init(configuration: URLSessionConfiguration = .default) {
        self.configuration = configuration
        self.configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
        self.configuration.urlCache = nil
    }
    
    func execute<R: ResourceType>(_ resource: R) -> AnyPublisher<R.ResponseType, APIError> {
        return request(resource)
            .decode(type: R.ResponseType.self, decoder: JSONDecoder())
            .mapError { error in
                if let _ = error as? DecodingError {
                    return APIError.serialization
                } else if let error = error as? APIError{
                    return error
                }
                return .unknown
            }
            .eraseToAnyPublisher()
        }
    }
    
    // MARK: - Request
    
    private func request<R: ResourceType>(_ resource: R) -> AnyPublisher<Data, APIError> {
        
        var url = resource.url
        if let parametersJSON = resource.parameters {
            var components = URLComponents(string: resource.url.absoluteString)
            components?.queryItems = parametersJSON.map { URLQueryItem(name: $0.0, value: $0.1) }
            if let componentsUrl = components?.url {
                url = componentsUrl
            }
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = resource.method.rawValue
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        return session.dataTaskPublisher(for: request)
            .retry(APIClientConstants.retries)
            .map { $0.data }
            .mapError { error -> APIError in
                switch error.code.rawValue {
                case 401:
                    return .unauthorized
                case 500...599:
                    return .serverError
                default:
                    return .unknown
                }
            }
            .eraseToAnyPublisher()
}
