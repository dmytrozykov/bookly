import ComposableArchitecture
import Foundation

@Reducer
public struct LibraryFeature {
    @ObservableState
    public struct State: Equatable {
        @Presents var addBook: AddBookFeature.State?
        
        var books: [BookModel] = []
        var isLoading = false
        var errorMessage: String?
    }
    
    public enum Action {
        case onAppear
        case refresh
        case booksLoaded([BookModel])
        case loadingError(String)
        case addButtonTapped
        case addBook(PresentationAction<AddBookFeature.Action>)
        case savingError(String)
    }
    
    @Dependency(\.bookService) var bookService
    
    public var body: some ReducerOf<Self> {
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
                
            case .addButtonTapped:
                state.addBook = AddBookFeature.State(book: BookModel())
                return .none
                
            case let .addBook(.presented(.delegate(.saveBook(book)))):
                return .run { send in
                    do {
                        _ = try await bookService.addBook(book)
                        await send(.refresh)
                    } catch {
                        await send(.savingError(error.localizedDescription))
                    }
                }
                
            case let .savingError(message):
                state.errorMessage = message
                return .none
                
            case .addBook:
                return .none
            }
        }
        .ifLet(\.$addBook, action: \.addBook) {
            AddBookFeature()
        }
    }
}
