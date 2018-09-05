//
//  PostDTO.swift
//  TumblrService
//
//  Created by Pavlo Deineha on 9/4/18.
//  Copyright © 2018 Pavlo Deineha. All rights reserved.
//

import Foundation

struct PostDTO {
    let postURL: String
    let blogName: String
    let summary: String
    let photos: [ImageDTO]
    let id: Int
}
