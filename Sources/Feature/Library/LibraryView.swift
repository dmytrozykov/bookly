import ComposableArchitecture
import SwiftUI

struct LibraryView: View {
    let store: StoreOf<LibraryFeature>
    
    var body: some View {
        Group {
            if store.isLoading && store.books.isEmpty {
                progressView
            } else if store.books.isEmpty {
                unavailableView
            } else {
                bookList
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
        .navigationTitle("Library")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    
                } label: {
                    Label("Add", systemImage: "plus")
                }
            }
        }
    }
    
    private var bookList: some View {
        List {
            ForEach(store.books) { book in
                BookRow(book: book)
            }
        }
        .listStyle(.plain)
        .refreshable {
            store.send(.refresh)
        }
    }
    
    private var progressView: some View {
        ProgressView("Loading books...")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var unavailableView: some View {
        VStack(spacing: 20) {
            Image(systemName: "book.closed")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                 Text("No Books Yet")
                     .font(.title3)
                     .fontWeight(.semibold)
                 
                 Text("Add your first book to get started")
                     .font(.body)
                     .foregroundColor(.secondary)
                     .multilineTextAlignment(.center)
             }
        }
    }
}

#Preview {
    NavigationStack {
        LibraryView(
            store: Store(initialState: LibraryFeature.State()) {
                LibraryFeature()
            } withDependencies: {
                $0.bookService = BookService.preview
            }
        )
    }
}
