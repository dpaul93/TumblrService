//
//  StoryboardExtensions.swift
//  TumblrService
//
//  Created by Pavlo Deineha on 9/4/18.
//  Copyright © 2018 Pavlo Deynega. All rights reserved.
//

import UIKit

extension UIStoryboard {
    enum ViewController: String {
        case post = "PostViewController"
        case photo = "PhotoViewController"
    }
    
    static func main() -> UIStoryboard {
        return UIStoryboard.init(name: "Main", bundle: nil)
    }
    
    static func instantiateViewController(type: ViewController) -> UIViewController? {
        return main().instantiateViewController(withIdentifier: type.rawValue)
    }
}
