//
//  ApiService.swift
//  TumblrService
//
//  Created by Pavlo Deineha on 9/4/18.
//  Copyright © 2018 Pavlo Deineha. All rights reserved.
//

import Foundation
import Alamofire
import Result

enum ClientApiErrors: Error, Equatable {
    case internalServerError
    case internalError
    case inProgress
}

func == (lhs: ClientApiErrors, rhs: ClientApiErrors) -> Bool {
    switch (lhs, rhs) {
    case (.internalServerError, .internalServerError): return true
    case (.internalError, .internalError): return true
    case (.inProgress, .inProgress): return true
    default: return false
    }
}

protocol ApiService {
    @discardableResult func request(with token: ApiToken, completion: @escaping (ApiResponse) -> Void) -> DataRequest?
    func isRequestInProgress(with token: ApiToken) -> Bool
}

private class ApiServiceImpl: ApiService {
    private let sessionManager: SessionManager
    private var currentTasks = [DataRequest]()

    init(sessionManager: SessionManager) {
        self.sessionManager = sessionManager
    }

    // MARK: - ApiService
    
    func request(with token: ApiToken, completion: @escaping (ApiResponse) -> Void) -> DataRequest? {
        guard !isRequestInProgress(with: token) else {
            completion(ApiResponse.failure(ClientApiErrors.inProgress))
            return nil
        }
        
        let headers = token.headers
        let url = token.baseUrl + token.path
        let method = token.method.httpMethod()
        let parameters = token.parameters
        let encoding = token.encoding.parameterEncoding()
        let request = sessionManager.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers.count >= 1 ? headers : nil)
        currentTasks.append(request)
        request.responseData { [weak self] response in
            guard let strongSelf = self else {
                completion(ApiResponse.failure(ClientApiErrors.internalError))
                return
            }
            if let index = strongSelf.currentTasks.index(where: { $0.request?.url?.absoluteString == url }) {
                strongSelf.currentTasks.remove(at: index)
            }
            strongSelf.createApiResponse(response: response, completion: completion)
        }
        
        return request
    }
    
    func isRequestInProgress(with token: ApiToken) -> Bool {
        let url = token.baseUrl + token.path
        
        return currentTasks.index(where: { $0.request?.url?.absoluteString == url }) != nil
    }
    
    private func createApiResponse(response: DataResponse<Data>, completion: @escaping (ApiResponse) -> Void) {
        switch response.result {
        case .success(let value):
            if response.response == nil {
                completion(.failure(ClientApiErrors.internalServerError))
                return
            } else {
                completion(.success(value))
            }
        case .failure(let error):
            completion(.failure(error))
        }
    }
}

class ApiServiceFactory {
    static func `default`(sessionManager: SessionManager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)) -> ApiService {
        return ApiServiceImpl(sessionManager: sessionManager)
    }
}
