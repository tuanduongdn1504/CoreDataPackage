//
//  EcommerceDataManager.swift
//  SimpleExample
//
//  Created by Duong Tuan on 29/06/2025.
//

import Foundation
import CoreDataPackage

/// EcommerceDataManager is a Singleton which manages the
/// coredata core operations like creating containers, context and handles saving of the data
class EcommerceDataManager: ObservableObject {
    static let shared = EcommerceDataManager()
    
    private let coreDataManager: CoreDataManager
    
    private init() {
        // Bundle.main contains your EcommerceModel.xcdatamodeld
        self.coreDataManager = CoreDataPackage.createManager(
            modelName: "EcommerceModel",
            in: .main
        )
    }
    
    lazy var mainContext = coreDataManager.mainContext
    
    func save() throws {
        try coreDataManager.save()
    }
}
