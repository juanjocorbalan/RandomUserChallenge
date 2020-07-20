//
//  ImageFetcher.swift
//  RandomUserCombine
//
//  Created by Juanjo Corbalán on 07/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation
import UIKit
import Combine

final class ImageFetcher {
    
    public static let shared = ImageFetcher()
    
    private let cache: ImageCacheType
    
    private lazy var backgroundQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 5
        return queue
    }()
    
    public init(cache: ImageCacheType = ImageCache()) {
        self.cache = cache
    }
    
    func fetchImage(from url: URL, for id: String) -> AnyPublisher<UIImage?, Never> {
        if let image = cache[NSString(string: url.absoluteString + id)] {
            return Just(image).eraseToAnyPublisher()
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { (data, response) -> UIImage? in return UIImage(data: data) }
            .catch { error in return Just(nil) }
            .handleEvents(receiveOutput: {[unowned self] image in
                guard let image = image else { return }
                self.cache[NSString(string: url.absoluteString + id)] = image
            })
            .subscribe(on: backgroundQueue)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
