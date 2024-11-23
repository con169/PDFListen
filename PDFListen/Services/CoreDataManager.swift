import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    private var context: NSManagedObjectContext?

    private init() {} // Singleton

    // Set the context (used when initializing from SwiftUI)
    func setContext(_ context: NSManagedObjectContext) {
        self.context = context
    }

    // Function to save PDF metadata
    func savePDFMetadata(url: URL) {
        guard let context = context else {
            print("ManagedObjectContext not set.")
            return
        }

        let book = Book(context: context)
        book.title = url.lastPathComponent
        book.filePath = url.path
        //book.importDate = Date()

        do {
            try context.save()
            print("Book metadata saved successfully in Core Data.")
        } catch {
            print("Failed to save book metadata to Core Data: \(error)")
        }
    }

    // Function to fetch saved books
    func fetchBooks() -> [Book] {
        guard let context = context else {
            print("ManagedObjectContext not set.")
            return []
        }

        let fetchRequest: NSFetchRequest<Book> = Book.fetchRequest()

        do {
            let books = try context.fetch(fetchRequest)
            return books
        } catch {
            print("Failed to fetch books: \(error)")
            return []
        }
    }
}
