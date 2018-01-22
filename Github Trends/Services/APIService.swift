//
//  APIService.swift
//  Github Trends
//
//  Created by Samuel Tremblay on 2018-01-21.
//  Copyright © 2018 Samuel Tremblay. All rights reserved.
//

import Alamofire
import ObjectMapper

enum APIResult<T> {
    case success(T)
    case failure(error:Error)
}

protocol APIServiceProtocol {
    
    func dataRequest(forUrlRequestConvertible urlRequestconvertible: URLRequestConvertible) -> DataRequest
}

/// Adapt any outgoing request to protected endpoints to carry the auth token
class AccessTokenAdapter: RequestAdapter {
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        //THIS IS TEMPORARY - this token only allows to browse public repositories
        let token = "token 7585a27810f67f7ed54f05a28679290a8854e498"
        urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
        
        return urlRequest
    }
}

final class APIService: APIServiceProtocol {
    
    //MARK: - Set up
    let sessionManager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        let sessionManager = SessionManager(configuration: configuration)
        sessionManager.adapter = AccessTokenAdapter()
        return sessionManager
    }()
    
    /// Create a data request corresponding to the given URLRequestConvertible object
    ///
    /// - Parameter urlRequestconvertible: URLRequestConvertible object for the request
    /// - Returns: Resulting data request object (JSON data request)
    internal func dataRequest(forUrlRequestConvertible urlRequestconvertible: URLRequestConvertible) -> DataRequest {
        
        let request = sessionManager.request(urlRequestconvertible)
        
        return request
    }
}
