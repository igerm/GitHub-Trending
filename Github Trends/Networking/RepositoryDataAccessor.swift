//
//  RepositoryDataAccessor.swift
//  Github Trends
//
//  Created by Samuel Tremblay on 2020-11-10.
//  Copyright © 2020 Samuel Tremblay. All rights reserved.
//

enum RepositoryDataAccessor: DataAccessRequestConvertible {

    case getAll
    case getReadme(repository: Repository)
    case getRepositoryDetails(name: String)

    var remoteDataAccessor: RemoteDataAccessor {
        switch self {
            case .getAll:
                return RepositoryRouter.getAll
            case .getReadme(let repository):
                return RepositoryRouter.getReadme(repository: repository)
            case .getRepositoryDetails(let name):
                return RepositoryRouter.getRepositoryDetails(name: name)
        }
    }

    var localDataAccessor: LocalDataAccessor {
        switch self {
        case .getAll:
            return (object: nil, id: nil, filter: nil, propertySortKey: nil, ascending: true)
        case .getReadme(let repository):
            return (object: repository, id: nil, filter: nil, propertySortKey: nil, ascending: true)
        case .getRepositoryDetails:
            return (object: nil, id: nil, filter: nil, propertySortKey: nil, ascending: true)
        }
    }
}
