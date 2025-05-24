import SwiftUI

struct BookList: View {
    @StateObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        List {
            ForEach(viewModel.books) { book in
                Text(book.title)
            }
        }
    }
}

#Preview {
    let persistenceContoller = PersistenceController.preview
    let repository = CoreDataBookRepository(context: persistenceContoller.container.viewContext)
    let viewModel = BookList.ViewModel(repository: repository)
    
    BookList(viewModel: viewModel)
}
