import SwiftUI

@main
struct BooklyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            let repository = CoreDataBookRepository(context: persistenceController.container.viewContext)
            let viewModel = BookList.ViewModel(repository: repository)
            
            BookList(viewModel: viewModel)
        }
    }
}
