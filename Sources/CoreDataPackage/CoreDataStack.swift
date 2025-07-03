//
//  CoreDataStack.swift
//
//
//  Created by Duong Tuan on 25/06/2025.
//

import Foundation
import CoreData

public class CoreDataStack {
    private let configuration: CoreDataConfiguration
    
    public init(configuration: CoreDataConfiguration) {
        self.configuration = configuration
    }
    
    // MARK: - Core Data Stack
    
    public lazy var managedObjectModel: NSManagedObjectModel = {
        // Searching URL in bundle
        guard let modelURL = configuration.bundle.url(
            forResource: configuration.modelName,
            withExtension: "momd"
        ) else {
            fatalError("Failed to find model file: \(configuration.modelName).momd in bundle: \(configuration.bundle)")
        }
        
        // Initialize NSManagedObjectModel from URL
        guard let model = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Failed to create model from: \(modelURL)")
        }
        
        return model
    }()
    
    public lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        do {
            try coordinator.addPersistentStore(
                ofType: configuration.storeType,
                configurationName: nil,
                at: configuration.storeURL,
                options: configuration.options
            )
        } catch {
            fatalError("Failed to add persistent store: \(error)")
        }
        
        return coordinator
    }()
    
    public lazy var mainContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        return context
    }()
    
    public func newBackgroundContext() -> NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }
    
    // MARK: - Save Operations
    
    public func saveMainContext() throws {
        if mainContext.hasChanges {
            try mainContext.save()
        }
    }
    
    public func saveContext(_ context: NSManagedObjectContext) throws {
        if context.hasChanges {
            try context.save()
            
            if context.parent != nil {
                try saveMainContext()
            }
        }
    }
    
    public func performBackgroundTask<T>(_ block: @escaping (NSManagedObjectContext) throws -> T) async throws -> T {
        let context = newBackgroundContext()
        
        return try await withCheckedThrowingContinuation {
            continuation in context.perform {
                do {
                    let result = try block(context)
                    try self.saveContext(context)
                    continuation.resume(returning: result)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
