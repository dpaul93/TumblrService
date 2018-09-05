//
//  ViewExtensions.swift
//  TumblrService
//
//  Created by Pavlo Deineha on 9/4/18.
//  Copyright © 2018 Pavlo Deineha. All rights reserved.
//

import UIKit

extension UIView {
    static func nib() -> UINib {
        return UINib(nibName: self.className, bundle: nil)
    }
    
    static func reuseIdentifier() -> String {
        return className
    }
}
