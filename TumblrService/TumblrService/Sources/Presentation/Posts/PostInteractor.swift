//
//  PostInteractor.swift
//  TumblrService
//
//  Created by Pavlo Deineha on 9/4/18.
//  Copyright © 2018 Pavlo Deineha. All rights reserved.
//

import Foundation
import Result
import SwiftyJSON

// MARK: - Protocol

protocol PostInteractor: class {
    func searchPosts(with text: String, completion: @escaping (Result<[PostDTO], ContentError>) -> ())
    func loadImage(with url: String, completion: @escaping (UIImage?) -> ())
    func getScaledImage(with url: String) -> UIImage?
    func getOriginalImage(with url: String) -> UIImage?
    func imageURL(with id: Int, element: Int) -> String?
}

// MARK: - Implementation

private final class PostInteractorImpl: PostInteractor {
    private let apiService: ApiService
    private let mapper: AnyGenericArrayMapper<PostDTO>
    private let imageService: ImageService
    
    private var posts = [PostDTO]()
    
    init(
        apiService: ApiService,
        mapper: AnyGenericArrayMapper<PostDTO>,
        imageService: ImageService
    ) {
        self.apiService = apiService
        self.mapper = mapper
        self.imageService = imageService
    }
    
    // MARK: - PostInteractor
    
    func searchPosts(with text: String, completion: @escaping (Result<[PostDTO], ContentError>) -> ()) {
        reset()
        
        let token = TumblrApiToken.searchPosts(tag: text)
        apiService.request(with: token) { [weak self] result in
            switch result {
            case .success(let data):
                let json = JSON(data)
                if let posts = self?.mapper.mapArrayFromJSON(json) {
                    self?.posts += posts
                    completion(.success(posts))
                } else {
                    completion(.failure(.noContentPresent))
                }
            case .failure: completion(.failure(.serverError))
            }
        }
    }

    func loadImage(with url: String, completion: @escaping (UIImage?) -> ()) {
        let size = 300
        imageService.loadImage(with: url, scaledToSize: CGSize(width: size, height: size), completion: completion)
    }
    
    func reset() {
        posts.removeAll()
        imageService.stopTasks()
    }
    
    func getScaledImage(with url: String) -> UIImage? {
        return imageService.cachedImage(with: url, identifier: .scaled)
    }
    
    func getOriginalImage(with url: String) -> UIImage? {
        return imageService.cachedImage(with: url, identifier: .original)
    }
    
    func imageURL(with id: Int, element: Int) -> String? {
        guard let index = posts.index(where: { $0.id == id }) else { return nil }
        return posts[safe: index]?.photos[safe: element]?.url
    }
}

// MARK: - Factory

final class PostInteractorFactory {
    static func `default`(
        apiService: ApiService = ApiServiceFactory.default(),
        mapper: AnyGenericArrayMapper<PostDTO> = PostDTOMapperFactory.default(),
        imageService: ImageService = ImageServiceFactory.default()
    ) -> PostInteractor {
        return PostInteractorImpl(
            apiService: apiService,
            mapper: mapper,
            imageService: imageService
        )
    }
}
