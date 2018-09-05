//
//  CommonErrors.swift
//  TumblrService
//
//  Created by Pavlo Deineha on 9/4/18.
//  Copyright © 2018 Pavlo Deineha. All rights reserved.
//

import Foundation

enum ContentError: Error {
    case noInternetConnection
    case serverError
    case noContentPresent
}
