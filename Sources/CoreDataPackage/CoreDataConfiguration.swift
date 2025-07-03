//
//  CoreDataConfiguration.swift
//
//
//  Created by Duong Tuan on 25/06/2025.
//

import Foundation
import CoreData

public struct CoreDataConfiguration {
    public let modelName: String
    public let bundle: Bundle
    public let storeType: String
    public let storeURL: URL?
    public let options: [String: Any]?
    
    public init(
        modelName: String,
        bundle: Bundle,
        storeType: String = NSSQLiteStoreType,
        storeURL: URL? = nil,
        options: [String : Any]? = nil
    ) {
        self.modelName = modelName
        self.bundle = bundle
        self.storeType = storeType
        self.storeURL = storeURL
        self.options = options
    }
    
    // Default configuration for in-memory store (useful for testing)
    public static func inMemory(modelName: String, bundle: Bundle) -> CoreDataConfiguration {
        return CoreDataConfiguration(
            modelName: modelName,
            bundle: bundle,
            storeType: NSInMemoryStoreType
        )
    }
    
    // Default configuration for SQLite store
    public static func sqlite(modelName: String, bundle: Bundle, fileName: String? = nil) -> CoreDataConfiguration {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let storeURL = documentsPath.appendingPathComponent("\(fileName ?? modelName).sqlite")
        
        return CoreDataConfiguration(
            modelName: modelName,
            bundle: bundle,
            storeURL: storeURL,
            options: [
                NSMigratePersistentStoresAutomaticallyOption: true,
                NSInferMappingModelAutomaticallyOption: true
            ]
        )
    }
}
