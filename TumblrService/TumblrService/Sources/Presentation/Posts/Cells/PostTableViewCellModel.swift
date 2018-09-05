//
//  PostTableViewCellModel.swift
//  TumblrService
//
//  Created by Pavlo Deineha on 9/4/18.
//  Copyright © 2018 Pavlo Deineha. All rights reserved.
//

import Foundation

class PostTableViewCellModel {
    let blogName: String
    let summary: String
    let photos: [ImageCollectionViewCellModel]
    let id: Int
    
    init(
        blogName: String,
        summary: String,
        photos: [ImageCollectionViewCellModel],
        id: Int
    ) {
        self.blogName = blogName
        self.summary = summary
        self.photos = photos
        self.id = id
    }
}
