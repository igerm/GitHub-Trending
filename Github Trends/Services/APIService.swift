//
//  APIService.swift
//  Github Trends
//
//  Created by Samuel Tremblay on 2018-01-21.
//  Copyright © 2018 Samuel Tremblay. All rights reserved.
//

import Alamofire

protocol APIServiceProtocol {

    /// Create a data request corresponding to the given URLRequestConvertible object
    ///
    /// - Parameter urlRequestconvertible: URLRequestConvertible object for the request
    /// - Returns: Resulting data request object (JSON data request)
    func dataRequest(for urlRequestconvertible: URLRequestConvertible) -> DataRequest
}

/// Adapt any outgoing request to protected endpoints to carry the auth token
final class AccessTokenAdapter: RequestAdapter {
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        //THIS IS TEMPORARY - this token only allows to browse public repositories
        let token = "token \(Bundle.gitHubPersonalTokenString)"
        urlRequest.setValue(token, forHTTPHeaderField: "Authorization")
        
        return urlRequest
    }
}

final class APIService: APIServiceProtocol {

    private let sessionManager: SessionManager = {
        let configuration: URLSessionConfiguration = .default
        configuration.httpAdditionalHeaders = SessionManager.defaultHTTPHeaders
        
        let sessionManager = SessionManager(configuration: configuration)
        sessionManager.adapter = AccessTokenAdapter()
        return sessionManager
    }()
}

internal extension APIService {

    func dataRequest(for urlRequestconvertible: URLRequestConvertible) -> DataRequest {
        sessionManager.request(urlRequestconvertible)
    }
}
