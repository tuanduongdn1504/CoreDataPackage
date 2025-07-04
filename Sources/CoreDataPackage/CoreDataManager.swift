//
//  CoreDataManager.swift
//
//
//  Created by Duong Tuan on 25/06/2025.
//

import Foundation
import CoreData

public class CoreDataManager {
    private let coreDataStack: CoreDataStack
    
    // Cache GenericRepository<T> instances into dictionary
    private var repositories: [String: Any] = [:]
    
    public init(configuration: CoreDataConfiguration) {
        self.coreDataStack = CoreDataStack(configuration: configuration)
    }
    
    // Using in the main queue for UI's display
    public var mainContext: NSManagedObjectContext {
        return coreDataStack.mainContext
    }
    
    // Using in a private dispatch queue for asynchronous operations
    public func newBackgroundContext() -> NSManagedObjectContext {
        return coreDataStack.newBackgroundContext()
    }
    
    // MARK: - Repository Management
    
    public func getRepository<T: ManagedObjectProtocol>(for type: T.Type) -> GenericRepository<T> {
        let key = String(describing: type)
        
        if let existingRepository = repositories[key] as? GenericRepository<T> {
            return existingRepository
        }
        
        let newRepository = GenericRepository<T>(coreDataStack: coreDataStack)
        repositories[key] = newRepository
        return newRepository
    }
    
    // MARK: - Save Operations
    
    public func save() throws {
        try coreDataStack.saveMainContext()
    }
    
    public func performBackgroundTask<T>(_ block: @escaping (NSManagedObjectContext) throws -> T) async throws -> T {
        return try await coreDataStack.performBackgroundTask(block)
    }
}
