import SwiftUI

@main
struct BooklyApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            let repository = CoreDataBookRepository(context: persistenceController.container.viewContext)
            let viewModel = LibraryView.ViewModel(repository: repository)
            
            NavigationStack {
                LibraryView(viewModel: viewModel)
            }
        }
    }
}
