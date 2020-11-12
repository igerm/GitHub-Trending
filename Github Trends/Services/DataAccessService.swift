//
//  DataAccessService.swift
//  Github Trends
//
//  Created by Samuel Tremblay on 2020-11-10.
//  Copyright © 2020 Samuel Tremblay. All rights reserved.
//

import RealmSwift
import Alamofire
import AlamofireCodable

/// Service protocol definition
protocol DataAccessServiceProtocol {

    /// Generic funtion to retrieve all objects according to the given data accessor request
    ///
    /// - Parameters:
    ///   - request: The data accessor request used to retrieve the objects
    ///   - closure: Callback triggered once the objects have been retrieved. If the objects, did not previously exsist in the local db, they will now have been downloaded and saved into the db
    func getObjects<T>(request: DataAccessRequestConvertible, _ closure: ((Response<DataAccessResults<T>, DataAccessError>) -> Void)?) where T: Codable, T: Object

    /// Generic funtion to retrieve an object according to the given data accessor request
    ///
    /// - Parameters:
    ///   - request: The data accessor request used to retrieve the object
    ///   - closure: Callback triggered once the object has been retrieved. If the object, did not previously exsist in the local db, it will now have been downloaded and saved into the db
    func getObject<T>(request: DataAccessRequestConvertible, _ closure: ((Response<T, DataAccessError>) -> Void)?) where T: Codable, T: Object

    /// Generic funtion to create/update an object according to the given data accessor request
    ///
    /// - Parameters:
    ///   - request: The data accessor request used to create/update the object
    ///   - closure: Callback triggered once the object has been created/updated. If the object, did not previously exsist in the local db, it will now have been saved remotely as well as locally
    func saveObject<T>(request: DataAccessRequestConvertible, _ closure: ((Response<T, DataAccessError>) -> Void)?) where T: Codable, T: Object

    /// Delete an object according to the given data accessor request
    ///
    /// - Parameters:
    ///   - request: The data accessor request used to create/update the object
    ///   - closure: Callback triggered once the object has been deleted. The object will have been deleted remotely as well locally
    func deleteObject(request: DataAccessRequestConvertible, _ closure: ((Response<Void, DataAccessError>) -> Void)?)
}

final class DataAccessService: DataAccessServiceProtocol {

    private var databaseService: DatabaseServiceProtocol?
    private var apiService: APIServiceProtocol?

    required init(databaseService: DatabaseServiceProtocol?, apiService: APIServiceProtocol?) {
        self.databaseService = databaseService
        self.apiService = apiService
    }

    func getObjects<T>(request: DataAccessRequestConvertible, _ closure: ((Response<DataAccessResults<T>, DataAccessError>) -> Void)?) where T: Codable, T: Object {
        if let result: Results<T> = fetchObjectsWithRequest(request: request), !result.isEmpty {
            closure?(.success(result))
        } else {
            apiService?.dataRequest(for: request.remoteDataAccessor).responseArray(completionHandler: { [weak self] (response: DataResponse<[T]>) in
                switch response.result {
                case .success(let objects):
                    do {
                        try self?.databaseService?.commitTransactions {
                            self?.databaseService?.saveObjects(objects: objects)
                        }
                        if let result: Results<T> = self?.fetchObjectsWithRequest(request: request) {
                            closure?(.success(result))
                        }
                    } catch {
                        closure?(.failure(.database))
                    }
                case .failure:
                    guard let statusCode = response.response?.statusCode, let errorType = RemoteError(statusCode: statusCode) else {
                        return
                    }
                    closure?(.failure(.remote(error: errorType)))
                }
            })
        }
    }

    func getObject<T>(request: DataAccessRequestConvertible, _ closure: ((Response<T, DataAccessError>) -> Void)?) where T: Codable, T: Object {
        apiService?.dataRequest(for: request.remoteDataAccessor).responseObject { [weak self] (response: DataResponse<T>) in
            switch response.result {
            case .success(let object):
                do {
                    try self?.databaseService?.commitTransactions {
                        self?.databaseService?.saveObject(object: object)
                    }
                    closure?(.success(object))
                } catch {
                    closure?(.failure(.database))
                }
            case .failure:
                guard let statusCode = response.response?.statusCode, let errorType = RemoteError(statusCode: statusCode) else {
                    return
                }
                closure?(.failure(.remote(error: errorType)))
            }
        }
    }

    func saveObject<T>(request: DataAccessRequestConvertible, _ closure: ((Response<T, DataAccessError>) -> Void)?) where T: Codable, T: Object {
        apiService?.dataRequest(for: request.remoteDataAccessor).responseObject { [weak self] (response: DataResponse<T>) in
            switch response.result {
            case .success(let object):
                do {
                    try self?.databaseService?.commitTransactions {
                        self?.databaseService?.saveObject(object: object)
                    }
                    closure?(.success(object))
                } catch {
                    closure?(.failure(.database))
                }
            case .failure:
                guard let statusCode = response.response?.statusCode, let errorType = RemoteError(statusCode: statusCode) else {
                    return
                }
                closure?(.failure(.remote(error: errorType)))
            }
        }
    }

    func deleteObject(request: DataAccessRequestConvertible, _ closure: ((Response<Void, DataAccessError>) -> Void)?) {
        apiService?.dataRequest(for: request.remoteDataAccessor).response() { [weak self] response in
            if let _ = response.error {
                guard let statusCode = response.response?.statusCode, let errorType = RemoteError(statusCode: statusCode) else {
                    return
                }
                closure?(.failure(.remote(error: errorType)))
                return
            }
            guard let object = request.localDataAccessor.object else {
                closure?(.failure(.database))
                return
            }
            do {
                try self?.databaseService?.commitTransactions {
                    self?.databaseService?.deleteObject(object: object)
                }
                closure?(.success(Void()))
            } catch {
                closure?(.failure(.database))
            }
        }
    }
}

private extension DataAccessService {

    func fetchObjectsWithRequest<T>(request: DataAccessRequestConvertible) -> DataAccessResults<T>? where T: Codable, T: Object {
        if let filter = request.localDataAccessor.filter, let propertySortKey = request.localDataAccessor.propertySortKey {
            return databaseService?.getObjects(filter: filter, sortByKeyPath: propertySortKey)
        } else if let filter = request.localDataAccessor.filter {
            return databaseService?.getObjects(filter: filter)
        } else if let propertySortKey = request.localDataAccessor.propertySortKey {
            return databaseService?.getObjects(sortByKeyPath: propertySortKey)
        } else {
            return databaseService?.getObjects()
        }
    }
}
