//
//  PhotoRouter.swift
//  TumblrService
//
//  Created by Pavlo Deineha on 9/5/18.
//  Copyright © 2018 Pavlo Deineha. All rights reserved.
//

import UIKit

// MARK: - Protocol

protocol PhotoRouter {
    func routeBack()
}

// MARK: - Implementation

private final class PhotoRouterImpl: NavigationRouter, PhotoRouter {
    func routeBack() {
        navigationController.popViewController(animated: true)
    }
}

// MARK: - Factory

final class PhotoRouterFactory {
    static func `default`(navigationController: UINavigationController) -> PhotoRouter {
        return PhotoRouterImpl(with: navigationController)
    }
}
