//
//  ManagedObjectProtocol.swift
//
//
//  Created by Duong Tuan on 25/06/2025.
//

import Foundation
import CoreData

public protocol ManagedObjectProtocol: NSManagedObject {
    static var entityName: String { get }
}

public extension ManagedObjectProtocol {
    static var entityName: String {
        return String(describing: self)
    }
    
    static func fetchRequest() -> NSFetchRequest<Self> {
        return NSFetchRequest<Self>(entityName: entityName)
    }
    
    static func create(in context: NSManagedObjectContext) -> Self {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: context) as! Self
    }
    
    static func fetch(
        in context: NSManagedObjectContext,
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil,
        limit: Int? = nil
    ) throws -> [Self] {
        let request = fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        if let limit = limit {
            request.fetchLimit = limit
        }
        return try context.fetch(request)
    }
    
    static func fetchFirst(
        in context: NSManagedObjectContext,
        predicate: NSPredicate? = nil,
        sortDescriptors: [NSSortDescriptor]? = nil
    ) throws -> Self? {
        return try fetch(in: context, predicate: predicate, sortDescriptors: sortDescriptors, limit: 1).first
    }
    
    static func count(in context: NSManagedObjectContext, predicate: NSPredicate? = nil) throws -> Int {
        let request = fetchRequest()
        request.predicate = predicate
        return try context.count(for: request)
    }
    
    func delete() {
        managedObjectContext?.delete(self)
    }
}
