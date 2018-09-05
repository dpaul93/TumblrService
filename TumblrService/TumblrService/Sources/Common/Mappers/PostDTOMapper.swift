//
//  PostDTOMapper.swift
//  TumblrService
//
//  Created by Pavlo Deineha on 9/4/18.
//  Copyright © 2018 Pavlo Deineha. All rights reserved.
//

import Foundation
import SwiftyJSON

// MARK: - Implementation

private final class PostDTOMapper: GenericArrayMapper {
    private let imageMapper: AnyGenericArrayMapper<ImageDTO>?
    
    init(imageMapper: AnyGenericArrayMapper<ImageDTO>?) {
        self.imageMapper = imageMapper
    }
    
    func mapFromJSON(_ json: JSON) -> PostDTO? {
        guard
            let postURL = json["post_url"].string,
            let blogName = json["blog_name"].string,
            let summary = json["summary"].string,
            let id = json["id"].int,
            let photos = imageMapper?.mapArrayFromJSON(json["photos"])
        else { return nil }
        
        return PostDTO(postURL: postURL, blogName: blogName, summary: summary, photos: photos, id: id)
    }
    
    func mapArrayFromJSON(_ json: JSON) -> [PostDTO] {
        let reponse = json["response"]
        return reponse.arrayValue.enumerated().compactMap { mapFromJSON($0.element) }
    }
}

// MARK: - Factory

class PostDTOMapperFactory {
    static func `default`(imageMapper: AnyGenericArrayMapper<ImageDTO>? = ImageDTOMapperFactory.default()) -> AnyGenericArrayMapper<PostDTO> {
        return AnyGenericArrayMapper(PostDTOMapper(imageMapper: imageMapper))
    }
}
