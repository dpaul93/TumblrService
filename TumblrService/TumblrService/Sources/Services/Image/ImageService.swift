//
//  ImageService.swift
//  TumblrService
//
//  Created by Pavlo Deineha on 9/5/18.
//  Copyright © 2018 Pavlo Deineha. All rights reserved.
//

import Foundation
//import AlamofireImage
import Kingfisher

enum ImageIdentifier: String {
    case original
    case scaled
}

// MARK: - Protocol

protocol ImageService {
    func loadImage(with url: String, completion: @escaping (Image?) -> ())
    func loadImage(with url: String, scaledToSize scaleSize: CGSize,  completion: @escaping (Image?) -> ())
    func cachedImage(with url: String, identifier: ImageIdentifier) -> UIImage?
    func stopTasks()
}

// MARK: - Implementation

private final class ImageServiceImpl: ImageService {
    private let imageCache: ImageCache
    private let imageDownloader: ImageDownloader
    
    init(
        imageCache: ImageCache,
        imageDownloader: ImageDownloader
    ) {
        self.imageCache = imageCache
        self.imageDownloader = imageDownloader
    }
    
    // MARK: - ImageService
    
    func stopTasks() {
        imageDownloader.cancelAll()
    }
    
    func loadImage(with url: String, completion: @escaping (Image?) -> ()) {
        guard let imageURL = URL(string: url) else {
            completion(nil)
            return
        }
        imageDownloader.downloadImage(with: imageURL) { [weak self] (image, _, _, _) in
            if let image = image {
                self?.saveImage(image, url: url, identifier: .original)
                completion(image)
            } else {
                completion(nil)
            }
        }
    }
    
    func loadImage(with url: String, scaledToSize scaleSize: CGSize, completion: @escaping (Image?) -> ()) {
        guard let imageURL = URL(string: url) else {
            completion(nil)
            return
        }
        imageDownloader.downloadImage(with: imageURL) { [weak self] (image, _, _, _) in
            if let image = image {
                self?.saveImage(image, url: url, identifier: .original)
                self?.scaleImage(image, scale: scaleSize, forURL: url) {
                    completion($0)
                }
            } else {
                completion(nil)
            }
        }
    }
    
    func cachedImage(with url: String, identifier: ImageIdentifier) -> UIImage? {
        return getImage(with: url, identifier: identifier)
    }
    
    // MARK: - Helpers
    
    func scaleImage(_ image: UIImage, scale: CGSize, forURL url: String, completion: @escaping (UIImage) -> ()) {
        DispatchQueue.global().async { [weak self] in
            let scaled = image.kf.resize(to: scale)
            DispatchQueue.main.async {
                self?.saveImage(scaled, url: url, identifier: .scaled)
                completion(scaled)
            }
        }
    }
    
    func saveImage(_ image: UIImage, url: String, identifier: ImageIdentifier) {
        let uniqueIdentifier = imageIdentifier(from: url, identifier: identifier)
        imageCache.store(image, forKey: uniqueIdentifier, toDisk: true)
    }
    
    func getImage(with url: String, identifier: ImageIdentifier) -> UIImage? {
        let uniqueIdentifier = imageIdentifier(from: url, identifier: identifier)
        return imageCache.retrieveImageInMemoryCache(forKey: uniqueIdentifier) ?? imageCache.retrieveImageInDiskCache(forKey: uniqueIdentifier)
    }

    func imageIdentifier(from url: String, identifier: ImageIdentifier) -> String {
        let url = URL(string: url)?.deletingLastPathComponent().absoluteString ?? url
        return url + "_" + identifier.rawValue
    }
}

// MARK: - Factory

class ImageServiceFactory {
    static func `default`(
        imageCache: ImageCache = KingfisherManager.shared.cache,
        imageDownloader: ImageDownloader = KingfisherManager.shared.downloader
    ) -> ImageService {
        return ImageServiceImpl(
            imageCache: imageCache,
            imageDownloader: imageDownloader
        )
    }
}
