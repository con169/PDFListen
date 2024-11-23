import SwiftUI
import CoreData

@main
struct PDFListenApp: App {
    // Set up Core Data's persistent container
    let persistentContainer: NSPersistentContainer

    init() {
        // Initialize the NSPersistentContainer with your Core Data model name
        persistentContainer = NSPersistentContainer(name: "BookDataModel") // Replace with your Core Data model name
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }

        // Set the context for CoreDataManager
        CoreDataManager.shared.setContext(persistentContainer.viewContext)
    }

    var body: some Scene {
        WindowGroup {
            #if os(iOS)
            ContentView()
                .environment(\.managedObjectContext, persistentContainer.viewContext)
            #else
            // Provide a fallback or placeholder view for non-iOS platforms
            Text("This app is currently supported only on iOS.")
            #endif
        }
    }
}
