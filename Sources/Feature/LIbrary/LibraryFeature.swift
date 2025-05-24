import ComposableArchitecture
import Foundation

@Reducer
struct LibraryFeature {
    @ObservableState
    struct State: Equatable {
        var books: [BookModel] = []
        var isLoading = false
        var errorMessage: String?
    }
    
    enum Action {
        case onAppear
        case refresh
        case booksLoaded([BookModel])
        case loadingError(String)
    }
    
    @Dependency(\.bookService) var bookService
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear, .refresh:
                state.isLoading = true
                return .run { send in
                    do {
                        let books = try await bookService.fetchBooks()
                        await send(.booksLoaded(books))
                    } catch {
                        await send(.loadingError(error.localizedDescription))
                    }
                }
                
            case let .booksLoaded(books):
                state.isLoading = false
                state.books = books
                state.errorMessage = nil
                return .none
                
            case let .loadingError(message):
                state.isLoading = false
                state.errorMessage = message
                return .none
            }
        }
    }
}
