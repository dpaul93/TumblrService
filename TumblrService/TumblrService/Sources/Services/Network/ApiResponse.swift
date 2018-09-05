//
//  ApiResponse.swift
//  TumblrService
//
//  Created by Pavlo Deineha on 9/4/18.
//  Copyright © 2018 Pavlo Deineha. All rights reserved.
//

import Foundation

enum ApiResultErrors: Error {
    case internerConnectionError
}

enum ApiResponse {
    case success(Data)
    case failure(Error)
    
    var value: Data? {
        switch self {
        case .success(let value): return value
        case .failure: return nil
        }
    }

    var error: Error? {
        switch self {
        case .success: return nil
        case .failure(let error): return error
        }
    }
}
