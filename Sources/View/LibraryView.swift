import SwiftUI

struct LibraryView: View {
    @StateObject private var viewModel: ViewModel
    
    init(viewModel: ViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        List {
            ForEach(viewModel.books) { book in
                NavigationLink {
                    BookDetail(book: book) { updatedBook in
                        viewModel.updateBook(updatedBook)
                    }
                } label: {
                    bookRow(for: book)
                }
            }
        }
        .refreshable {
            viewModel.loadBooks()
        }
        .navigationTitle("Library")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func bookRow(for book: BookModel) -> some View {
        BookRow(book: book)
            .swipeActions {
                Button(role: .destructive) {
                    viewModel.deleteBook(book)
                } label: {
                    Label("Delete", systemImage: "trash.fill")
                }
            }
    }
}

#Preview {
    let persistenceContoller = PersistenceController.preview
    let repository = CoreDataBookRepository(context: persistenceContoller.container.viewContext)
    let viewModel = LibraryView.ViewModel(repository: repository)
    
    NavigationStack {
        LibraryView(viewModel: viewModel)
    }
}
