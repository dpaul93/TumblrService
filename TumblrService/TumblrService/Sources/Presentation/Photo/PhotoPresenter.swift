//
//  PhotoPresenter.swift
//  TumblrService
//
//  Created by Pavlo Deineha on 9/5/18.
//  Copyright © 2018 Pavlo Deineha. All rights reserved.
//

import UIKit

// MARK: - Output

protocol PhotoPresenterOutput: class {}

// MARK: - Protocol

protocol PhotoPresenter: class {
    var output: PhotoPresenterOutput? { get set }

    func getImage() -> UIImage?
    func handleBack()
}

// MARK: - Implementation

private final class PhotoPresenterImpl: PhotoPresenter {
    private let interactor: PhotoInteractor
    private let router: PhotoRouter
    weak var output: PhotoPresenterOutput?

    init(
        interactor: PhotoInteractor,
        router: PhotoRouter
    ) {
        self.interactor = interactor
        self.router = router
    }

    // MARK: - PhotoPresenter
    
    func getImage() -> UIImage? {
        return interactor.getImage()
    }
    
    func handleBack() {
        router.routeBack()
    }
}

// MARK: - Factory

final class PhotoPresenterFactory {
    static func `default`(
        interactor: PhotoInteractor,
        router: PhotoRouter
    ) -> PhotoPresenter {
        let presenter = PhotoPresenterImpl(
            interactor: interactor,
            router: router
        )
        return presenter
    }
}
