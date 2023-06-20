//
//  ImageCache.swift
//  OffersIbotta
//
//  Created by Mariia on 6/20/23.
//

import UIKit

protocol OfferImagesStorage {
    func getImage(for key: String) -> UIImage?
    func setImage(_ image: UIImage, for key: String)
    func removeImage(for key: String)
    func removeAllImages()
}


final class ImageCache: OfferImagesStorage {
    
    private let cache = NSCache<NSString, UIImage>()
    private let lock = NSRecursiveLock()

    func getImage(for key: String) -> UIImage? {
        lock.lock()
        defer { lock.unlock() }

        return cache.object(forKey: key as NSString)
    }

    func setImage(_ image: UIImage, for key: String) {
        lock.lock()
        defer { lock.unlock() }

        cache.setObject(image, forKey: key as NSString)
    }

    func removeImage(for key: String) {
        lock.lock()
        defer { lock.unlock() }

        cache.removeObject(forKey: key as NSString)
    }

    func removeAllImages() {
        lock.lock()
        defer { lock.unlock() }

        cache.removeAllObjects()
    }
}
