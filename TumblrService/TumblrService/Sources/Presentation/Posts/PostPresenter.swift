//
//  PostPresenter.swift
//  TumblrService
//
//  Created by Pavlo Deineha on 9/4/18.
//  Copyright © 2018 Pavlo Deineha. All rights reserved.
//

import Foundation
import Result

// MARK: - Output

protocol PostPresenterOutput: class {
    func handleDataUpdate()
    func handleItemUpdate(at row: Int, element: Int)
}

// MARK: - Protocol

protocol PostPresenter: class {
    var output: PostPresenterOutput? { get set }
    var models: [PostTableViewCellModel] { get }

    func handleSearchText(_ text: String)
    func handleSearch()
    func handleItemSelect(with id: Int, atIndexPath indexPath: IndexPath)
}

// MARK: - Implementation

private final class PostPresenterImpl: PostPresenter {
    private let interactor: PostInteractor
    private let router: PostRouter
    weak var output: PostPresenterOutput?

    private var searchText = ""
    var models = [PostTableViewCellModel]()

    init(
        interactor: PostInteractor,
        router: PostRouter
    ) {
        self.interactor = interactor
        self.router = router
    }
    
    // MARK: - PostPresenter
    
    func handleSearchText(_ text: String) {
        searchText = text
    }
    
    func handleSearch() {
        models.removeAll()
        output?.handleDataUpdate()
        
        interactor.searchPosts(with: searchText) { [weak self] result in
            switch result {
            case .success(let postsDTO):
                let models: [PostTableViewCellModel] = postsDTO.enumerated().compactMap { dtoTuple in
                    let photos: [ImageCollectionViewCellModel] = dtoTuple.element.photos.enumerated().compactMap {
                        let image = self?.interactor.getScaledImage(with: $0.element.url)
                        if image == nil {
                            self?.loadImage(with: dtoTuple.offset, element: $0.offset, url: $0.element.url)
                        }
                        return ImageCollectionViewCellModel(image: image)
                    }
                    let model = PostTableViewCellModel(blogName: dtoTuple.element.blogName, summary: dtoTuple.element.summary, photos: photos, id: dtoTuple.element.id)
                    return model
                }
                self?.models += models
                self?.output?.handleDataUpdate()
            case .failure: // TODO: Add error handling
                self?.output?.handleDataUpdate()
            }
        }
    }
    
    func loadImage(with row: Int, element: Int, url: String) {
        interactor.loadImage(with: url) { [weak self] image in
            if let image = image {
                self?.models[safe: row]?.photos[safe: element]?.image = image
                self?.output?.handleItemUpdate(at: row, element: element)
            }
        }
    }
    
    func handleItemSelect(with id: Int, atIndexPath indexPath: IndexPath) {
        guard let url = interactor.imageURL(with: id, element: indexPath.row) else { return }
        router.routeToImage(with: url)
    }
}

// MARK: - Factory

final class PostPresenterFactory {
    static func `default`(
        interactor: PostInteractor = PostInteractorFactory.default(),
        router: PostRouter
    ) -> PostPresenter {
        let presenter = PostPresenterImpl(
            interactor: interactor,
            router: router
        )
        return presenter
    }
}
