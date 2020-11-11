//
//  ServiceFactory.swift
//  Github Trends
//
//  Created by Samuel Tremblay on 2018-01-21.
//  Copyright © 2018 Samuel Tremblay. All rights reserved.
//

enum ServiceFactory {
    static func resolve<Service>(serviceType: Service.Type) -> Service? {
        return Bootstrapper.getContainer().resolve(serviceType)
    }
}

// MARK: Repository Service

protocol HasRepositoryService { }
extension HasRepositoryService {
    var repositoryService: RepositoryServiceProtocol? {
        return ServiceFactory.resolve(serviceType: RepositoryServiceProtocol.self)
    }
}

// MARK: APIService

protocol HasAPIService { }
extension HasAPIService {
    var apiService: APIServiceProtocol? {
        return ServiceFactory.resolve(serviceType: APIServiceProtocol.self)
    }
}
