import ComposableArchitecture
import Foundation

@Reducer
public struct BookDetailFeature {
    @ObservableState
    public struct State: Equatable {
        var book: BookModel
        var errorMessage: String?
        
        init(book: BookModel) {
            self.book = book
        }
    }
    
    public enum Action {
        case savePressed
        case saveFailed(String)
    }
    
    @Dependency(\.bookService) var bookService
    
    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .savePressed:
                let book = state.book
                return .run { send in
                    do {
                        _ = try await bookService.updateBook(book)
                    } catch {
                        await send(.saveFailed(error.localizedDescription))
                    }
                }
                
            case let .saveFailed(message):
                state.errorMessage = message
                return .none
            }
        }
    }
}
