//
//  Bootstrapper.swift
//  Github Trends
//
//  Created by Samuel Tremblay on 2018-01-21.
//  Copyright © 2018 Samuel Tremblay. All rights reserved.
//

import Foundation
import Swinject

struct Bootstrapper {
    static let sharedInstance = Bootstrapper()
    private(set) var container = Container()
    
    init() {
    
        container.register(APIServiceProtocol.self) { _ in APIService() } .inObjectScope(.container)
        container.register(RepositoryServiceProtocol.self) { _ in RepositoryService() } .inObjectScope(.container)
    }
    
    static func getContainer() -> Container {
        return Bootstrapper.sharedInstance.container
    }
}
