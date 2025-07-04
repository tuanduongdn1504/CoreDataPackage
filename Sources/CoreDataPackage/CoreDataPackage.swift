// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public struct CoreDataPackage {
    public static let version = "1.0.0"
    
    public static func createManager(with configuration: CoreDataConfiguration) -> CoreDataManager {
        return CoreDataManager(configuration: configuration)
    }
    
    // Convenience methods for common configurations
    public static func createManager(
        modelName: String,
        in bundle: Bundle,
        storeType: CoreDataStoreType = .sqlite
    ) -> CoreDataManager {
        let config: CoreDataConfiguration
        
        switch storeType {
        case .sqlite:
            config = .sqlite(modelName: modelName, bundle: bundle)
        case .inMemory:
            config = .inMemory(modelName: modelName, bundle: bundle)
        }
        
        return createManager(with: config)
    }
}

public enum CoreDataStoreType {
    case sqlite
    case inMemory
}

// MARK: - Another way to use CoreData if app targets iOS 10+, macOS 10.12+, tvOS 10+, watchOS 3+, or visionOS 1+

//open class PersistentContainer: NSPersistentContainer {
//    lazy public var persistentContainer: PersistentContainer? = {
//        guard let modelURL = Bundle.module.url(forResource:"CoreDataXC", withExtension: "momd") else { return  nil }
//        guard let model = NSManagedObjectModel(contentsOf: modelURL) else { return nil }
//        let container = PersistentContainer(name:"CoreDataXC",managedObjectModel:model)
//        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
//            if let error = error as NSError? {
//                print("Unresolved error \(error), \(error.userInfo)")
//            }
//        })
//        return container
//    }()
//}
