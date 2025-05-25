import ComposableArchitecture
import Foundation
import Testing

@testable import Bookly

@MainActor
struct LibraryFeatureTests {
    @Test
    func onAppear() async {
        let books = makeSampleBooks()
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
    
    @Test
    func refresh() async {
        let books = makeSampleBooks()
        let store = TestStore(initialState: LibraryFeature.State()) {
            LibraryFeature()
        } withDependencies: { values in
            values.bookService = BookServiceMock(books: books)
        }
        
        await store.send(.refresh) {
            $0.isLoading = true
        }
        
        await store.receive(\.booksLoaded) {
            $0.isLoading = false
            $0.books = books
            $0.errorMessage = nil
        }
    }
    
    @Test
    func addBookFlow() async {
        let store = TestStore(initialState: LibraryFeature.State()) {
            LibraryFeature()
        } withDependencies: {
            $0.bookService = BookServiceMock(books: [])
            $0.uuid = .incrementing
        }
        store.exhaustivity = .off
        
        let testBook = BookModel(
            id: UUID(0),
            title: "The Alchemist",
            author: "Paulo Coelho",
            isbn: "452984357298",
            pageCount: 227,
            currentPage: 0
        )
        
        await store.send(.addButtonTapped)
        await store.send(\.destination.addBook.setTitle, testBook.title)
        await store.send(\.destination.addBook.setAuthor, testBook.author)
        await store.send(\.destination.addBook.setIsbn, testBook.isbn)
        await store.send(\.destination.addBook.setPageCount, testBook.pageCount)
        await store.send(\.destination.addBook.saveButtonTapped)
        await store.skipReceivedActions()
        store.assert {
            $0.books = [
                testBook
            ]
            $0.destination = nil
        }
    }
    
    @Test
    func deleteBook() async {
        var books = makeSampleBooks()
        let store = TestStore(initialState: LibraryFeature.State()) {
            LibraryFeature()
        } withDependencies: { values in
            values.bookService = BookServiceMock(books: books)
        }
        
        await store.send(.deleteButtonTapped(id: UUID(1))) {
            $0.destination = .alert(.deleteConfirmation(id: UUID(1)))
        }
        books.remove(at: 1)
        
        await store.send(\.destination.alert.confirmDeletion, UUID(1)) {
            $0.destination = nil
        }
        await store.receive(\.refresh) {
            $0.isLoading = true
        }
        await store.receive(\.booksLoaded) {
            $0.isLoading = false
            $0.books = books
            $0.errorMessage = nil
        }
    }
}

extension LibraryFeatureTests {
    private func makeSampleBooks() -> [BookModel] {
        [
            .init(
                id: UUID(0),
                title: "1984",
                author: "George Orwell",
                isbn: "4523485278548",
                pageCount: 198,
                currentPage: 84
            ),
            .init(
                id: UUID(1),
                title: "The Alchemist",
                author: "Paulo Coelho",
                isbn: "452984357298",
                pageCount: 227,
                currentPage: 34
            )
        ]
    }
}
