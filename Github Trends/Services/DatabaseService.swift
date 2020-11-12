//
//  DatabaseService.swift
//  Github Trends
//
//  Created by Samuel Tremblay on 2020-11-10.
//  Copyright © 2020 Samuel Tremblay. All rights reserved.
//

import RealmSwift

/// Service protocol definition
protocol DatabaseServiceProtocol {

    /// All operations to objects that need to be reflected to the local db (ie. 'save' and 'delete') have to be performed within a transaction block
    ///
    /// - Parameter closure: The opration which needs to be reflected in the local db
    /// - Throws: If the db operation cannot be performed an exception will be thrown
    func commitTransactions(_ closure: (() -> Void)?) throws

    /// Generic function to save an unmanaged object to the db
    ///
    /// - Parameters:
    ///   - type: The object type
    ///   - parameters: The properties and their values that should be set on the saved object
    /// - Returns: The saved object
    func saveObject<T: Object>(type: T, parameters: [String: Any]) -> T

    /// Generic function to save an object to the db
    ///
    /// - Parameter object: The object to save
    /// - Returns: The saved object
    func saveObject<T: Object>(object: T)

    /// Generic function to save multiple objects to the db
    ///
    /// - Parameter objects: The objects to save
    /// - Returns: The saved objects
    func saveObjects<T: Object>(objects: [T])

    /// Generic function to retrieve multiple objects from the db
    ///
    /// - Returns: The retrieved results object. If nil, no objects were found
    func getObjects<T: Object>() -> Results<T>?

    /// Generic function to retrieve multiple objects from the db according to a given key path value
    ///
    /// - Parameter keyPath: The key path value
    /// - Returns: The retrieved results object. If nil, no objects were found
    func getObjects<T: Object>(sortByKeyPath keyPath: String) -> Results<T>?

    /// Generic function to retrieve multiple objects from the db according to a given key path value
    ///
    /// - Parameters:
    ///   - keyPath: The key path value
    ///   - ascending: Boolean value corresponding to the order of the retrieved objects
    /// - Returns: The retrieved results object. If nil, no objects were found
    func getObjects<T: Object>(sortByKeyPath keyPath: String, ascending: Bool) -> Results<T>?

    /// Generic function to retrieve multiple objects from the db according to a given query filter
    ///
    /// - Parameter filter: The filter used to perform the query
    /// - Returns: The retrieved results object. If nil, no objects were found
    func getObjects<T: Object>(filter: NSPredicate) -> Results<T>?

    /// Generic function to retrieve multiple objects from the db according to a given query filter and a given key path value
    ///
    /// - Parameters:
    ///   - filter: The filter used to perform the query
    ///   - keyPath: The key path value
    /// - Returns: The retrieved results object. If nil, no objects were found
    func getObjects<T: Object>(filter: NSPredicate, sortByKeyPath keyPath: String) -> Results<T>?

    /// Generic function to retrieve multiple objects from the db according to a given query filter and a given key path value
    ///
    /// - Parameters:
    ///   - filter: The filter used to perform the query
    ///   - keyPath: The key path value
    ///   - ascending: Boolean value corresponding to the order of the retrieved objects
    /// - Returns: The retrieved results object. If nil, no objects were found
    func getObjects<T: Object>(filter: NSPredicate, sortByKeyPath keyPath: String, ascending: Bool) -> Results<T>?

    /// Generic function to retrieve a single object from the db according to a primary key
    ///
    /// - Parameter id: The object's primary key
    /// - Returns: The found object, otherwise nil
    func getObject<T: Object>(id: String) -> T?

    /// Delete a given object from the db
    ///
    /// - Parameter object: The object to delete
    func deleteObject(object: Object)

    /// Delete multiple objects from the db
    ///
    /// - Parameter objects: The results object used to delete the objects
    func deleteObjects<T>(objects: Results<T>) where T: Object

    /// Perform any neede db migrations
    func performMigrations()
}

final class DatabaseService: DatabaseServiceProtocol {

    private let realm: Realm?

    required init() {
        realm = try? Realm()
    }

    func commitTransactions(_ closure: (() -> Void)?) throws {
        try realm?.write {
            closure?()
        }
    }

    func saveObject<T: Object>(type: T, parameters: [String : Any]) -> T {
        let object = T()
        for (key, value) in parameters {
            object.setValue(value, forKey: key)
        }
        realm?.add(object)
        return object
    }

    func saveObject<T : Object>(object: T) {
        realm?.add(object)
    }

    func saveObjects<T : Object>(objects: [T]) {
        objects.forEach {
            realm?.add($0)
        }
    }

    func getObjects<T: Object>() -> Results<T>? {
        realm?.objects(T.self)
    }

    func getObjects<T: Object>(sortByKeyPath keyPath: String) -> Results<T>? {
        realm?.objects(T.self).sorted(byKeyPath: keyPath, ascending: true)
    }

    func getObjects<T: Object>(sortByKeyPath keyPath: String, ascending: Bool) -> Results<T>? {
        realm?.objects(T.self).sorted(byKeyPath: keyPath, ascending: ascending)
    }

    func getObjects<T: Object>(filter: NSPredicate) -> Results<T>? {
        realm?.objects(T.self).filter(filter)
    }

    func getObjects<T: Object>(filter: NSPredicate, sortByKeyPath keyPath: String) -> Results<T>? {
        realm?.objects(T.self).filter(filter).sorted(byKeyPath: keyPath, ascending: true)
    }

    func getObjects<T: Object>(filter: NSPredicate, sortByKeyPath keyPath: String, ascending: Bool) -> Results<T>? {
        realm?.objects(T.self).filter(filter).sorted(byKeyPath: keyPath, ascending: ascending)
    }

    func getObject<T: Object>(id: String) -> T? {
        realm?.object(ofType: T.self, forPrimaryKey: id)
    }

    func deleteObject(object: Object) {
        realm?.delete(object)
    }

    func deleteObjects<T>(objects: Results<T>) where T: Object {
        objects.forEach {
            deleteObject(object: $0)
        }
    }

    func performMigrations() {
        let config = Realm.Configuration(
            // Set the new schema version. This must be greater than the previously used
            // version (if you've never set a schema version before, the version is 0).
            schemaVersion: 1,

            // Set the block which will be called automatically when opening a Realm with
            // a schema version lower than the one set above
            migrationBlock: { migration, oldSchemaVersion in
                // We haven’t migrated anything yet, so oldSchemaVersion == 0
                if (oldSchemaVersion < 1) {
                    // Nothing to do!
                    // Realm will automatically detect new properties and removed properties
                    // And will update the schema on disk automatically
                }
        })

        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config
    }
}
