import ComposableArchitecture
import SwiftUI

struct LibraryView: View {
    let store: StoreOf<LibraryFeature>
    
    var body: some View {
        List {
            ForEach(store.books) { book in
                BookRow(book: book)
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
        .refreshable {
            store.send(.refresh)
        }
        .navigationTitle("Library")
        .navigationBarTitleDisplayMode(.inline)
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
