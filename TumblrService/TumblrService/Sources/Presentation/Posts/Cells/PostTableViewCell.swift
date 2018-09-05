//
//  PostTableViewCell.swift
//  TumblrService
//
//  Created by Pavlo Deineha on 9/4/18.
//  Copyright © 2018 Pavlo Deineha. All rights reserved.
//

import UIKit

protocol PostTableViewCellDelegate: class {
    func postCell(_ cell: PostTableViewCell, id: Int, didSelectAt indexPath: IndexPath)
}

class PostTableViewCell: UITableViewCell {
    @IBOutlet private weak var blogNameLabel: UILabel!
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    
    private var photos = [ImageCollectionViewCellModel]()
    private var id = -1
    
    weak var delegate: PostTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imagesCollectionView.register(ImageCollectionViewCell.nib(), forCellWithReuseIdentifier: ImageCollectionViewCell.reuseIdentifier())
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imagesCollectionView.reloadData()
    }
    
    func populate(with model: PostTableViewCellModel) {
        blogNameLabel.text = model.blogName
        summaryLabel.text = model.summary
        photos = model.photos
        id = model.id
    }
}

extension PostTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.reuseIdentifier(), for: indexPath) as? ImageCollectionViewCell,
            let model = photos[safe: indexPath.row]
        else { return UICollectionViewCell() }
        
        cell.populate(with: model)
        
        return cell
    }
}

extension PostTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: CGFloat = 10
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.postCell(self, id: id, didSelectAt: indexPath)
    }
}

extension PostTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let insets = self.collectionView(collectionView, layout: collectionViewLayout, insetForSectionAt: 0)
        let height = collectionView.bounds.height - insets.bottom - insets.top
        return CGSize(width: height, height: height)
    }
}
