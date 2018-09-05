//
//  UserDTOMapper.swift
//  TumblrService
//
//  Created by Pavlo Deineha on 9/4/18.
//  Copyright © 2018 Pavlo Deineha. All rights reserved.
//

import Foundation
import SwiftyJSON

// MARK: - Implementation

private final class UserDTOMapper: GenericArrayMapper {
    func mapFromJSON(_ json: JSON) -> UserDTO? {
        guard
            let id = json["id"].int,
            let name = json["login"].string,
            let profilePicURL = json["avatar_url"].string,
            let profileURL = json["html_url"].string,
            let followersURL = json["followers_url"].string
        else { return nil }
        
        return UserDTO(id: id, profilePicURL: profilePicURL, name: name, profileURL: profileURL, followersURL: followersURL)
    }
    
    func mapArrayFromJSON(_ json: JSON) -> [UserDTO] {
        return json.arrayValue.enumerated().flatMap { mapFromJSON($0.element) }
    }
}

// MARK: - Factory

class UserDTOMapperFactory {
    static func `default`() -> AnyGenericArrayMapper<UserDTO> {
        return AnyGenericArrayMapper(UserDTOMapper())
    }
}
