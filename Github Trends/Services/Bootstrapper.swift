//
//  Bootstrapper.swift
//  Github Trends
//
//  Created by Samuel Tremblay on 2018-01-21.
//  Copyright © 2018 Samuel Tremblay. All rights reserved.
//

import Swinject

struct Bootstrapper {
    static let sharedInstance = Bootstrapper()
    private(set) var container = Container()
    
    init() {
        container.register(DatabaseServiceProtocol.self) { _ in
            DatabaseService()
        }
        container.register(APIServiceProtocol.self) { _ in
            APIService()
        }
        container.register(DataAccessServiceProtocol.self) { resolver in
            DataAccessService(databaseService: resolver.resolve(DatabaseServiceProtocol.self),
                              apiService: resolver.resolve(APIServiceProtocol.self))
        }
        container.register(TrendsTableViewController.self) { resolver in
            TrendsTableViewController(dataAccessService: resolver.resolve(DataAccessServiceProtocol.self))
        }
    }
    
    static func getContainer() -> Container {
        Bootstrapper.sharedInstance.container
    }
}
