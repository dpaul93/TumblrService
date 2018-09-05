//
//  AppDelegateRouter.swift
//  TumblrService
//
//  Created by Pavlo Deineha on 9/5/18.
//  Copyright © 2018 Pavlo Deineha. All rights reserved.
//

import UIKit

// MARK: Protocol

protocol AppDelegateRouter {
    func routeToPosts()
}

// MARK: Implementation

private final class AppDelegateRouterImpl: AppDelegateRouter {
    private let window: UIWindow
    
    init(window: UIWindow) {
        self.window = window
    }
    
    // MARK: - AppDelegateRouter
    
    func routeToPosts() {
        guard let navController = window.rootViewController as? UINavigationController else { return }
        navController.setNavigationBarHidden(true, animated: false)
        let router = PostRouterFactory.default(navigationController: navController)
        let presenter = PostPresenterFactory.default(router: router)
        let controller = PostViewControllerFactory.new(presenter: presenter)
        navController.setViewControllers([controller], animated: false)
    }
}

// MARK: Factory

class AppDelegateRouterFactory {
    static func `default`(window: UIWindow) -> AppDelegateRouter {
        return AppDelegateRouterImpl(window: window)
    }
}
