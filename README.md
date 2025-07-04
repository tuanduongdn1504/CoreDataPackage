# CoreDataPackage
A lightweight and reusable Swift Core Data package with generic repository pattern, background task support, and minimal boilerplate.  
Perfect for SwiftUI and UIKit projects that want to reduce repetitive Core Data code.

---

## 🚀 Features

- ✅ Generic Repository (`GenericRepository<T>`) for CRUD
- ✅ Clean context management via `CoreDataManager`
- ✅ Support for **SQLite** and **in-memory** stores
- ✅ Background-safe async operations
- ✅ SwiftUI compatible (`mainContext`)
- ✅ Test-friendly with isolated store configuration

---

## 🛠 Installation

### Swift Package Manager (SPM)

**Option 1 – Xcode UI**

1. In Xcode: `File → Add Packages`
2. Enter package URL: 
```txt
https://github.com/tuanduongdn1504/CoreDataPackage.git
```
3. Select version `1.0.0` or latest

**Option 2 – Or manually, in `Package.swift`**

```swift
.package(url: "https://github.com/tuanduongdn1504/CoreDataPackage.git", from: "1.0.0")
```

---

## 📂 Folder Structure

```txt
Sources/
├── CoreDataPackage/
│   ├── CoreDataConfiguration.swift
│   ├── CoreDataStack.swift
│   ├── CoreDataManager.swift
│   ├── ManagedObjectProtocol.swift
│   ├── GenericRepository.swift
│   ├── CoreDataPackage.swift
```

---

##📁 API Overview

```txt
| Component               | Purpose                                                                 |
| ----------------------- | ----------------------------------------------------------------------- |
| `CoreDataPackage`       | Entry point to create CoreDataManager                                   |
| `CoreDataManager`       | Provides main/background context & manages repositories                 |
| `GenericRepository<T>`  | CRUD operations, background-safe fetch, generic on entity type          |
| `ManagedObjectProtocol` | Required conformance for entities to enable fetch/create/delete helpers |
```

---

## ⚙️ Quick Start

1. Define Your Entity
```swift
import CoreData
import CoreDataPackage

final class Note: NSManagedObject, ManagedObjectProtocol {
    @NSManaged var title: String?
    @NSManaged var createdAt: Date?
}
```

2. Initialize CoreDataManager
```swift
let manager = CoreDataPackage.createManager(
    modelName: "MyModel",
    in: .main,
    storeType: .sqlite
)
```

3. Use Repository
```swift
let repo = manager.repository(for: Note.self)

let note = repo.create()
note.title = "Hello"
note.createdAt = .now
try repo.save()
```

4. Fetch or Count
```swift
let notes = try repo.fetch()
let total = try repo.count()
```

5. Background Fetch
```swift
Task {
    let backgroundNotes = try await repo.fetchInBackground()
}
```

###✅ SwiftUI Integration

```swift
@main
struct MyApp: App {
    let manager = CoreDataPackage.createManager(modelName: "MyModel", in: .main)

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, manager.mainContext)
        }
    }
}
```

###🧪 Unit Testing

Use in-memory store for isolated test environment:
```swift
let testManager = CoreDataPackage.createManager(
    modelName: "MyModel",
    in: .module,
    storeType: .inMemory
)
```
This ensures your tests run quickly and without side effects.

