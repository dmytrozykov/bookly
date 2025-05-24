import Combine
import CoreData
import Foundation

protocol BookServiceProtocol {
    func fetchBooks() async throws -> [BookModel]
    func updateBook(_ book: BookModel) async throws -> BookModel
    func addBook(_ book: BookModel) async throws -> BookModel
    func deleteBook(with id: UUID) async throws
}

enum BookServiceError: Error, LocalizedError {
    case bookNotFound
    
    var errorDescription: String? {
        switch self {
        case .bookNotFound:
            return "Book not found"
        }
    }
}

final class BookService: BookServiceProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.context = context
    }
    
    func fetchBooks() async throws -> [BookModel] {
        try await withCheckedThrowingContinuation { continuation in
            context.perform {
                let request = Book.fetchRequest()
                request.sortDescriptors = [NSSortDescriptor(keyPath: \Book.title, ascending: true)]
                
                do {
                    let result = try self.context.fetch(request)
                    let books = result.map(BookModel.init)
                    continuation.resume(returning: books)
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func updateBook(_ book: BookModel) async throws -> BookModel {
        try await withCheckedThrowingContinuation { continuation in
            context.perform {
                let request = Book.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", book.id as CVarArg)
                
                do {
                    let result = try self.context.fetch(request)
                    guard let bookEntity = result.first else {
                        continuation.resume(throwing: BookServiceError.bookNotFound)
                        return
                    }
                    
                    self.updateBook(bookEntity, with: book)
                    try self.context.save()
                    continuation.resume(returning: BookModel(from: bookEntity))
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func addBook(_ book: BookModel) async throws -> BookModel {
        try await withCheckedThrowingContinuation { continuation in
            context.perform {
                let bookEntity = Book(context: self.context)
                self.updateBook(bookEntity, with: book)
                
                do {
                    try self.context.save()
                    continuation.resume(returning: BookModel(from: bookEntity))
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func deleteBook(with id: UUID) async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>)  in
            context.perform {
                let request = Book.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
                
                do {
                    let books = try self.context.fetch(request)
                    guard let book = books.first else {
                        continuation.resume(throwing: BookServiceError.bookNotFound)
                        return
                    }
                    
                    self.context.delete(book)
                    try self.context.save()
                    continuation.resume(returning: ())
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    private func updateBook(_ book: Book, with model: BookModel) {
        book.id = model.id
        book.title = model.title
        book.author = model.author
        book.isbn = model.isbn
        book.pageCount = Int32(model.pageCount)
        book.currentPage = Int32(model.currentPage)
    }
}
