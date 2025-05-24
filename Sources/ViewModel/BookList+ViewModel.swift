import Combine
import SwiftUI

extension BookList {
    final class ViewModel: ObservableObject {
        @Published private(set) var books: [BookModel] = []
        @Published private(set) var error: BookRepositoryError?
        
        private let repostiory: BookRepository
        private var cancellables = Set<AnyCancellable>()
        
        init(repository: BookRepository) {
            self.repostiory = repository
            loadBooks()
        }
        
        func loadBooks() {
            repostiory.fetchBooks()
                .sink { [weak self] completion in
                    if case let .failure(error) = completion {
                        self?.error = error
                    }
                } receiveValue: { [weak self] books in
                    self?.books = books
                }
                .store(in: &cancellables)
        }
        
        func deleteBook(_ book: BookModel) {
            repostiory.delete(book: book)
                .sink { [weak self] completion in
                    if case let .failure(error) = completion {
                        self?.error = error
                    } else {
                        self?.loadBooks()
                    }
                } receiveValue: { _ in }
                .store(in: &cancellables)
        }
    }
}
