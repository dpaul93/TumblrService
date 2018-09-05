//
//  ApiToken.swift
//  TumblrService
//
//  Created by Pavlo Deineha on 9/4/18.
//  Copyright © 2018 Pavlo Deineha. All rights reserved.
//

import Foundation
import Alamofire

enum Method: String {
    case post = "POST"
    case put = "PUT"
    case get = "GET"
    
    func httpMethod() -> HTTPMethod {
        switch self {
        case .post: return .post
        case .get: return .get
        case .put: return .put
        }
    }
}

enum Encoding {
    case json
    case url
    
    func parameterEncoding() -> ParameterEncoding {
        switch self {
        case .json: return JSONEncoding.default
        case .url: return URLEncoding.default
        }
    }
}

protocol ApiToken {
    var baseUrl: String { get }
    var parameters: [String: Any] { get }
    var path: String { get }
    var method: Method { get }
    var encoding: Encoding { get }
    var headers: [String: String] { get }
}

enum TumblrApiToken {
    case searchPosts(tag: String)
}

extension TumblrApiToken: Equatable {
    static func == (lhs: TumblrApiToken, rhs: TumblrApiToken) -> Bool {
        switch (lhs, rhs) {
        case (.searchPosts(let lTag), .searchPosts(let rTag)): return lTag == rTag
        }
    }
}

extension TumblrApiToken: ApiToken {
    var baseUrl: String {
        switch self {
        default: return "http://api.tumblr.com"
        }
    }
    
    var parameters: [String : Any] {
        var params = [String: Any]()
        switch self {
        case .searchPosts(let tag): params = ["tag": tag]
        }
        
        // TODO: handle from external service like storage
        params["api_key"] = "CcEqqSrYdQ5qTHFWssSMof4tPZ89sfx6AXYNQ4eoXHMgPJE03U"
        
        return params
    }
    
    var path: String {
        switch self {
        case .searchPosts: return "/v2/tagged"
        }
    }

    var method: Method {
        switch self {
        case .searchPosts: return .get
        }
    }
    
    var encoding: Encoding {
        switch self {
        default: return .url
        }
    }
    
    var headers: [String : String] {
        switch self {
        default: return [:]
        }
    }
}
