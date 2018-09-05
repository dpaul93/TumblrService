//
//  PhotoViewController.swift
//  TumblrService
//
//  Created by Pavlo Deineha on 9/5/18.
//  Copyright © 2018 Pavlo Deineha. All rights reserved.
//

import UIKit

// MARK: - Implementation

class PhotoViewController: UIViewController, PhotoPresenterOutput {
    fileprivate var presenter: PhotoPresenter!
    @IBOutlet private weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoImageView.image = presenter.getImage()
    }
    
    // MARK: - Actions
    
    @IBAction func backButtonTapped(_ sender: Any) {
        presenter.handleBack()
    }
}

// MARK: - Factory

final class PhotoViewControllerFactory {
    static func new(presenter: PhotoPresenter) -> PhotoViewController {
        let controller = UIStoryboard.instantiateViewController(type: .photo) as! PhotoViewController
        controller.presenter = presenter
        presenter.output = controller
        return controller
    }
}
