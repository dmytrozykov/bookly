import Combine
import CoreData
import Foundation

protocol BookRepositoryProtocol {
    func fetchBooks() -> AnyPublisher<[BookModel], Error>
    func update(book: BookModel) -> AnyPublisher<Void, Error>
    func add(book: BookModel) -> AnyPublisher<Void, Error>
    func delete(book: BookModel) -> AnyPublisher<Void, Error>
}

enum BookRepositoryError: Error, LocalizedError {
    case bookNotFound
    
    var errorDescription: String? {
        switch self {
        case .bookNotFound:
            return "Book not found"
        }
    }
}

final class BookRepository: BookRepositoryProtocol {
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    func fetchBooks() -> AnyPublisher<[BookModel], Error> {
        Future { promise in
            self.context.perform {
                let request = Book.fetchRequest()
                request.sortDescriptors = [.init(keyPath: \Book.title, ascending: true)]
                
                do {
                    let books = try self.context.fetch(request)
                    promise(.success(books.compactMap { $0.bookModel }))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func update(book: BookModel) -> AnyPublisher<Void, Error> {
        Future { promise in
            self.context.perform {
                let request = Book.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", book.id as CVarArg)
                
                do {
                    let books = try self.context.fetch(request)
                    
                    guard let bookEntity = books.first else {
                        promise(.failure(BookRepositoryError.bookNotFound))
                        return
                    }
                    
                    bookEntity.title = book.title
                    bookEntity.author = book.author
                    bookEntity.isbn = book.isbn
                    bookEntity.pageCount = Int16(book.pageCount)
                    bookEntity.currentPage = Int16(book.currentPage)
                    
                    try self.context.save()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func add(book: BookModel) -> AnyPublisher<Void, Error> {
        Future { promise in
            self.context.perform {
                let newBook = Book(context: self.context)
                newBook.id = book.id
                newBook.title = book.title
                newBook.author = book.author
                newBook.pageCount = Int16(book.pageCount)
                newBook.currentPage = Int16(book.currentPage)
                
                do {
                    try self.context.save()
                    promise(.success(()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    func delete(book: BookModel) -> AnyPublisher<Void, Error> {
        Future { promise in
            self.context.perform {
                let request = Book.fetchRequest()
                request.predicate = NSPredicate(format: "id == %@", book.id as CVarArg)
                
                do {
                    guard let bookToDelete = try self.context.fetch(request).first else {
                        promise(.failure(BookRepositoryError.bookNotFound))
                        return
                    }
                    
                    self.context.delete(bookToDelete)
                    try self.context.save()
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
