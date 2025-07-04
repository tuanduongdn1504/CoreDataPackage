//
//  GenericRepository.swift
//
//
//  Created by Duong Tuan on 25/06/2025.
//

import Foundation
import CoreData

public class GenericRepository<T: ManagedObjectProtocol> {
    private let coreDataStack: CoreDataStack
    
    public init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }
    
    public var mainContext: NSManagedObjectContext {
        return coreDataStack.mainContext
    }
    
    // MARK: - CRUD Operations
    
    public func create() -> T {
        return T.create(in: mainContext)
    }
    
    public func fetch(
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil,
        limit: Int? = nil
    ) throws -> [T] {
        return try T.fetch(in: mainContext, predicate: predicate, sortDescriptors: sortDescriptors, limit: limit)
    }
    
    public func fetchFirst(
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil
    ) throws -> T? {
        return try T.fetchFirst(in: mainContext, predicate: predicate, sortDescriptors: sortDescriptors)
    }
    
    public func count(predicate: NSPredicate? = nil) throws -> Int {
        return try T.count(in: mainContext, predicate: predicate)
    }
    
    public func delete(_ object: T) {
        object.delete()
    }
    
    public func save() throws {
        try coreDataStack.saveMainContext()
    }
    
    // MARK: - Background Operations
    
    public func performBackgroundTask<Result>(_ block: @escaping (NSManagedObjectContext) throws -> Result) async throws -> Result {
        return try await coreDataStack.performBackgroundTask { context in
            return try block(context)
        }
    }
    
    public func fetchInBackground(
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil,
        limit: Int? = nil
    ) async throws -> [T] {
        return try await performBackgroundTask { context in
            return try T.fetch(in: context, predicate: predicate, sortDescriptors: sortDescriptors, limit: limit)
        }
    }
}
