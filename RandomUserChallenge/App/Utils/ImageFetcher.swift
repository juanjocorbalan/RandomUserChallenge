//
//  ImageFetcher.swift
//  RandomUserChallenge
//
//  Created by Juanjo Corbalán on 07/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

final class ImageFetcher {
    
    static let shared = ImageFetcher()
    
    private let cache: ImageCacheType
    
    private lazy var backgroundQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 6
        return queue
    }()
    
    init(cache: ImageCacheType = ImageCache()) {
        self.cache = cache
    }
    
    func fetchImage(from url: URL, for id: String) -> Observable<UIImage?> {
        
        return Observable.create { [weak self] observer in
            
            if let image = self?.cache[NSString(string: url.absoluteString + id)] {
                observer.onNext(image)
                observer.onCompleted()
            }

            let task = URLSession.shared.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in
                guard let data = data, error == nil else {
                    observer.onNext(nil)
                    observer.onCompleted()
                    return
                }
                observer.onNext(UIImage(data: data))
                observer.onCompleted()
            })
            task.resume()
            return Disposables.create(with: { task.cancel() })
        }
        .do(onNext: { [weak self] image in
            self?.cache[NSString(string: url.absoluteString + id)] = image
        })
        .subscribeOn(OperationQueueScheduler.init(operationQueue: backgroundQueue))
        .observeOn(MainScheduler.instance)
    }
}
