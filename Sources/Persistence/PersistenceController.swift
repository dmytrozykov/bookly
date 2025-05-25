import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for (index, data) in [
            ("Clean Code", "Robert C. Martin", 123, 464, "9780132350884"),
            ("The Pragmatic Programmer", "Andrew Hunt & David Thomas", 88, 352, "9780135957059"),
            ("Design Patterns", "Erich Gamma et al.", 300, 395, "9780201633610"),
            ("You Don't Know JS Yet", "Kyle Simpson", 0, 143, "9781091210096"),
            ("Introduction to Algorithms", "Thomas H. Cormen", 210, 1312, "9780262033848"),
            ("Refactoring", "Martin Fowler", 91, 448, "9780201485677"),
            ("The Mythical Man-Month", "Frederick P. Brooks Jr.", 336, 336, "9780201835953"),
            ("Code Complete", "Steve McConnell", 142, 960, "9780735619678"),
            ("Working Effectively with Legacy Code", "Michael Feathers", 367, 456, "9780131177055"),
            ("Structure and Interpretation of Computer Programs", "Harold Abelson & Gerald Jay Sussman", 10, 657, "9780262510875")
        ].enumerated() {
            let newBook = Book(context: viewContext)
            newBook.title = data.0
            newBook.author = data.1
            newBook.currentPage = Int32(data.2)
            newBook.pageCount = Int32(data.3)
            newBook.id = UUID()
            newBook.isbn = data.4
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "Bookly")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
