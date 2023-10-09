//
//  ImageCache.swift
//  RandomUserChallenge
//
//  Created by Juanjo Corbalán on 07/07/2020.
//  Copyright © 2020 Juanjo Corbalán. All rights reserved.
//

import Foundation
import UIKit

protocol ImageCacheType: AnyObject {
    func image(for key: NSString) -> UIImage?
    func insertImage(_ image: UIImage?, for key: NSString)
    func removeImage(for key: NSString)
    func removeAllImages()
    subscript(_ key: NSString) -> UIImage? { get set }
}

final class ImageCache: ImageCacheType {

    private lazy var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = settings.countLimit
        return cache
    }()

    private let lock = NSLock()
    private let settings: CacheSettings

    struct CacheSettings {
        let countLimit: Int

        static let defaultSettings = CacheSettings(countLimit: 50)
    }

    init(settings: CacheSettings = CacheSettings.defaultSettings) {
        self.settings = settings
    }

    func image(for key: NSString) -> UIImage? {
        lock.lock(); defer { lock.unlock() }
        return imageCache.object(forKey: key)
    }

    func insertImage(_ image: UIImage?, for key: NSString) {
        guard let image = image else { return removeImage(for: key) }
        lock.lock(); defer { lock.unlock() }
        imageCache.setObject(image, forKey: key, cost: 1)
    }

    func removeImage(for key: NSString) {
        lock.lock(); defer { lock.unlock() }
        imageCache.removeObject(forKey: key)
    }

    func removeAllImages() {
        lock.lock(); defer { lock.unlock() }
        imageCache.removeAllObjects()
    }

    subscript(_ key: NSString) -> UIImage? {
        get { return image(for: key) }
        set { return insertImage(newValue, for: key) }
    }
}
