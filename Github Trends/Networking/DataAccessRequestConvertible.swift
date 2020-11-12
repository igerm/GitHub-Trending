//
//  DataAccessRequestConvertible.swift
//  Github Trends
//
//  Created by Samuel Tremblay on 2020-11-10.
//  Copyright © 2020 Samuel Tremblay. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire

typealias DataAccessResults<T> = Results<T> where T: Object

public typealias RemoteDataAccessor = URLRequestConvertible
public typealias LocalDataAccessor = (object: Object?, id: String?, filter: NSPredicate?, propertySortKey: String?, ascending: Bool)

public protocol DataAccessRequestConvertible {
    var remoteDataAccessor: RemoteDataAccessor { get }
    var localDataAccessor: LocalDataAccessor { get }
}
