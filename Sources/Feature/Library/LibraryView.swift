import ComposableArchitecture
import SwiftUI

struct LibraryView: View {
    @ComposableArchitecture.Bindable
    var store: StoreOf<LibraryFeature>
    
    private var isEmptyAndLoading: Bool {
        store.isLoading && store.books.isEmpty
    }
    
    var body: some View {
        contentView
            .onAppear { store.send(.onAppear) }
            .navigationTitle("Library")
            .toolbar { toolbarContent }
            .sheet(item: addBookBinding) { addBookStore in
                NavigationStack {
                    AddBookView(store: addBookStore)
                }
            }
            .alert(alertBinding)
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch (isEmptyAndLoading, store.books.isEmpty) {
        case (true, _):
            loadingView
        case (false, true):
            emptyStateView
        default:
            bookListView
        }
    }
    
    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .primaryAction) {
            Button("Add", systemImage: "plus.circle.fill") {
                store.send(.addButtonTapped)
            }
        }
    }
    
    private var addBookBinding: Binding<StoreOf<AddBookFeature>?> {
        $store.scope(state: \.destination?.addBook, action: \.destination.addBook)
    }
    
    private var alertBinding: Binding<Store<AlertState<LibraryFeature.Action.Alert>, LibraryFeature.Action.Alert>?> {
        $store.scope(state: \.destination?.alert, action: \.destination.alert)
    }
    
    private var bookListView: some View {
        List {
            ForEach(store.books) { book in
                bookRow(for: book)
            }
        }
        .listStyle(.plain)
        .refreshable { store.send(.refresh) }
        .searchable(text: searchBinding)
    }
    
    private func bookRow(for book: BookModel) -> some View {
        BookRow(book: book)
            .swipeActions { deleteSwipeAction(for: book) }
            .listRowSeparator(.hidden, edges: .all)
    }
    
    @ViewBuilder
    private func deleteSwipeAction(for book: BookModel) -> some View {
        Button("Delete", systemImage: "trash") {
            store.send(.deleteButtonTapped(id: book.id))
        }
        .tint(.red)
    }
    
    private var searchBinding: Binding<String> {
        // TODO: Implement search
        .constant("")
    }
    
    private var loadingView: some View {
        ProgressView("Loading books...")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            emptyStateIcon
            emptyStateText
        }
    }
    
    private var emptyStateIcon: some View {
        Image(systemName: "book.closed")
            .font(.system(size: 60))
            .foregroundColor(.secondary)
    }
    
    private var emptyStateText: some View {
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
