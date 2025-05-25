import Foundation

@testable import Bookly

final class BookServiceMock: BookServiceProtocol {
    private(set) var books: [BookModel]
    
    init(
        books: [BookModel] = []) {
        self.books = books
    }
    
    func fetchBooks() async throws -> [BookModel] {
        return books.sorted(by: { $0.title < $1.title })
    }
    
    func updateBook(_ book: BookModel) async throws -> BookModel {
        guard let index = books.firstIndex(of: book) else {
            throw BookServiceError.bookNotFound
        }
        books[index] = book
        return books[index]
    }
    
    func addBook(_ book: BookModel) async throws -> BookModel {
        books.append(book)
        return book
    }
    
    func deleteBook(with id: UUID) async throws {
        guard let index = books.firstIndex(where: { $0.id == id }) else {
            throw BookServiceError.bookNotFound
        }
        books.remove(at: index)
    }
}
