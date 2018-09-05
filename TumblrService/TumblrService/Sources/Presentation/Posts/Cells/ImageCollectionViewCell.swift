//
//  ImageCollectionViewCell.swift
//  TumblrService
//
//  Created by Pavlo Deineha on 9/4/18.
//  Copyright © 2018 Pavlo Deineha. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var photoImageView: UIImageView!
}

extension ImageCollectionViewCell {
    func populate(with model: ImageCollectionViewCellModel) {
        photoImageView.image = model.image
    }
}
