//
//  ImageDTOMapper.swift
//  TumblrService
//
//  Created by Pavlo Deineha on 9/4/18.
//  Copyright © 2018 Pavlo Deineha. All rights reserved.
//

import Foundation
import SwiftyJSON

// MARK: - Implementation

private final class ImageDTOMapper: GenericArrayMapper {
    func mapFromJSON(_ json: JSON) -> ImageDTO? {
        let originalSize = json["original_size"]
        
        guard
            let url = originalSize["url"].string,
            let width = originalSize["width"].int,
            let height = originalSize["height"].int
        else { return nil }
        
        return ImageDTO(url: url, width: width, height: height)
    }
    
    func mapArrayFromJSON(_ json: JSON) -> [ImageDTO] {
        return json.arrayValue.enumerated().compactMap { mapFromJSON($0.element) }
    }
}

// MARK: - Factory

class ImageDTOMapperFactory {
    static func `default`() -> AnyGenericArrayMapper<ImageDTO> {
        return AnyGenericArrayMapper(ImageDTOMapper())
    }
}
