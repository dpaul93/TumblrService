//
//  PhotoInteractor.swift
//  TumblrService
//
//  Created by Pavlo Deineha on 9/5/18.
//  Copyright © 2018 Pavlo Deineha. All rights reserved.
//

import UIKit

// MARK: - Protocol

protocol PhotoInteractor: class {
    func getImage() -> UIImage?
}

// MARK: - Implementation

private final class PhotoInteractorImpl: PhotoInteractor {
    private let url: String
    private let imageService: ImageService

    init(
        url: String,
        imageService: ImageService
    ) {
        self.url = url
        self.imageService = imageService
    }
    
    // MARK: - PhotoInteractor
    
    func getImage() -> UIImage? {
        return imageService.cachedImage(with: url, identifier: .original)
    }
}

// MARK: - Factory

final class PhotoInteractorFactory {
    static func `default`(
        url: String,
        imageService: ImageService = ImageServiceFactory.default()
    ) -> PhotoInteractor {
        return PhotoInteractorImpl(
            url: url,
            imageService: imageService
        )
    }
}
