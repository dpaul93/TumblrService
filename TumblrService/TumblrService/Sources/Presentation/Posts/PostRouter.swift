//
//  PostRouter.swift
//  TumblrService
//
//  Created by Pavlo Deineha on 9/4/18.
//  Copyright © 2018 Pavlo Deineha. All rights reserved.
//

import UIKit

// MARK: - Protocol

protocol PostRouter {
    func routeToImage(with url: String)
}

// MARK: - Implementation

private final class PostRouterImpl: NavigationRouter, PostRouter {
    func routeToImage(with url: String) {
        let router = PhotoRouterFactory.default(navigationController: navigationController)
        let interactor = PhotoInteractorFactory.default(url: url)
        let presenter = PhotoPresenterFactory.default(interactor: interactor, router: router)
        let controller = PhotoViewControllerFactory.new(presenter: presenter)
        navigationController.pushViewController(controller, animated: true)
    }
}

// MARK: - Factory

final class PostRouterFactory {
    static func `default`(navigationController: UINavigationController) -> PostRouter {
        return PostRouterImpl(with: navigationController)
    }
}
