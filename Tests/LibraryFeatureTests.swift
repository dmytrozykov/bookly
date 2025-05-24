import ComposableArchitecture
import Foundation
import Testing

@testable import Bookly

@MainActor
struct LibraryFeatureTests {
    @Test
    func onAppearLoadsBooks() async {
        let books = mockBooks
        let store = TestStore(initialState: LibraryFeature.State()) {
            LibraryFeature()
        } withDependencies: { values in
            values.bookService = BookServiceMock(books: books)
        }
        
        await store.send(.onAppear) {
            $0.isLoading = true
        }
        
        await store.receive(\.booksLoaded) {
            $0.isLoading = false
            $0.books = books
            $0.errorMessage = nil
        }
    }
    
    private var mockBooks: [BookModel] = [
        .init(
            id: UUID(),
            title: "1984",
            author: "George Orwell",
            isbn: "4523485278548",
            pageCount: 198,
            currentPage: 84
        ),
        .init(
            id: UUID(),
            title: "The Alchemist",
            author: "Paulo Coelho",
            isbn: "452984357298",
            pageCount: 227,
            currentPage: 34
        )
    ]
}
